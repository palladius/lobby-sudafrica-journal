# Investigation: Valley of Sun City (Feb 9/10)

## Status

- **Feb 9 (Sun City / Valley of Waves):**
  - FOUND: `tmp/2026-02-09-commit-ebf6780.md` contains 221 lines of "GOLD" content.
  - MISSING: `jekyll-site/_posts/2026-02-09-sun-city-valley-of-waves.md` is mostly empty (placeholder only).
  - CAUSE: Commit `37792641235527a0bfed271631ee6efdfc3a38fa` ("Fix Feb 9th and 10th posts") accidentally deleted the original content during rename/re-org.

- **Feb 10 (Last Safari / Donkey Valley):**
  - CURRENT: `jekyll-site/_posts/2026-02-10-l-ultimo-safari-e-la-partenza-verso-la-valle-degli-asini.md` has ~60 lines.
  - TODO: Verify if any content was lost from the original `2026-02-10.md` during the same commit.

## Recovery Steps

1. [ ] Restore Feb 9th content from `tmp/2026-02-09-commit-ebf6780.md` to `jekyll-site/_posts/2026-02-09-sun-city-valley-of-waves.md`.
2. [ ] Convert `images/pixar/` and `images/real/` paths to Jekyll-compatible `/assets/images/...`.
3. [ ] Check `images_mappings.csv` for the Sun City images.
4. [ ] Run `just test` to verify.
