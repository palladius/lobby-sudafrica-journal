# Day Processing Workflow

This workflow describes the step-by-day process for cleaning up journal entries, organizing media, and recovering data that might have been accidentally deleted in the past.

## Process for each day (`YYYY-MM-DD`):

### 1. File Organization

- Ensure the day has a unique file named `YYYY-MM-DD.md`.
- Read the content of the file to understand the current state.
- **Link:** Ensure there is a link to Google Photos at the top of the file: `[📸 Visualizza foto originali su Google Photos](https://photos.google.com/search/YYYY-MM-DD)`

### 2. Image Management

- Create subfolders `images/real/YYYYMMDD/` and `images/pixar/YYYYMMDD/` if they don't already exist.
- Move any referenced or newly discovered images for that day into these subfolders based on whether they are real or generated.
- Update the markdown file to point to the new image paths (`images/real/YYYYMMDD/...` or `images/pixar/YYYYMMDD/...`).
- **Normal/Pixar Pairs:** For every picture, attempt to have one normal photo and one "Pixar" style photo if available.
- **CSV Check and Update:**
  - Look up `banana_mapping.csv` (in `../workspace/banana_mapping.csv`) to map generated Pixar images back to their original source paths or to understand which images correspond to which day.
  - **BACKFILL:** If you find a new pair of normal/Pixar images that aren't in the CSV, append them to `../workspace/banana_mapping.csv` for future reference (format: `source_path,generated_path`).

### 3. Data Recovery (Looking for big DESTROYS)

- Run a git log search for the file `YYYY-MM-DD.md` to see its history.
- Specifically look at commits on the day itself (`YYYY-MM-DD`), the day before, and the day after.
- **Action:**
  ```bash
  git log -p -- YYYY-MM-DD.md
  # or specifically looking for large deletions:
  git log -p -S "some keyword" -- YYYY-MM-DD.md
  ```
- Review the diffs for any large blocks of red (`-` lines) that indicate deleted content. If narrative, logs, or lists were accidentally deleted by a previous AI tool, recover that text and re-integrate it into the current `YYYY-MM-DD.md`.

### 4. Logging Changes

- Once the file is processed, create a short log file in `tmp/YYYY-MM-DD.log`.
- Document exactly what was done for that day (e.g., "Moved 3 images, recovered 2 paragraphs from git history, added Pixar mappings").
