# Journal Workflow

## 🛡️ Safety First (Pre-Commit)
1. **Check Diff:** Run `git diff --stat`. If `deletions > 5`, **STOP** and investigate.
2. **Verify Links:** Ensure all image paths in `.md` files exist.
3. **Immutability:** Never `force push` or `hard reset`. Use `revert` for fixes.

## 📸 Image Management
- **Naming:** `YYYY-MM-DD-[description]_[real|pixar].[jpg|png]`
- **Storage:** 
  - Original: `images/real/` or `assets/images/YYYY-MM-DD/`
  - AI Version: `images/pixar/` or `assets/images/YYYY-MM-DD/`
- **Action:** Generate Pixar version via `nano-banana-pro`, then **ALWAYS** send it to Riccardo.

## 📝 Update Process
1. **Modular Writing:** Use `YYYY-MM-DD_XX-name.md` for chunks to avoid truncation.
2. **Timezone:** Always use Johannesburg time (SAST, GMT+2).
3. **Assemble:** Merge chunks into the daily file (e.g., `2026-02-10.md`) at EOD.
4. **Link:** Share the GitHub link: `https://github.com/palladius/lobby-sudafrica-journal/blob/master/YYYY-MM-DD.md`

## 🧪 Validation
- Run `just unit-tests` to verify image existence and date consistency.
