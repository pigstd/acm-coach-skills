---
name: setup-acm-coach-skills
description: Install and configure the ACM coach skill suite from this repository for a new coach, organization, VJudge group, Tencent Docs workbook, local source folders, and authentication method. Use when someone clones the repository, asks to set up or migrate these skills for their own accounts, needs a fresh account-neutral config, or wants to verify that the suite is ready without performing contest or spreadsheet writes.
---

# Set up ACM Coach Skills

Install all sibling skills and create one local, non-secret configuration. Never put account credentials, cookies, tokens, or personal document URLs into the repository.

## 1. Locate the repository

Resolve this skill's directory and require its parent `skills` directory to contain the five sibling workflow skills, including `contest-reimbursement`. If siblings are missing, stop and ask the user to clone or provide the complete repository; do not silently install a partial suite.

## 2. Collect configuration

Read `assets/acm-coach.config.example.json`. Ask only for values that cannot be inferred from the user's request or inspected from an already authenticated page:

- organization display name and optional season label;
- timezone, defaulting to `Asia/Shanghai` only when appropriate;
- VJudge group name, short name, numeric group ID, and contest title template;
- Tencent Docs document URLs plus target/roster worksheet names or IDs;
- optional local fallback folder for trial-report attachments;
- VJudge authentication mode: `browser` by default, or `credential-file` when explicitly requested.

Document URLs, group IDs, and local paths belong in the local config even when they are not passwords. Leave an unused integration blank instead of inventing values.

## 3. Handle authentication safely

Prefer an already authenticated in-app browser. If login is required, open the official site and let the user sign in through the browser when interactive input or CAPTCHA is needed.

Never ask the user to paste a password, token, cookie, or recovery code into chat. Never read browser cookie stores, saved-password databases, unrelated history, or the workspace's existing credential files.

If the user explicitly chooses `credential-file`, record only an absolute path outside the repository. Tell the user to create that file themselves with:

```text
VJUDGE_USERNAME=their-login
VJUDGE_PASSWORD=their-password
```

Do not open, echo, copy, validate by printing, or commit the file.

## 4. Install

Run `scripts/install.ps1` from this skill. Pass the collected non-secret values as parameters. The script must install into:

1. `<CODEX_HOME>/skills` when `CODEX_HOME` is set;
2. otherwise `<user-profile>/.codex/skills`.

It writes the local config to `<CODEX_HOME>/acm-coach/config.json` or `<user-profile>/.codex/acm-coach/config.json`. Do not use `-Force` over existing skills until their contents have been inspected and the user has approved replacement. `-Force` moves existing skills and config into a timestamped sibling backup before installing clean copies; report that backup path. Never install into the cloned repository itself.

## 5. Verify without mutating services

After installation:

1. Parse the written JSON and ensure it contains no password, token, cookie, or secret fields.
2. Confirm all six skill folders contain `SKILL.md` and `agents/openai.yaml`.
3. Run the skill validator on each installed skill when the validator is available.
4. If the user configured VJudge or Tencent Docs, open the configured destination read-only and confirm the group/document/tab exists.
5. Do not create contests, students, teams, registrations, columns, or cells during setup.

Report the install directory, config path, configured integrations, authentication mode, successful read-only checks, and any values still needed. Never report credential contents.
