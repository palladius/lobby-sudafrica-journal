For every day from 2026-02-05 to 2026-02-25:

### We are looking at day 2026-02-XX

Launch the script:

```bash
bin/find_openclaw_images.sh 2026-02-XX
```

1. Find all images in /home/riccardo/.openclaw/workspace/nano_banana/ that match the date.
2. Copy them to jekyll-site/assets/images/YYYY-MM-DD/.
3. Copy the original images from /home/riccardo/.openclaw/media/inbound/YYYY-MM-DD/ to jekyll-site/assets/images/original/YYYY-MM-DD/.
4. Review this critically. Maybe an original is in reality a banana pic, or viceversa? Use your multimodal skills to find it out.
5. Update the .md file to link to the new images. If in doubt, add an Appendix H2 below with "For Riccardo to review".
6. Update the `image_mappings.csv` file to include the new mappings.
7. Commit the changes with a message like "Day 2026-02-XX: Images and mappings updated".
8. Any doubt, ideas, log, questions, log them into tmp/YYYY-MM-DD.md
