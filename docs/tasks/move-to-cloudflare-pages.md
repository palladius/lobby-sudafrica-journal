## Move to jekyll, CloudFlare pages and wrangler

Copy config from `lobby-ricc-pvt-journal.pages.dev` which works well.

Setup on CloudFlare Pages is:

- **Root Directory**: `jekyll-site`
- **Build command**: `bundle exec jekyll build`
- **Output Directory**: `_site`
- **Deploy command**: `npx wrangler deploy --no-build`
