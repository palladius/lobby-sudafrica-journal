---
description: A complete workflow to help generate or fix a specific day's journal entry in South Africa.
---

# Complete Southafrica Day Workflow

This workflow guides the AI in reconstructing, generating, or fixing a specific day's journal entry from Riccardo's South Africa trip. 

When invoking this, the user expects the AI to follow these exact steps to recover text, fetch pictures, and output a harmonized Jekyll markdown file.

## Prerequisites

Start by defining the targeted day (e.g. `2026-02-14`). Ask the user if you aren't sure. 

Once the date `YYYY-MM-DD` is known, proceed.

## Step 1: History & Context Gathering

Gather existing history to understand what was already written or if there were temporary files we lost. Replace `YYYY-MM-DD` below with the actual given date.

// turbo
```bash
echo "1. Checking git history and file states for the target date..."
git status
git log --oneline --grep="YYYY-MM-DD" --all
git ls-tree -r HEAD --name-only | grep "YYYY-MM-DD" || true
```

Summarize the baseline text for the user before proceeding.

## Step 2: Media Collection

Ask the user to dump their original camera photos into `jekyll-site/assets/images/original/YYYY/MM/DD/` (or whichever inbound folder they prefer).

> **Wait for the user** to confirm they have dumped the photos.

## Step 3: Narrative Extraction

Ask the user: *"Tell me the story of the day or drop an audio transcript."* 
Use their response alongside the git history from Step 1 to draft a cohesive narrative.

## Step 4: Pixarization ("Bananize") & CSV Mapping

Now we parse the images in the inbound directory, generate AI pixarized ones, and map them in CSV. Run the `add-pics-to-journal.rb` automated script (adjust paths as necessary to map original to pixar images). Ensure every image gets a Pixar version and a descriptive caption.

// turbo
```bash
echo "Running the image-manager..."
ruby ~/.openclaw/workspace/skills/journal-image-manager/scripts/add-pics-to-journal.rb --scan --date YYYY-MM-DD
```

## Step 5: Markdown Harmonization

Review or create `jekyll-site/_posts/YYYY-MM-DD-title.md`. 
1. Ensure the frontmatter has `reviewed: false`.
2. Append the text drafted in step 3.
3. Integrate the image toggles exactly like this for every photo:

```liquid
{% include captionizer.html original="/assets/images/original/YYYY/MM/DD/photo.jpg" pixar="/assets/images/pixar/YYYY/MM/DD/photo.jpg" caption="Description" %}
```

## Step 6: Iteration & Sign-off

Present the harmonized page to the user for review. If it looks correct and no images are missing, change the frontmatter to `reviewed: true` and you are done!