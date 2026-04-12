# justfile per i controlli di sicurezza del diario

# Alias comodo
default: list 
status:
    @ruby bin/status.rb

list:
    just -l
    gh issue list

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
    @ruby test/main.rb

# Serve on port 4041 since 4000 is used also by NX.
serve:
    cd jekyll-site && bundle install && bundle exec jekyll serve --port 4041

web:serve 

push-cloudflare:
    @echo "🚀 Distribuzione su Cloudflare Pages... nothing to do you just need a git commit push.."
push: push-cloudflare

test: unit-tests

# Pulizia dei file temporanei e dei build di Jekyll
clean:
    @echo "🧹 Pulizia in corso..."
    rm -rf jekyll-site/_site
    rm -rf jekyll-site/.jekyll-cache
    rm -rf .venv
    @echo "✨ Pulizia completata!"

# Example utilization of the image captionizer
test-captionizer:
    @echo "🤖 Eseguo il Captionizer su un'immagine di test usando Gemini Vision..."
    ./bin/find_caption_for_image.py jekyll-site/assets/images/original/20260205/sebastian.jpg