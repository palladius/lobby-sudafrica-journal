# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Note: version should be in `jekyll-site/_config.yml`

## [0.1.1] - 2026-04-10

### Fixed

- **Images:** Moved missing `07-franschhoek-tram.png` to correct `pixar` directory and fixed world-readable permissions for all original images in February 23rd post.
- **Tests:** Updated `test/test_day.rb` to allow `/assets/images/pixar/YYYY/MM/DD/` and `/assets/images/original/YYYY/MM/DD/` image paths, resolving false failures in February 23rd post.
- **Tests:** Updated `test/test_day.rb` to prioritize Jekyll posts and skip Google Photos link validation if `reviewed: true` or provided by Jekyll layout banner.

## [0.1.0] - 2026-04-10

### Added

- **Magic Split View Tool**: Added a developer-only floating button (`🧪 Split View (Dev)`) on journal pages that activates a 50/50 vertical layout comparing original and Pixar-processed photos. Perfect for visual auditing while editing!
- Enhanced `captionizer.html` to smoothly transition to a CSS `clip-path` driven vertical split view when Magic mode is active.
