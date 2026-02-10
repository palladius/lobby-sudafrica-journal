# justfile per i controlli di sicurezza del diario

# Alias comodo
default: check

# Esegue il controllo di sicurezza pre-commit
check:
    @echo "------------------------------------------------------------------"
    @echo "🛡️ Eseguo Pre-Commit Safety Check..."
    @echo "ATTENZIONE: Ricorda il bug del troncamento del file!"
    @echo "Controlla attentamente le 'deletions' qui sotto."
    @echo "Per dettagli, vedi issue #1 sul repository GitHub."
    @echo "------------------------------------------------------------------"
    @git diff --stat
