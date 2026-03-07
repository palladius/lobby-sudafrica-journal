PS I see a lot of duplicate images between images/ and assets/ and jekyll-site/ Can we start removin some dupes?

Find duplicates in these folders:

```bash
find images/ assets/ jekyll-site/assets/ -type f -print0 | xargs -0 md5sum | sort | uniq -w32 --all-repeated=separate | tee dupes.txt
```

Take the most meaningful one and remove the others.
