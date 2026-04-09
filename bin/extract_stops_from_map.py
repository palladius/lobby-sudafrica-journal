#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.10"
# dependencies = [
#     "python-dotenv",
#     "google-genai",
#     "pillow"
# ]
# ///

import sys
import os
import json
from dotenv import load_dotenv
from google import genai
from PIL import Image

def main():
    if len(sys.argv) < 2:
        print("Usage: bin/extract_stops_from_map.py <IMAGE>")
        sys.exit(1)

    image_path = sys.argv[1]
    
    # Load .env file from ~/.openclaw/
    env_path = os.path.expanduser('~/.openclaw/.env')
    load_dotenv(dotenv_path=env_path)
    
    api_key = os.getenv('GEMINI_API_KEY')
    if not api_key:
        print("Error: GEMINI_API_KEY not found.")
        sys.exit(1)

    client = genai.Client(api_key=api_key)
    img = Image.open(image_path)

    prompt = """
Analyze this image of a Franschhoek Wine Tram map or timetable.
Extract the list of stops/wineries mentioned in the image.
If there are multiple lines (e.g. Navy Line, Pink Line), separate them.
If there are directions or a specific order, preserve it.
We only care about the names of the stops.

Output a simple markdown list of the stops found.
"""

    response = client.models.generate_content(
        model='gemini-2.5-flash',
        contents=[img, prompt]
    )

    print(response.text)

if __name__ == "__main__":
    main()
