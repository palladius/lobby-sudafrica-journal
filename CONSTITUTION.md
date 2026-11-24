# 📜 CONSTITUTION — Lobby Sudafrica Journal

Regole inviolabili per tutti gli agenti e collaboratori che lavorano su questo repository.

## 🛡️ 1. Tutela dei Bambini & Niente Nudità

- **MAI** pubblicare, committare o pushare foto in cui sia visibile nudità (in particolare zona pubica) dei bambini (Ale, Seby o altri minori).
- Se una foto di piscina, spiaggia o bagnetto contiene nudità di un bambino:
  1. **Prima** di salvarla in `jekyll-site/assets/images/original/`, usa un edit fotorealistico (`bin/pixerizza.py --prompt "..."` o inpainting) per aggiungere **mutande o costumino da bagno** in modo naturale.
  2. **Verifica visivamente** la foto editata prima di generare la versione Pixar (che deve partire dalla foto già editata con costumino).
  3. **Mai** committare la foto originale non editata in Git.

## 📸 2. Qualità e Consistenza delle Immagini

- Usare sempre il toggle `{% include captionizer.html original="..." pixar="..." caption="..." %}` per ogni coppia foto.
- Aggiornare sempre `images_mappings.csv` e verificare con `just test` prima di ogni commit.
