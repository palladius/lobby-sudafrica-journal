# Workflow: Diario Sudafrica

**Regola Aurea: Non Riscrivere la Cronologia di Git!**
- **MAI USARE:** `git reset --hard`, `git push -f`.
- **USARE SEMPRE:** `git commit` per nuove modifiche, e `git revert [hash]` per annullare un commit sbagliato. La cronologia deve essere immutabile per permettere un recupero sicuro.

Questo file contiene le istruzioni operative per l'agente che aggiorna questo diario.

**Trigger:** Riccardo invia una foto/video/nota relativa al viaggio in Sudafrica.

---

### **Procedura Standard**

1.  **Contesto:** Ricorda sempre che la timezone di riferimento è Johannesburg (GMT+2). Siamo a Febbraio 2026.
2.  **Aggiungi alla TODO List:** Aggiungi subito la foto alla `PIXAR_TODO.md` nel workspace principale.
3.  **"Pixarizza":** Usa `nano-banana-pro` per creare una versione "Pixar" dell'immagine.
4.  **Organizza i File:**
    - Copia la foto **originale** in `images/real/`.
    - Copia la foto **generata** in `images/pixar/`.
5.  **Aggiorna il Diario:**
    - Apri il file Markdown del giorno corretto (es. `2026-02-08.md`).
    - **Metodo Sicuro:** Leggi l'intero contenuto del file, aggiungi le nuove sezioni in memoria, e riscrivi il file completo.
6.  **Controllo Pre-Commit (PRESUBMIT):**
    - `git status` per vedere i file modificati.
    - `git diff --stat` per un riassunto delle modifiche. Se vedi delezioni inaspettate, fermati.
    - **Verifica link:** Controlla che tutti i percorsi delle immagini nel file `.md` esistano.
    - **Verifica duplicati:** Controlla che le nuove foto non siano già presenti.
7.  **Commit & Push:**
    - Se i controlli passano, procedi: `git add .`, `git commit`, `git push`.
8.  **Notifica Riccardo:**
    - Invia conferma, foto Pixar e link al `README.md`.
9.  **Spunta la TODO List:** Aggiorna la `PIXAR_TODO.md`.
