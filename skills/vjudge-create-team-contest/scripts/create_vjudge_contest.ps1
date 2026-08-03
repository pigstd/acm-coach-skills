[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^https://qoj\.ac/contest/\d+/?$')]
    [string]$QojContestUrl,

    [Parameter(Mandatory = $true)]
    [ValidateRange(1, 999)]
    [int]$Round,

    [Parameter(Mandatory = $true)]
    [string]$BeginTime,

    [Parameter(Mandatory = $true)]
    [string]$ProblemNumbers,

    [string]$ConfigPath,
    [switch]$Commit
)

$ErrorActionPreference = 'Stop'
$baseUrl = 'https://vjudge.net'

if (-not $ConfigPath) {
    $codexRoot = if ($env:CODEX_HOME) {
        $env:CODEX_HOME
    } elseif ($env:USERPROFILE) {
        Join-Path $env:USERPROFILE '.codex'
    } else {
        throw 'Cannot locate the ACM coach config. Pass -ConfigPath explicitly.'
    }
    $ConfigPath = Join-Path $codexRoot 'acm-coach\config.json'
}
if (-not (Test-Path -LiteralPath $ConfigPath)) {
    throw "ACM coach config not found: $ConfigPath"
}
$config = Get-Content -LiteralPath $ConfigPath -Raw -Encoding UTF8 | ConvertFrom-Json

$groupId = $config.vjudge.group.id
$groupShortName = $config.vjudge.group.shortName
$groupName = $config.vjudge.group.name
$titleTemplate = $config.vjudge.contestTitleTemplate
if (-not $groupId -or -not $groupShortName -or -not $titleTemplate) {
    throw 'Config must define vjudge.group.id, vjudge.group.shortName, and vjudge.contestTitleTemplate.'
}

$organization = [string]$config.organization.name
$season = [string]$config.organization.season
$title = $titleTemplate.Replace('{organization}', $organization).Replace('{season}', $season).Replace('{round}', [string]$Round)
$title = (($title -replace '\s+', ' ').Trim())
if (-not $title) {
    throw 'The configured contest title template produced an empty title.'
}

$durationMinutes = if ($config.vjudge.defaults.durationMinutes) { [int]$config.vjudge.defaults.durationMinutes } else { 300 }
$penaltySeconds = if ($config.vjudge.defaults.wrongAttemptPenaltySeconds) { [int]$config.vjudge.defaults.wrongAttemptPenaltySeconds } else { 1200 }
$freezeMinutes = if ($null -ne $config.vjudge.defaults.freezeMinutesBeforeEnd) { [int]$config.vjudge.defaults.freezeMinutesBeforeEnd } else { 60 }
$unfreezeMinutes = if ($null -ne $config.vjudge.defaults.unfreezeMinutesAfterEnd) { [int]$config.vjudge.defaults.unfreezeMinutesAfterEnd } else { 1 }

try {
    $begin = [DateTimeOffset]::Parse($BeginTime, [Globalization.CultureInfo]::InvariantCulture)
} catch {
    throw 'BeginTime must include an unambiguous date, time, and UTC offset.'
}

function Expand-ProblemNumbers {
    param([string]$Spec)

    $result = [System.Collections.Generic.List[int]]::new()
    foreach ($part in ($Spec -split ',')) {
        $item = $part.Trim()
        if ($item -match '^(\d+)$') {
            $result.Add([int]$matches[1])
            continue
        }
        if ($item -match '^(\d+)-(\d+)$') {
            $start = [int]$matches[1]
            $end = [int]$matches[2]
            if ($end -lt $start) {
                throw "Problem range '$item' is descending."
            }
            foreach ($number in $start..$end) {
                $result.Add($number)
            }
            continue
        }
        throw "Invalid problem item '$item'."
    }
    if ($result.Count -eq 0) {
        throw 'At least one problem number is required.'
    }
    if (($result | Select-Object -Unique).Count -ne $result.Count) {
        throw 'ProblemNumbers contains duplicates.'
    }
    return $result.ToArray()
}

function Read-VJudgeCredentialFile {
    param([string]$Path)

    if (-not $Path -or -not [IO.Path]::IsPathRooted($Path)) {
        throw 'The configured VJudge credential file must use an absolute path.'
    }
    if (-not (Test-Path -LiteralPath $Path)) {
        throw 'The configured VJudge credential file was not found.'
    }
    $values = @{}
    Get-Content -LiteralPath $Path -Encoding UTF8 | ForEach-Object {
        if ($_ -match '^([^=]+)=(.*)$') {
            $values[$matches[1].Trim()] = $matches[2]
        }
    }
    if (-not $values['VJUDGE_USERNAME'] -or -not $values['VJUDGE_PASSWORD']) {
        throw 'The credential file must define VJUDGE_USERNAME and VJUDGE_PASSWORD.'
    }
    return $values
}

