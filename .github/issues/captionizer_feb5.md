# Captionizer Integration for Feb 5

**Title:** Add captionizer for Feb 5 images
**Labels:** enhancement, feb5

**Description:**
Implemented a Ruby captionizer script (`bin/captionizer.rb`) that generates HTML for displaying an image with a centered caption and a second image as a hoverable preview or link. Added a Jekyll include (`_includes/captionizer.html`) to embed this functionality in posts. Updated the Feb 5 post (`jekyll-site/_posts/2026-02-05-partenza-da-zurigo.md`) to use the new include with the Alessia comment caption.

**Tasks Completed:**

- Created `bin/captionizer.rb`.
- Added `_includes/captionizer.html`.
- Modified the Feb 5 post to include the captionizer.
- Drafted this GitHub issue to track the work.

**Next Steps:**

- Review the changes locally (`jekyll serve`).
- Merge the changes into `master`.
- Close this issue once verified.
