---
name: summarize-team-trials-to-tencent-sheet
description: Collect an ACM/ICPC trial contest day's post-contest summaries, team preferences, and leave notices from authorized mail and local fallback files; reconstruct that date's teams; synthesize individual and team evaluations; and safely update a four-column daily block in a configured Tencent Sheet. Use when a coach asks to process a trial date, compare a roster sheet with a grouping image, distinguish each teammate's contribution, synchronize reports, or repair missing attachment-backed entries.
---

# Trial Summary to Tencent Sheet

Process one contest date end to end. Preserve evidence boundaries between a participant's statements, teammate observations, coach evaluations, and inference.

## Configuration

Resolve configuration in this order:

1. values explicitly supplied by the user;
2. `<CODEX_HOME>/acm-coach/config.json` when `CODEX_HOME` is set;
3. otherwise `<user-profile>/.codex/acm-coach/config.json`.

Read `timezone`, `paths.trialSummaryFallback`, and `tencentDocs.trialSummary`. Require a document URL and target worksheet name or ID before writing. Require a roster worksheet when the task depends on the maintained roster. Never hard-code a personal document ID, local path, or organization name into this skill.

## 1. Inspect sources before writing

1. Read the target worksheet, merged cells, and configured roster worksheet.
2. Locate the requested date's teams. If the user provides a grouping image, compare every team and member against the sheet.
3. Treat team membership as date-specific. Never carry a previous day's mapping forward.
4. Report exact sheet/image mismatches before writing. Use explicit visual markings or user statements to identify substitute coaches; do not guess through conflicting evidence.
5. Inspect existing date columns. Update in place when present; otherwise insert a new four-column block without overwriting another date.

Prefer authorized mail and Tencent Docs connectors. Use the signed-in browser only when a connector lacks the required read or write operation.

## 2. Search mail comprehensively

Use native mailbox search and paginate until exhausted. Run at least:

- a narrow contest-date search using common numeric and Chinese date variants plus `小结` or `总结`;
- a wider nearby search for `组队意向`, `配队意向`, `请假`, and participant names when needed.

Read complete bodies for shortlisted messages. Resolve misleading subject dates using team composition and contest content, and record the reason when reserving a message for another date.

## 3. Use local attachment fallbacks

When the mail connector cannot read an attachment:

1. Check the configured `paths.trialSummaryFallback`, with a date subfolder when that convention exists.
2. Match by participant, teammates, and date before reading.
3. Try the signed-in browser only when practical.
4. If unavailable, label the entry `依据队友/教练评价，非本人小结` and state that the self-evaluation is unavailable.

Never represent secondary evidence as a participant's own statement. Replace provisional summaries when primary evidence later becomes available.

## 4. Delegate team synthesis

For three or more teams, delegate independent team analyses to subagents when available. Give each agent only the bounded date, exact members, relevant message IDs or search window, matching local paths, and required output. Keep all Tencent writes in the main agent and cross-check results against the roster and dates.

Require each person summary to cover concrete contributions, strengths, problems, self-evaluation, attributed teammate evaluations, overall performance, team preference, leave interval/reason, and missing-source status.

Require each team summary to cover solved count/rank with cautious conflict wording, distinct contributions by all members, role complementarity, shared strengths, process/technical/communication issues, training actions, and missing submissions.

For substitute coaches, prioritize their evaluations of students. Do not create a permanent participant row for a coach unless the roster or user requires one.

## 5. Normalize content

- **Personal summary:** compact evidence-grounded advantages, weaknesses, self/peer evaluation, and examples.
- **Team preference:** preserve explicit positive and negative preferences with reasons; never infer preference from another person's message.
- **Leave:** record the actual interval and reason, not merely send time. Preserve both a leave request and actual participation when both occurred.
- **Missing:** use `未检索到本人提交` when no primary message/file exists.
- **Secondary only:** use `依据队友/教练评价，非本人小结`.
- **Withdrawal:** use `已退队` when explicit, superseding ordinary preference text.
- **Conflicting ranks:** use a non-conflicting formulation such as `末位/5题` when denominators differ.

## 6. Write safely

Use a two-row header for a new block:

- column A: `姓名`, merged vertically;
- four columns under `YYYY年M月D日`: `小结`, `组队意向`, `请假情况`, `当日队伍总体总结`.

Store each date's team summary inside that date block. Write the same synthesis into each current team member's fourth cell so participant filtering retains context. Clearly distinguish all members' contributions. For nonparticipants, write a nonparticipation explanation.

When migrating an older three-column-per-date layout with one global team summary:

1. insert a summary column into every existing date block;
2. move each date's summaries into its block;
3. remove or repurpose the global column only after verifying preservation;
4. read back older blocks before adding the new date.

Preserve existing names and unrelated data. Add names only when supported by the roster. Use wrapped, top-aligned text, readable widths, frozen headers/name column, and restrained status colors:

- yellow: provisional or secondary-only;
- orange: missing submission plus material status;
- gray: did not participate or was unassigned.

Remove provisional styling after incorporating primary evidence.

## 7. Verify and report

Read back every changed cell. Confirm every roster row has all requested fields, each team summary matches that day's roster and distinguishes contributions, no older date changed unintentionally, and merged headers/styles remain valid.

Report the document/tab, date block, participant and team counts, missing/secondary sources, roster discrepancies, cells written, and verification result. Never expose mail contents beyond what the requested summary needs, account details, cookies, tokens, or connector trace IDs.
