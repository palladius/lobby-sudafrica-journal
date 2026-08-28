---
name: polaroid-presentation-and-video
description: Creazione di uno slideshow animato HTML (stile Polaroid) ed esportazione in video tramite Playwright
---

# Polaroid Presentation & Video Generator

Questa skill descrive il processo per generare un video emozionale a partire da una cartella di foto. 
L'obiettivo è creare una presentazione animata in HTML/CSS/JS (ad esempio foto che cadono a mo' di Polaroid sul tavolo) e registrarla automaticamente in un file `.webm` utilizzando un browser headless (Playwright).

## 1. La logica HTML (Slideshow Animato)

L'animazione sfrutta le transizioni CSS per far apparire e muovere degli elementi nel DOM.
La logica di base prevede:

1. **Setup della Viewport**: `body` impostato su `100vw` e `100vh` con `overflow: hidden`, colore di sfondo o testo enorme (come un titolo gigante `z-index: 0`).
2. **Caricamento Immagini**: Uno script Javascript legge un array di immagini.
3. **Generazione e Animazione Dinamica**: 
   - Una funzione temporizzata (es. ogni secondo) crea dinamicamente elementi `div` con all'interno l'immagine.
   - All'elemento viene applicata inizialmente la classe CSS base: dimensioni, ombra (`box-shadow`), bordo bianco (`padding`), rotazione a zero e scala ridotta, più un'opacità a 0.
   - Vengono calcolate le posizioni casuali per le X e le Y.
   - **Alternanza logica della rotazione**: Per evitare che le foto si inclinino tutte dallo stesso lato, si utilizza una variabile booleana (es. `nextTiltLeft`) per invertire il segno della rotazione casuale ad ogni scatto.
   - Dopo aver inserito il nodo, tramite un piccolissimo delay (`setTimeout` di 50ms per forzare il *reflow*), viene cambiata la classe (portando opacità a 1 e scala a 1) per innescare una `transition` CSS super fluida e "lanciare" la foto sul tavolo.

Un file di esempio funzionante completo si trova in `references/sample.html`.

## 2. Esportazione in Video (Node + Playwright)

Non serve ffmpeg complesso! Basta usare `Playwright`, che ha un fantastico supporto nativo per la registrazione dello schermo dei browser headless.

1. **Prerequisiti**: 
   - Creare un progettino locale (`npm init -y`)
   - `npm install playwright`
   - `npx playwright install chromium`

2. **Servire la pagina**:
   La pagina HTML deve poter leggere le immagini localmente, quindi prima di far partire il browser, servi la cartella via HTTP (es. `python3 -m http.server 8085`).

3. **Script di Registrazione Node.js**:
   Lo script apre un *BrowserContext* a cui passa l'impostazione `recordVideo` puntando ad una cartella `videos/`.
   Inoltre, per assicurarsi che l'HTML percepisca il monitor corretto, bisogna impostare `viewport` a `1920x1080` e passare `args: ['--window-size=1920,1080']`.

   *Vedi il file di esempio in `references/record_polaroid.js` per lo script Node.*

## Passaggi Workflow:

1. Sposta le tue foto selezionate in una cartella.
2. Adatta `sample.html` nella cartella e aggiorna l'array Javascript `images` coi nomi delle tue foto.
3. Lancia `python3 -m http.server 8085` nella cartella foto.
4. Avvia lo script Playwright configurato e attendi che la registrazione termini.

## 3. Visualizzazione Rapida su GitHub (Trucco htmlpreview)

Molto spesso, quando committi i file HTML su GitHub, la piattaforma non li renderizza nativamente nel browser (mostrando solo il codice sorgente) a meno che tu non abbia configurato **GitHub Pages**. 
Tuttavia, c'è un trucco geniale e immediato per visualizzare la presentazione: **htmlpreview.github.io**.

Basta prendere l'URL del tuo file HTML caricato su GitHub (ad esempio `https://github.com/tuouser/repo/blob/master/presentation/file.html`) e **prefiggerlo** con `https://htmlpreview.github.io/?`.

**Esempio pratico nel README.md:**
```markdown
[Clicca qui per vedere la presentazione!](https://htmlpreview.github.io/?https://github.com/palladius/lobby-sudafrica-journal/blob/master/presentation/123-merged.it.html)
```

Questo servizio proxy gratuito prende l'HTML crudo da GitHub, lo renderizza al volo risolvendo anche i path relativi per immagini e CSS, e ti mostra la presentazione animata a tutto schermo senza dover configurare alcun server Web!
