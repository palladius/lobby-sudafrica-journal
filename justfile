# justfile per i controlli di sicurezza del diario

# Alias comodo
default: list 

list:
    just -l

# Esegue il controllo di sicurezza pre-commit
check:
    @echo "------------------------------------------------------------------"
    @echo "🛡️ Eseguo Pre-Commit Safety Check..."
    @echo "ATTENZIONE: Ricorda il bug del troncamento del file!"
    @echo "Controlla attentamente le 'deletions' qui sotto."
    @echo "Per dettagli, vedi issue #1 sul repository GitHub."
    @echo "------------------------------------------------------------------"
    @git diff --stat

# Esegue i test logici giornalieri (Google Photos, Link, Aggregazione)
unit-tests:
    @echo "🧪 Eseguo Unit Tests (Date from Feb 5 to 25)..."
    @ruby test/test_day.rb

serve:
    cd jekyll-site && bundle exec jekyll serve

push-cloudflare:
    @echo "🚀 Distribuzione su Cloudflare Pages... nothing to do you just need a git commit push.."

sync-images:
    @echo "📸 Sincronizzazione immagini per il diario..."
    @mkdir -p jekyll-site/assets/images/original/20260207 jekyll-site/assets/images/pixar/20260207
    @mkdir -p jekyll-site/assets/images/original/20260208 jekyll-site/assets/images/pixar/20260208
    @mkdir -p jekyll-site/assets/images/original/20260209 jekyll-site/assets/images/pixar/20260209
    @mkdir -p jekyll-site/assets/images/original/20260210 jekyll-site/assets/images/pixar/20260210
    @cp images/real/2026-02-07-* jekyll-site/assets/images/original/20260207/ 2>/dev/null || true
    @cp images/pixar/2026-02-07-* jekyll-site/assets/images/pixar/20260207/ 2>/dev/null || true
    @cp images/real/* jekyll-site/assets/images/original/20260208/ 2>/dev/null || true
    @cp images/pixar/* jekyll-site/assets/images/pixar/20260208/ 2>/dev/null || true
    @cp images/real/2026-02-09-* jekyll-site/assets/images/original/20260209/ 2>/dev/null || true
    @cp images/pixar/2026-02-09-* jekyll-site/assets/images/pixar/20260209/ 2>/dev/null || true
    @cp assets/images/2026-02-10/*.jpg jekyll-site/assets/images/original/20260210/ 2>/dev/null || true
    @cp assets/images/2026-02-10/*.png jekyll-site/assets/images/pixar/20260210/ 2>/dev/null || true
    @echo "✅ Immagini sincronizzate."