$numbers = Expand-ProblemNumbers -Spec $ProblemNumbers
$problems = @()
foreach ($number in $numbers) {
    $info = Invoke-RestMethod -Method Get -Uri "$baseUrl/problem/info/QOJ-$number"
    if ($info.error -or -not $info.pid -or -not $info.title) {
        throw "VJudge could not validate QOJ-$number."
    }
    $problems += [pscustomobject]@{
        oj = 'QOJ'
        probNum = [string]$number
        weight = 1
        alias = ''
        pid = [int64]$info.pid
        title = [string]$info.title
    }
}

$plan = [ordered]@{
    sourceContest = $QojContestUrl.TrimEnd('/')
    title = $title
    group = if ($groupName) { $groupName } else { $groupShortName }
    groupShortName = $groupShortName
    groupId = [int64]$groupId
    beginTime = $begin.ToString('yyyy-MM-dd HH:mm:ss zzz')
    durationMinutes = $durationMinutes
    contestType = 'team'
    openness = 'private-group-only'
    participantMode = 'individual-only'
    rankRule = 'ICPC'
    wrongAttemptPenaltySeconds = $penaltySeconds
    partialScore = $false
    oneShot = $false
    timeMachine = $true
    showPeersAfterContestOnly = $true
    freezeMinutesBeforeEnd = $freezeMinutes
    unfreezeMinutesAfterEnd = $unfreezeMinutes
    problemCount = $problems.Count
    problems = @($problems | ForEach-Object {
        [ordered]@{ oj = $_.oj; probNum = $_.probNum; pid = $_.pid; title = $_.title }
    })
}

if (-not $Commit) {
    $plan | ConvertTo-Json -Depth 8
    exit 0
}

if ($config.vjudge.authentication.mode -ne 'credential-file') {
    throw 'Commit mode requires credential-file authentication. Use the authenticated browser for browser mode.'
}
$credentials = Read-VJudgeCredentialFile -Path ([string]$config.vjudge.authentication.credentialFile)
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$login = Invoke-RestMethod -Uri "$baseUrl/user/login" -Method Post -WebSession $session -Body @{
    username = $credentials['VJUDGE_USERNAME']
    password = $credentials['VJUDGE_PASSWORD']
} -ContentType 'application/x-www-form-urlencoded'
if ($login.error) {
    throw 'VJudge login failed.'
}

$payload = Invoke-RestMethod -Uri "$baseUrl/contest/create?type=1&groupId=$groupId" -Method Get -WebSession $session
if ($payload.errMsg) {
    throw "VJudge refused the contest template: $($payload.errMsg)"
}
if ($payload.type -ne 1 -or $payload.groupId -ne $groupId -or $payload.openness -ne 2) {
    throw 'VJudge group defaults no longer match the expected team/private configuration.'
}

$payload.title = $title
$payload.beginTime = $begin.ToUnixTimeMilliseconds()
$payload.length = $durationMinutes * 60 * 1000
$payload.timeMachine = 1
$payload.sumTime = 1
$payload.penalty = $penaltySeconds
$payload.partialScore = 0
$payload.oneShot = 0
$payload.showPeers = 0
$payload.participantMode = 0
$payload.freezeDuration = $freezeMinutes
$payload.unfreezeDuration = $unfreezeMinutes
$payload.problems = @($problems | ForEach-Object {
    [pscustomobject]@{
        oj = $_.oj
        probNum = $_.probNum
        weight = $_.weight
        alias = $_.alias
        pid = $_.pid
    }
})

$body = $payload | ConvertTo-Json -Depth 10 -Compress
$result = Invoke-RestMethod -Uri "$baseUrl/contest/edit" -Method Post -WebSession $session -Body $body -ContentType 'application/json'
if ($result.error) {
    throw "VJudge create failed: $($result.error)"
}
if (-not $result.contestId) {
    throw 'VJudge did not return a contest ID.'
}

[ordered]@{
    contestId = [int64]$result.contestId
    contestUrl = "$baseUrl/contest/$($result.contestId)"
    title = $title
    beginTime = $begin.ToString('yyyy-MM-dd HH:mm:ss zzz')
    problemCount = $problems.Count
} | ConvertTo-Json -Depth 5
