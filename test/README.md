# Testing Logic for Journal Entries

This directory contains scripts used to validate the day-by-day markdown files of the journal.

## `test_day.rb`

The main testing script is `test_day.rb`. It can be run without arguments to test all configured dates (currently hardcoded as our South Africa trip horizon: Feb 5th to Feb 25th, 2026), or you can pass a specific date formatted as `YYYY-MM-DD`.

### What Does the Script Test?

The script performs the following validation checks on each `YYYY-MM-DD.md` file:

1.  **Google Photos Link Generation:**
    Checks the first 10 lines of the document to ensure there is a standard Google Photos search link matching the date (e.g. `https://photos.google.com/search/YYYY-MM-DD`).
    _Why?_ To make it easy for anyone reading the file to quickly find the original, unedited photos from that day.

2.  **Image Paths Validation:**
    Scans the file for any markdown `![img](...)` or HTML `<img src="...">` tags.
    Every non-external image must be stored correctly under either `images/real/YYYYMMDD/` or `images/pixar/YYYYMMDD/`.
    _Why?_ To enforce a consistent separation between original photos and AI-reimagined Pixar versions, and to keep assets organized by day.
    _Bonus Check:_ It also verifies if the referenced image actually physically exists on the disk.

3.  **Aggregation Search (Orphan Data Detection):**
    Checks every _other_ markdown file in the root directory (excluding `README.md`, `GEMINI.md`, etc.) to see if they mention the target `YYYY-MM-DD` string.
    _Why?_ If another file mentions today's date, it could contain orphaned journal entries left behind during a refactoring. This warns the user, prompting them to merge that stray text into the main daily file.
