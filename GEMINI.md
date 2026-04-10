# Lobby Journal Technical Guide

This GH repo was created by Openclaw while Riccardo was dictating stuf via Telegram on a trip to Southafrica, with zero access to the machine! The files are quite messy and unorganized.

- `git log` should highlight a huge commit for each day, where Openclaw created the file and added all the content. Some files were mistakenly overwritten insted of edited, so good info has been delted, like in 10feb example. `git diff` on GITROOT/2026-10-DD.md should show an interesting diff, and many DELETED files should show the bug in the editing tool that Lobby had at the time.

## 🛠️ Environment & Git

- **Repo:** `https://github.com/palladius/lobby-sudafrica-journal/`
- **Branch:** `master` only. **DO NOT use `main`**.
- **Timezone:** Durign the trip, assume always SAST (GMT+2).

## 🖼️ Image Management & Recovery

- **Types:**
  - **Pixar:** AI-generated (`images/pixar/`).
  - **Real:** Camera photos (`images/real/`).
- **Mapping:** All "original" OpenClaw AI/Real pairings **were** tracked in `~/.openclaw/workspace/banana_mapping.csv`. This file is now obsolete, but it was used to move/rename images. Now we use `images_mappings.csv` in the root of this repo, which is richer.
- **Recovery & Reconstruction:**
  - **Skill:** Use the `journal-image-manager` skill (and its `transcribe-audio-in-text.py` script) to reconstruct the full conversation and activity flow from `~/.openclaw/media/inbound/`.
  - **Find Missing Images:** Use `add-pics-to-journal.rb --scan` or the `find_images.rb` script from the `openclaudio-on-minilobby` skill to locate lost images in `inbound` or `nano_banana` without searching session history manually.
  - **Manual Fallback:** If a file is truly missing from `inbound`, search session history for `telegram-USERID-MSGID.jpg` and ask Riccardo to re-upload.

### 📊 Image Mapping & Automated Tools

`images_mappings.csv` contains a very simple schema: `Timestamp, OriginalPhotoPath, PixarPhotoPath, PixarPhotoDescription`.

To automate adding images and updating the CSV, use the Ruby script:

```bash
# To scan a day for missing images in the workspace:
ruby ~/.openclaw/workspace/skills/journal-image-manager/scripts/add-pics-to-journal.rb --scan --date YYYY-MM-DD

# To add a specific pair:
ruby ~/.openclaw/workspace/skills/journal-image-manager/scripts/add-pics-to-journal.rb --original <path> --pixar <path> --description "..." --date YYYY-MM-DD
```

**RIGHT Folders:**

- **Originals:** `jekyll-site/assets/images/original/YYYY/MM/DD/`
- **Pixar:** `jekyll-site/assets/images/pixar/YYYY/MM/DD/`

## 🧪 Post-Trip Harmonization

1. Ensure all dates/times are correct.
2. Verify all image links in `.md` files. **NEW RULE**: Use the interactive toggle template: `{% include captionizer.html original="..." pixar="..." caption="..." %}` (do as in jekyll-site/\_posts/2026-02-21-colori-panorami-e-una-lezione-di-vita.md page which is perfect).
3. Confirm all mappings exist in `banana_mapping.csv`.
4. Use `git mv` to move files from `images/XXX` to `jekyll-site/assets/images/YYYY-MM-DD/`.

More under `CLEANUP_ORGANIZATION.md`

## Move to jekyll, CloudFlare pages and wrangler

1. `git mv 2026-02-XX.md` into `jekyll-site/_posts/YYYY-MM-DD-title-of-the-day.md`. This is important, to preserve the order of the posts and the history of the files. Lobby did A LOT of small commits, and might have removed some files.
2. Check git log of that file since inception. Shouldnt be more than 10 changes each. Look if there was any change that removed more than 3 lines at once. If so, this is a sign of a bug in Edit tool (edit becomes a substitution) -> in this case dump this as 2026-02-XX-commit-YYYYYY.md so a human can review how to integrate the lost data in current one.
3. Take notes into `tmp/2026-02-XX.log`.
4. run `just test` to catch for automated errors. Any broken images, ensure they get fixed, possibly by moving images from ./images/ or ./assets/ into jekyll-site/assets/images/ . Remember the DATE and pixar/original dichotomy!
5. After you're done, use the "NICE list" summary (see above) or the `add-pics-to-journal.rb --scan` tool to find any missing images. The `bin/find_openclaw_images.sh` is now **legacy** and should only be used if the other tools fail.
6. If this is a BIG thing, andor if user is not listening, open a <gh> bug on the repo like "Riccardo review day XX" and link the page and the added pictures so user can review which pictures should be put there. For every additional picture, add a line in the bug report with a possible name/description. If this is very LLM intensive, feel free to code a "bin/find_caption_for_image.sh <IMAGE>". Use a nice prompt which can be used in a safari or Family trip to South Africa. Also it should say if its Picture or Generated.

## Skills

- If you are on `pupurabbux` or `mini-lobby` (check `hostname`), you can use the "Lobby on Pupurabbux" skill (now called `openclaudio-on-minilobby`) to find missing images.
  - LIkely the skill is in `~/git/gemini-cli-palladius-private-goodies/skills/openclaudio-on-minilobby`.
  - Use the amazing `find_images.rb` in there! Try: `~/git/gemini-cli-palladius-private-goodies/skills/openclaudio-on-minilobby/scripts/find_images.rb -d [DAYAGO] -f`
- use `bin/pixerizza.py` to pixerize original pictures moved from Google Photos.

## Tests

- Before commit, launch tests: `just test`
- You can also test a single day like this: `TEST_SUDAFRICA_DAY=20260210 just test`

## Git

- **IMPORTANT** use `git mv` whenever possible!!! Dont `mv` as it looks like git rm + git add and we lose history!!!
- do NOT commit files in private/ or tmp/. I need to keep tmp/ out of gitignore to let AI manage files in there! ;)

## Posts

A post frontmatter should sth like this:

```markdown
---
layout: post
title: "A meaningful title of 4-10 words"
date: 2026-02-DD HH:MM:SS +0200
categories: diario
cover-img: /assets/images/ path to the cover image on top, hopefully a WIDE image
thumbnail-img: /assets/images/ path to the thumbnail image on top, hopefully square-ish
reviewed: false
---
```
