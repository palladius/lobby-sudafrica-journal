

## Live Journaling Workflow (via Telegram)

This section outlines the operational workflow for live updates to the journal, managed by Lobby via Telegram.

**Trigger:** Riccardo sends content (text and/or photos) via Telegram.

**Process:**
1.  **Content Ingestion:**
    -   Text is formatted into Markdown.
    -   Photos are saved and processed as described below.

2.  **Photo Processing:**
    -   For each incoming photo, a Pixar-style version is generated using the `nano-banana-pro` skill.
    -   Both the original and the generated image are stored in the daily asset folder: `assets/images/YYYY-MM-DD/`.

3.  **Journal Update:**
    -   The text and Markdown links for the new images are appended to the corresponding daily journal file: `YYYY-MM-DD.md`.

4.  **Synchronization:**
    -   After each significant update, the changes are to be committed and pushed to the remote GitHub repository.
