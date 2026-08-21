# daily-log

Personal daily activity log, updated automatically.

`daily-commit.ps1` runs on a schedule (Windows Task Scheduler — daily + at logon) and appends one line to `STREAK.md` for the current date, then commits and pushes. It's idempotent: running it more than once on the same day is a no-op after the first run.
