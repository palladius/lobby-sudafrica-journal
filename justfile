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
    @echo "🖼️ Eseguo Test Immagini..."
    @ruby test/test_images.rb

serve:
    cd jekyll-site && bundle install && bundle exec jekyll serve

push-cloudflare:
    @echo "🚀 Distribuzione su Cloudflare Pages... nothing to do you just need a git commit push.."

test: unit-tests

# Example utilization of the image captionizer
test-captionizer:
    @echo "🤖 Eseguo il Captionizer su un'immagine di test usando Gemini Vision..."
    ./bin/find_caption_for_image.py jekyll-site/assets/images/original/20260205/sebastian.jpg