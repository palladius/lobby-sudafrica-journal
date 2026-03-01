### Technical Notes

- **Git Branch:** The default and only branch for this project is `master`. **DO NOT use `main`**.
- Repo: https://github.com/palladius/lobby-sudafrica-journal/

This is not a traditional blog and does not use static site generators like Jekyll.

This is a **near-live travel journal**, managed by an AI (Lobby/Gemini) under Riccardo's direction.

**The process is very simple:**

1.  **Input:** Riccardo provides prompts, voice notes, photos, and corrections to Lobby via a chat interface.
2.  **Processing:** Lobby writes the Markdown content, processes images, and structures the daily journal files.
3.  **Publishing:** Lobby commits and pushes the changes directly to this repository.
4.  **Viewing:** Family and friends can read the updates in near real-time by viewing the `.md` files directly on GitHub.

There is no "site" to "build". What you see in the repository is the final product.

---

### Image Recovery Workflow

If a Markdown file contains broken image links (`❌ FAIL` in link checker tests), the recovery process is as follows:

1.  **Identify Missing File:** Note the full path of the missing image (e.g., `images/pixar/lion-pride.png` or `images/real/lion-pride.jpg`).

2.  **For Pixar/AI Images:**
    - Search the `~/.openclaw/workspace/nano_banana/` directory.
    - Look for a file with a similar name, usually prefixed with a date (`YYYY-MM-DD-lion-pride.png`).
    - Use `ls -lt` to correlate the file's creation timestamp with the context of the blog post.
    - If a match is found, copy it to the correct path inside `lobby-sudafrica-journal/images/pixar/`.

3.  **For "Real" Images:**
    - These images must be supplied by Riccardo, as the AI cannot access historical chat attachments.
    - Search the session history (`sessions_history` tool) for a message around the time the image would have been discussed.
    - The log will contain a reference to the attachment (e.g., `telegram-USERID-MSGID.jpg`).
    - **Crucially, the AI cannot access this file path directly.** Riccardo must re-upload the image.
    - Once re-uploaded, copy the new file to the correct path inside `lobby-sudafrica-journal/images/real/`.

4.  **Verify:** Rerun the link checker test to confirm the fix.
5.  **Commit:** Commit the newly added images with a `fix(journal): ...` message.

- **Timezone Rule:** All events must be logged in Johannesburg time (SAST, GMT+2). If the system time is different, adjust manually by adding +1 hour (from CET/GMT+1).

## Post-South-Africa reconstruction

Ok, now the trip is gone and we want to harmonize and make sure the journal is complete and correct.

1. Check all the dates and times are correct.
2. Check all the files

### Pixar pictures vs real pictures

We have two types of pictures in the journal:

1. Pixar pictures: these are AI generated pictures that are stored in the `images/pixar/` directory.
2. Real pictures: these are pictures that are taken with a camera and are stored in the `images/real/` directory.

We need to make sure that all the pictures are in the correct directory and that the links in the journal are correct.
The mapping between pictures is being tracked in `~/.openclaw/workspace/banana_mapping.csv`: Ensure all mappings are in this file,
