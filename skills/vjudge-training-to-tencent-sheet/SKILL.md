---
name: vjudge-training-to-tencent-sheet
description: Extract final ICPC-style VJudge standings, normalize each result as rank/solved/penalty, maintain a participant roster, mark absences, and safely add or refresh a dated individual or team training column in the coach's configured Tencent Sheet. Use when a coach asks to pull VJudge training results, synchronize a contest into Tencent Docs, update a training tracker, or repeat a VJudge-to-sheet workflow.
---

# VJudge Training to Tencent Sheet

Pull a VJudge ranking and update a longitudinal Tencent Docs training table without overwriting unrelated data.

## Configuration

Resolve values from the user request, then `<CODEX_HOME>/acm-coach/config.json`, then `<user-profile>/.codex/acm-coach/config.json`. Read `tencentDocs.training.documentUrl` and `targetSheet`. Require the user to supply any missing contest URL, document, or tab.

Use `vjudge.authentication.mode` only to choose authentication behavior. Prefer the signed-in browser. If configured for a credential file, read it without printing and only for VJudge login. Never hard-code or copy account names, passwords, document IDs, worksheet IDs, or local personal paths into this skill.

## Output contract

Use one row per participant and one column per session:

| Name | YYYY-MM-DD Individual Training N |
|---|---|
| Example | rank 3 (10, 1145) |

- Format results exactly as `rank {rank} ({solved}, {penalty})`.
- Keep `rank` lowercase and one space after the comma.
- Use VJudge `Score` as solved count.
- Use the minute-valued `Penalty`, not an alternate hour or `HH:MM:SS` display.
- Write `未参加` for every roster member absent from the contest.
- Leave no roster/session intersection blank.
- Preserve ranking order only when initializing a blank table; never reorder an existing roster.

## 1. Resolve and authenticate

1. Require an exact VJudge contest URL.
2. Resolve the Tencent destination from explicit input or local config.
3. Query available connectors before browser work.
4. Reuse an authenticated VJudge browser session when possible.
5. Never inspect cookies, local storage, saved passwords, session files, or unrelated history.
6. Stop for user intervention when a CAPTCHA appears.
7. Report authentication failure without submitted values.

## 2. Identify the session

Read the contest title, displayed local start time, mode, and round number.

- `Individual Training - Round N` or equivalent → `YYYY-MM-DD 个人训练N`.
- `Team Training - Round N` or equivalent → `YYYY-MM-DD 团队训练N`.
- When genuinely ambiguous, derive a concise label from the title and state the assumption before writing.

Use the contest start date, interpreted in the configured timezone, not the current date.

## 3. Extract standings

1. Open the final ranking or the explicitly requested ranking time.
2. Locate the non-empty table beginning with `Rank`, `Team`, `Score`, and `Penalty`.
3. Extract all body rows in one bounded DOM operation when possible.
4. For individual contests, prefer the real name shown in trailing parentheses; otherwise use the displayed account/team name.
5. For team contests, preserve the displayed team name unless the user asks for member expansion.
6. Read penalty from the minute-valued element. Do not convert the full cell text when it includes hidden alternate representations.
7. Validate that rows exist, numeric values are numeric, names are nonblank, and extracted/visible row counts match.

## 4. Inspect the Tencent Sheet

1. Discover available Tencent Docs tools before calling them.
2. Resolve the configured document and tab by URL, name, or ID.
3. Confirm the target is an online sheet and the intended tab exists.
4. Read a bounded target region before every write.
5. Never clear a populated range merely to simplify the update.

Use the signed-in browser if no connector can safely perform the required operation.

## 5. Choose a safe write plan

For a blank target:

1. Write `姓名` in A1 and the session header in B1.
2. Write names and results from row 2.
3. Apply readable header/name/result formatting and freeze row 1/column A.
4. Optionally use restrained highlights for ranks 1–3.

For an existing table:

1. Locate `姓名` and build a normalized name-to-row map.
2. Update only the matching session column when its header exists; otherwise append after the rightmost training header.
3. Reuse participant rows even when ranking order changes.
4. Write `未参加` for every existing roster member absent from the standings.
5. Append newly seen participants below the roster in their relative VJudge order.
6. Backfill earlier training columns for new participants with `未参加`; do not touch unrelated columns.
7. Replace stale blanks in a refreshed session with `未参加`.
8. Preserve unrelated cells, formulas, notes, filters, styles, frozen panes, and other tabs.
9. Batch value writes, then apply only targeted styles and dimensions.

## 6. Verify

Read back the exact header and result range. Confirm every name/result pair, one occurrence of the header, no blank current-session roster cells, correct historical backfills for new names, and no shifted results. Make only the smallest correction when verification fails, then read back again.

## Completion

Report the updated document/tab, session header, standings count, new participants, absent roster members, whether the column was added or refreshed, verification result, and direct document link. Do not expose credentials, browser internals, raw authentication output, or connector trace IDs.
