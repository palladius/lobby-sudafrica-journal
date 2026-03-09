# GitHub Issue: Sebenza Migration Recovery & Final Cleanup

**Task:** Complete the integration of `lobby-sebenza` content and verify the restoration of February 9th/10th.

### 📜 Recovered Data

- [x] Feb 9th restored from `tmp/2026-02-09-commit-ebf6780.md` into `jekyll-site/_posts/2026-02-09-sun-city-valley-of-waves.md`.
- [x] Image paths converted to `/assets/images/original/20260209` and `/assets/images/pixar/20260209`.

### 🛠️ Migrated Components (Moved to `bin/sebenza` and `docs/resources`)

- [x] `parser.js` and `parser.test.js`
- [x] `PRD.md` (renamed to `sebenza_prd.md`)
- [x] `south_africa_packing_sample.md`

### 🚩 Remaining "GOLD" to Verify (TODO)

- [ ] Review `_todis/2026-02-07-safari-pilanesberg.md` in Sebenza to ensure _every single string_ is in the Jekyll post (I've done a quick diff, but a manual check is safer).
- [ ] Check if there are any other private files in Sebenza that should go to Obsidian instead of here.
- [ ] **Final Delete:** Delete `~/.openclaw/workspace/projects/inactive/lobby-sebenza` after confirming the above.

### 🧪 Verification

- [ ] Run `just test` after all migrations.
