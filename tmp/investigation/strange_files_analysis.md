# Investigation of Alternative Diary Files

Files investigated and moved to `../backups/`:

- `South_Africa_Diary.md`
- `SouthAfrica.md`
- `v1.md`, `v2.md`, `v3.md`, `v4.md`, `v5.md`, `v_current.md`
- `v_giraffe.md`, `v_impala.md`, `v_seby.md`, `v_zebra_selfie.md`
- `2026-02-10.md.BROKEN_BACKUP`

**Intent and Findings:**
These files were clearly created during an earlier phase of the journal's life, before the `YYYY-MM-DD.md` structure was formalized (or during a transitional period).

- `South_Africa_Diary.md` contains a monolithic, complete narrative covering multiple days (e.g., Feb 6, Feb 7). It contains valuable text that might be missing from the individual day files.
- The `v*.md` files (like `v1.md` and `v_current.md`) are drafts and alternate versions of specific days (like `v1.md` being about Feb 8th).
- The `v_<animal>.md` files seem to be specific prompt outputs or small snippets focusing on single events/images.

**Action Taken:**
To declutter the working directory (`projects/active/lobby-sudafrica-journal/`), all of these files have been moved into `tmp/backups/`. They will remain there so we can grep through them if we discover any missing narrative text while processing the individual `YYYY-MM-DD.md` files.

**Action Needed:**
While processing each day, if the daily file feels "empty" compared to what we expect, we should search `tmp/backups/South_Africa_Diary.md` and other backups to restore the full narrative.
