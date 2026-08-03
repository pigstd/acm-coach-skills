# signup.ccpc.io Notes

Treat these as observed behavior, not a frozen API contract. Inspect the current page before relying on a route, selector, endpoint, or field.

## Main routes

- `/student_pool_manage`: student pool maintenance
- `/team_pool_manage`: team pool maintenance
- `/contest_signup`: available contests and signup form
- `/signup_info`: coach registrations
- `/user/login`: login

## Observed endpoints

Prefer visible UI automation unless authentication, payload, and response shapes have been verified in the current session. Never send a write request without the same confirmation required for a UI action.

- `GET /api/studentpool/my`
- `GET /api/teampool/my`
- `POST /api/team/register`
- `POST /api/team/update`
- `POST /api/teampool/removeTeamFromCoachTeamPool`
- `POST /api/register/addRegister`

## Field checks

Student fields may include name, gender, student number, school, major, degree, entry year, phone, email, English name, shirt size, sponsor/privacy consent, and graduation year. Inspect the live form and record user-specific conventions in the task record before submitting.

Team forms may include Chinese and English names, three members, an optional co-coach, and all-female-team status. Set special status only when the roster qualifies and the user confirms it.

Contest forms commonly contain the contest ID, contest name/date, team IDs, and quota type. Selecting by team ID is safer when duplicate names exist.

## UI and duplicate checks

- Search all relevant team-pool pages for each name and member combination.
- Search registrations for the exact contest and target teams.
- Reuse teams only when both names and members match.
- Ant Design drawers may need a wider viewport; restore it after use.
- Searchable selects often require focus before typing.
- Verify writes from persistent table rows and counts, not transient toast messages.
