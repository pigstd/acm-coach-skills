# ACM Coach Skills

A reusable, account-neutral Codex skill suite for ACM/ICPC coaches:

- `ccpc-coach-signup`: prepare and submit CCPC-style coach registrations.
- `summarize-team-trials-to-tencent-sheet`: collect trial reports and update a Tencent Sheet.
- `vjudge-create-team-contest`: create and verify a private VJudge group contest.
- `vjudge-training-to-tencent-sheet`: synchronize VJudge standings to a Tencent Sheet.
- `setup-acm-coach-skills`: install the suite and create the current coach's local configuration.

## Quick start

Clone this repository, then ask Codex:

> Use `$setup-acm-coach-skills` from `skills/setup-acm-coach-skills` to install and configure this repository for my accounts.

The setup skill installs all sibling skills into the user's Codex skill directory and writes account-specific, non-secret settings to `~/.codex/acm-coach/config.json` (or the equivalent `CODEX_HOME` path). It does not request or store passwords in this repository. Sign in through the in-app browser whenever possible.

## Security model

- No usernames, passwords, cookies, tokens, personal document IDs, school-specific group IDs, or local personal paths are committed.
- Local configuration and credential files are ignored by Git.
- Browser sessions are preferred for authentication.
- If a local VJudge credential file is explicitly chosen, it must live outside the repository and contain only `VJUDGE_USERNAME` and `VJUDGE_PASSWORD` entries.
- Every write workflow requires a read-before-write check and post-write verification.
