# South Africa Journal Workflow

**Golden Rule: Do Not Rewrite Git History!**
- **NEVER USE:** `git reset --hard`, `git push -f`.
- **ALWAYS USE:** `git commit` for new changes, and `git revert [hash]` to undo a bad commit. History must be immutable for safe recovery.

This file contains the operational instructions for the agent updating this journal.

**Trigger:** Riccardo sends a photo, video, or note related to the South Africa trip.

---

### **Standard Procedure**

1.  **Context:** Always remember the reference timezone is Johannesburg (GMT+2). The time is February 2026.
2.  **Add to TODO List:** Immediately add the photo to `PIXAR_TODO.md` in the main workspace.
3.  **"Pixarize":** Use `nano-banana-pro` to create a "Pixar" version of the image.
4.  **File Organization:**
    - Copy the **original** photo to `images/real/`.
    - Copy the **generated** photo to `images/pixar/`.
5.  **Update Journal:**
    - Open the correct day's Markdown file (e.g., `2026-02-08.md`).
    - **Safe Method:** Read the entire file content, add new sections in memory, and then overwrite the file with the complete new content.
6.  **Pre-Commit Check (PRESUBMIT):**
    - `git status` to see modified files.
    - `git diff --stat` for a summary of changes. If you see unexpected deletions, STOP.
    - **Link Check:** Verify that all image paths in the `.md` file exist.
    - **Duplicate Check:** Ensure the new photos are not already present.
7.  **Commit & Push:**
    - If checks pass, proceed: `git add .`, `git commit`, `git push`.
8.  **Notify Riccardo:**
    - Send confirmation, the Pixar photo, and a link to the `README.md`.
9.  **Check off TODO List:** Update the `PIXAR_TODO.md`.

---

### **Live Journaling Workflow (via Telegram)**

This section outlines the operational workflow for live updates to the journal, managed by Lobby via Telegram. This is a more direct flow that bypasses the `PIXAR_TODO.md` process for speed.

**Trigger:** Riccardo sends content (text and/or photos) directly via Telegram for immediate inclusion.

**Process:**
1.  **Content Ingestion:**
    -   Text is formatted into Markdown.
    -   Photos are processed as described below.

2.  **Photo Processing:**
    -   For each incoming photo, a Pixar-style version is generated using the `nano-banana-pro` skill.
    -   Both the original and the generated image are stored in the daily asset folder: `assets/images/YYYY-MM-DD/`. (Note: This differs from the `images/real/` and `images/pixar/` structure for bulk processing).

3.  **Journal Update:**
    -   The text and Markdown links for the new images are appended to the corresponding daily journal file: `YYYY-MM-DD.md`.

4.  **Synchronization (with PRESUBMIT checks):**
    -   **Run Test:** `just test`
    -   **Commit:** `git add . && git commit -m "feat(journal): Add new entry for YYYY-MM-DD"`
    -   **Post-Commit Diff:** Get the diff statistics using `git diff HEAD~1 --stat` and report them to Riccardo.
    -   **Push:** `git push`
\n- **Photo Rule:** For every photo received during the trip, create a Pixar-style version and save it to the corresponding daily assets folder ('assets/images/YYYY-MM-DD/').
