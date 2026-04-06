#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "google-genai",
# ]
# ///
import os
import sys
import argparse
from google import genai
from google.genai import types

def main():
    parser = argparse.ArgumentParser(description="Cartoonizza un'immagine in stile 3D Pixar usando Gemini.")
    parser.add_argument("input_image", help="Percorso dell'immagine di input (es. foto.jpg)")
    parser.add_argument("output_image", nargs="?", help="Percorso dell'immagine di output (opzionale)")
    parser.add_argument("--prompt", default="Accurately cartoonize the following photo by reimagining it in a 3D Pixar animation style. Keep the exact composition of the image, the poses, the expressions, the general colors, and the environment perfectly intact, but make them look like characters from a Pixar animated movie.", help="Prompt personalizzato")
    args = parser.parse_args()

    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        print("ERRORE: Devi impostare la variabile d'ambiente GEMINI_API_KEY esplictamente.")
        sys.exit(1)

    if not os.path.exists(args.input_image):
        print(f"ERRORE: File '{args.input_image}' non trovato.")
        sys.exit(1)

    input_path = args.input_image
    if args.output_image:
        output_path = args.output_image
    else:
        base, ext = os.path.splitext(input_path)
        output_path = f"{base}-pixar.png"

    client = genai.Client(api_key=api_key)

    print(f"Uploading '{input_path}'...")
    uploaded_file = client.files.upload(file=input_path)

    print(f"Pixerizzando usando il prompt:\n'{args.prompt}'...")
    
    # Configurazione della generazione immagine
    response = client.models.generate_content(
        model="gemini-3-pro-image-preview", 
        contents=[
            uploaded_file,
            args.prompt
        ],
        config=types.GenerateContentConfig(
            response_modalities=["IMAGE"],
            image_config=types.ImageConfig(image_size="1024x1024")
        )
    )

    image_data = None
    for part in response.parts:
        if part.inline_data is not None:
            image_data = part.inline_data.data
            break
            
    if image_data:
        with open(output_path, "wb") as f:
            f.write(image_data)
        print(f"Successo! Immagine Pixar salvata in: {output_path}")
    else:
        print("ERRORE: La risposta non contiene dati immagine validi.")

    # Pulizia del file caricato
    client.files.delete(name=uploaded_file.name)

if __name__ == "__main__":
    main()
