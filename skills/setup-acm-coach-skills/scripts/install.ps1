[CmdletBinding()]
param(
    [string]$InstallRoot,
    [string]$ConfigPath,
    [string]$OrganizationName,
    [string]$Season,
    [string]$Timezone,
    [string]$VjudgeGroupName,
    [string]$VjudgeGroupShortName,
    [Nullable[Int64]]$VjudgeGroupId,
    [string]$ContestTitleTemplate,
    [ValidateSet('browser', 'credential-file')]
    [string]$VjudgeAuthMode,
    [string]$VjudgeCredentialFile,
    [string]$TrialSummaryDocumentUrl,
    [string]$TrialSummarySheetName,
    [string]$TrialSummarySheetId,
    [string]$TrialRosterSheetName,
    [string]$TrialRosterSheetId,
    [string]$TrainingDocumentUrl,
    [string]$TrainingSheetName,
    [string]$TrainingSheetId,
    [string]$TrialSummaryFallback,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$skillDirectory = Split-Path -Parent $PSScriptRoot
$sourceSkills = Split-Path -Parent $skillDirectory
$exampleConfig = Join-Path $skillDirectory 'assets\acm-coach.config.example.json'

if (-not $InstallRoot) {
    $codexRoot = if ($env:CODEX_HOME) {
        $env:CODEX_HOME
    } elseif ($env:USERPROFILE) {
        Join-Path $env:USERPROFILE '.codex'
    } else {
        throw 'Cannot determine the Codex directory. Pass -InstallRoot and -ConfigPath explicitly.'
    }
    $InstallRoot = Join-Path $codexRoot 'skills'
} else {
    $codexRoot = Split-Path -Parent $InstallRoot
}

if (-not $ConfigPath) {
    $ConfigPath = Join-Path $codexRoot 'acm-coach\config.json'
}

$requiredSkills = @(
    'setup-acm-coach-skills',
    'ccpc-coach-signup',
    'contest-reimbursement',
    'summarize-team-trials-to-tencent-sheet',
    'vjudge-create-team-contest',
    'vjudge-training-to-tencent-sheet'
)

foreach ($name in $requiredSkills) {
    $source = Join-Path $sourceSkills $name
    if (-not (Test-Path -LiteralPath (Join-Path $source 'SKILL.md'))) {
        throw "Required sibling skill is missing: $name"
    }
}

New-Item -ItemType Directory -Path $InstallRoot -Force | Out-Null
$backupRoot = $null
foreach ($name in $requiredSkills) {
    $source = Join-Path $sourceSkills $name
    $destination = Join-Path $InstallRoot $name
    if (Test-Path -LiteralPath $destination) {
        if (-not $Force) {
            throw "Destination already exists: $destination. Inspect it before rerunning with -Force."
        }
        if (-not $backupRoot) {
            $backupName = 'acm-coach-backup-{0}-{1}' -f (Get-Date -Format 'yyyyMMdd-HHmmss'), ([guid]::NewGuid().ToString('N').Substring(0, 8))
            $backupRoot = Join-Path (Split-Path -Parent $InstallRoot) $backupName
            New-Item -ItemType Directory -Path $backupRoot | Out-Null
        }
        Move-Item -LiteralPath $destination -Destination (Join-Path $backupRoot $name)
    }
    Copy-Item -LiteralPath $source -Destination $destination -Recurse
}

$configDirectory = Split-Path -Parent $ConfigPath
New-Item -ItemType Directory -Path $configDirectory -Force | Out-Null
$configExisted = Test-Path -LiteralPath $ConfigPath
if ($configExisted) {
    $config = Get-Content -LiteralPath $ConfigPath -Raw -Encoding UTF8 | ConvertFrom-Json
} else {
    $config = Get-Content -LiteralPath $exampleConfig -Raw -Encoding UTF8 | ConvertFrom-Json
}

function Set-IfProvided {
    param($Object, [string]$Property, $Value, [bool]$WasProvided)
    if ($WasProvided) {
        $Object.$Property = $Value
    }
}

Set-IfProvided $config.organization 'name' $OrganizationName $PSBoundParameters.ContainsKey('OrganizationName')
Set-IfProvided $config.organization 'season' $Season $PSBoundParameters.ContainsKey('Season')
Set-IfProvided $config 'timezone' $Timezone $PSBoundParameters.ContainsKey('Timezone')
Set-IfProvided $config.vjudge.group 'name' $VjudgeGroupName $PSBoundParameters.ContainsKey('VjudgeGroupName')
Set-IfProvided $config.vjudge.group 'shortName' $VjudgeGroupShortName $PSBoundParameters.ContainsKey('VjudgeGroupShortName')
Set-IfProvided $config.vjudge.group 'id' $VjudgeGroupId $PSBoundParameters.ContainsKey('VjudgeGroupId')
Set-IfProvided $config.vjudge 'contestTitleTemplate' $ContestTitleTemplate $PSBoundParameters.ContainsKey('ContestTitleTemplate')
Set-IfProvided $config.vjudge.authentication 'mode' $VjudgeAuthMode $PSBoundParameters.ContainsKey('VjudgeAuthMode')
Set-IfProvided $config.vjudge.authentication 'credentialFile' $VjudgeCredentialFile $PSBoundParameters.ContainsKey('VjudgeCredentialFile')
Set-IfProvided $config.tencentDocs.trialSummary 'documentUrl' $TrialSummaryDocumentUrl $PSBoundParameters.ContainsKey('TrialSummaryDocumentUrl')
Set-IfProvided $config.tencentDocs.trialSummary.targetSheet 'name' $TrialSummarySheetName $PSBoundParameters.ContainsKey('TrialSummarySheetName')
Set-IfProvided $config.tencentDocs.trialSummary.targetSheet 'id' $TrialSummarySheetId $PSBoundParameters.ContainsKey('TrialSummarySheetId')
Set-IfProvided $config.tencentDocs.trialSummary.rosterSheet 'name' $TrialRosterSheetName $PSBoundParameters.ContainsKey('TrialRosterSheetName')
Set-IfProvided $config.tencentDocs.trialSummary.rosterSheet 'id' $TrialRosterSheetId $PSBoundParameters.ContainsKey('TrialRosterSheetId')
Set-IfProvided $config.tencentDocs.training 'documentUrl' $TrainingDocumentUrl $PSBoundParameters.ContainsKey('TrainingDocumentUrl')
Set-IfProvided $config.tencentDocs.training.targetSheet 'name' $TrainingSheetName $PSBoundParameters.ContainsKey('TrainingSheetName')
Set-IfProvided $config.tencentDocs.training.targetSheet 'id' $TrainingSheetId $PSBoundParameters.ContainsKey('TrainingSheetId')
Set-IfProvided $config.paths 'trialSummaryFallback' $TrialSummaryFallback $PSBoundParameters.ContainsKey('TrialSummaryFallback')

$serialized = $config | ConvertTo-Json -Depth 12
if ($serialized -match '(?i)"(password|token|cookie|secret)"\s*:') {
    throw 'Refusing to write a config containing a secret-bearing field.'
}
if ($configExisted -and $Force) {
    if (-not $backupRoot) {
        $backupName = 'acm-coach-backup-{0}-{1}' -f (Get-Date -Format 'yyyyMMdd-HHmmss'), ([guid]::NewGuid().ToString('N').Substring(0, 8))
        $backupRoot = Join-Path (Split-Path -Parent $InstallRoot) $backupName
        New-Item -ItemType Directory -Path $backupRoot | Out-Null
    }
    Copy-Item -LiteralPath $ConfigPath -Destination (Join-Path $backupRoot 'config.json')
}
$serialized | Set-Content -LiteralPath $ConfigPath -Encoding UTF8

[ordered]@{
    installRoot = (Resolve-Path -LiteralPath $InstallRoot).Path
    configPath = (Resolve-Path -LiteralPath $ConfigPath).Path
    installedSkills = $requiredSkills
    authenticationMode = $config.vjudge.authentication.mode
    backupRoot = $backupRoot
} | ConvertTo-Json -Depth 5
