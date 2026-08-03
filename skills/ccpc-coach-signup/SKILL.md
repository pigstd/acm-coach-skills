---
name: ccpc-coach-signup
description: Guide CCPC/ICPC coach registration workflows that collect team information from authorized email or group sources, prepare confirmation records, check and update student and team pools, avoid duplicates, and submit coach-side registrations on signup.ccpc.io. Use when a coach asks Codex to organize contest signup data, add students, create teams, or register teams for a CCPC-style contest.
---

# CCPC Coach Signup

Run a coach-side contest signup end to end while keeping personal data out of the skill and requiring confirmation before writes.

## Required workflow

1. **Collect source data**
   - Use only coach-authorized email, group, file, or logged-in browser sources.
   - Extract the contest, Chinese and English team names, members, and conventions.
   - Ignore individual signups when the task is team registration.

2. **Create a confirmation table**
   - Write a local Markdown table before touching the signup site.
   - Mark unresolved fields instead of guessing.
   - Ask the user to confirm names, members, pinyin conventions, sponsor consent, graduation year, shirt sizes, or other required fields.
   - Use [references/record-templates.md](references/record-templates.md).

3. **Check the student pool**
   - Inspect `https://signup.ccpc.io/student_pool_manage` and identify existing members.
   - Determine missing fields from the live form; do not assume the schema is unchanged.
   - Present the exact missing-student rows and destination account/site before submission.
   - Add only confirmed students, verify them, and record visible IDs.

4. **Check the team pool**
   - Search all relevant pages at `https://signup.ccpc.io/team_pool_manage` before creating teams.
   - Match by both team name and members. Do not reuse a stale same-name team with different members.
   - Present exact missing teams before creation, then verify their IDs.

5. **Check existing contest registrations**
   - Search `https://signup.ccpc.io/signup_info` for the exact target contest and teams.
   - Do not confuse another contest or year with a duplicate.
   - Stop and report any existing target registration and status.

6. **Submit**
   - Select the exact contest by name and date at `https://signup.ccpc.io/contest_signup`.
   - Select team IDs where possible and use only the confirmed quota type.
   - Verify the complete form immediately before submission.
   - Submit only when the current user request gives narrow approval for this exact contest and dataset, or after explicit confirmation.

7. **Verify and record**
   - Re-read `signup_info` and verify each registration.
   - Record registration ID, team ID, team name, quota type, and status in a local result file.
   - Report spelling differences, stale duplicates, and unresolved data.

## Confirmation and privacy rules

Require explicit confirmation before adding students, creating teams, submitting registrations, withdrawing, or modifying records. Name the site/account, contest, teams, quota type, and categories of sensitive data being transmitted.

Treat email contents, student numbers, phones, addresses, and cookies as sensitive. Never store an account, password, cookie, token, personal roster, or document ID in this skill. Prefer the signed-in in-app browser and never inspect browser credential stores.

Read [references/signup-site-notes.md](references/signup-site-notes.md) before operating the live site. Treat its endpoints and fields as observations that must be checked against the current page.

## Completion

Report created teams and IDs, registrations and IDs, contest and quota type, verification status, local records written, and duplicate or data-quality warnings. Do not expose authentication details.
