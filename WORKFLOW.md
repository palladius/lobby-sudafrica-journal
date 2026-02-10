# Workflow del Diario di Viaggio

Questo file definisce i passaggi obbligatori da seguire per ogni aggiornamento del diario.

**0. Pre-Commit Safety Check (OBBLIGATORIO DOPO OGNI `edit`)**

A causa di un bug nel tool `edit` che può causare la sovrascrittura accidentale di file, è obbligatorio eseguire questo controllo di sicurezza DOPO ogni modifica a un file esistente e PRIMA di qualsiasi commit.

1.  Eseguire `git diff --stat`.
2.  Analizzare il numero di `deletions(-)`.
3.  **Se `deletions` > 5, FERMARSI IMMEDIATAMENTE.** Segnalare il warning con l'output del diff e attendere istruzioni.
4.  **Se `deletions` <= 5, comunicare l'output del diff e procedere.**

---

**1. Aggiornamento del Diario:**
   - Aggiungere note, racconti e dettagli forniti da Riccardo nel file del giorno corrente (es. `2026-02-10.md`).

**2. Gestione Immagini & Naming Convention:**
   - Per ogni foto originale ricevuta, creare una base di nome file logica e descrittiva (es. `ale_con_leoni`).
   - **Salvare l'immagine originale** nella cartella degli asset del giorno con un nome deterministico: `assets/images/YYYY-MM-DD/YYYY-MM-DD_[descrizione]_real.jpg`.
   - Generare una versione in stile Pixar usando la skill `nano-banana-pro`.
   - **Salvare l'immagine generata** con lo stesso nome base, ma suffisso `_pixar.png`: `assets/images/YYYY-MM-DD/YYYY-MM-DD_[descrizione]_pixar.png`.
   - Inviare l'immagine Pixar generata a Riccardo tramite il tool `message`.

**3. Unit Test (Verifica Integrità):**
   - **Test di Esistenza File:** Verificare che tutte le immagini generate e menzionate nel diario esistano.
   - **Test di Corrispondenza Pixar:** A fine sessione, contare i file `_real.jpg` e `_pixar.png` nella cartella del giorno. Se il numero non corrisponde, emettere un **WARNING** per una revisione manuale (utile per gestire casi speciali come le immagini combinate).

**4. Commit & Push:**
   - Eseguire il commit di tutte le modifiche (diario e immagini) usando il wrapper `safe-journal-git`.
   - Eseguire il push sul repository GitHub.
   - **Branch Principale:** Il branch remoto è `master`.

**5. Notifica Link:**
   - Dopo il push, inviare a Riccardo il link GitHub del file del diario appena aggiornato.
   - Formato del link: `https://github.com/palladius/lobby-sudafrica-journal/blob/master/YYYY-MM-DD.md`
