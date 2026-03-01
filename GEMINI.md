# Lobby Journal Technical Guide

## 🛠️ Environment & Git
- **Repo:** `https://github.com/palladius/lobby-sudafrica-journal/`
- **Branch:** `master` only. **DO NOT use `main`**.
- **Timezone:** Always SAST (GMT+2).

## 🖼️ Image Management & Recovery
- **Types:**
  - **Pixar:** AI-generated (`images/pixar/`).
  - **Real:** Camera photos (`images/real/`).
- **Mapping:** All AI/Real pairings **MUST** be tracked in `~/.openclaw/workspace/banana_mapping.csv`. Update this file if moving/renaming images.
- **Recovery:**
  - **Pixar:** Search `~/.openclaw/workspace/nano_banana/` by date/name.
  - **Real:** Search session history for `telegram-USERID-MSGID.jpg` and ask Riccardo to re-upload.

## 🧪 Post-Trip Harmonization
1. Ensure all dates/times are correct.
2. Verify all image links in `.md` files.
3. Confirm all mappings exist in `banana_mapping.csv`.
