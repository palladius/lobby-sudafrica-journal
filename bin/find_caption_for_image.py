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
import csv
from datetime import datetime
from dotenv import load_dotenv
from google import genai
from google.genai import types
from PIL import Image

def main():
    if len(sys.argv) < 2:
        print("Usage: bin/find_caption_for_image.py <IMAGE>")
        sys.exit(1)

    image_path = sys.argv[1]
    if not os.path.exists(image_path):
        print(f"Error: Image '{image_path}' not found.")
        sys.exit(1)

    # Load .env file explicitly from the project root
    env_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), '.env')
    load_dotenv(dotenv_path=env_path)
    
    api_key = os.getenv('NANOBANANA_GEMINI_API_KEY')
    if not api_key:
        print("Error: NANOBANANA_GEMINI_API_KEY not found in .env or environment.")
        sys.exit(1)

    # Initialize Gemini client
    client = genai.Client(api_key=api_key)

    # Load image
    img = Image.open(image_path)

    prompt = """
Analyze this image from a family safari trip to South Africa in 2026.
It could be a real photograph or an AI-generated/Pixar-style recreation.

Family members profile to help identify them:
- Riccardo: Adult male, black/white short hair, brown hair. Sometimes wears glasses.
- Kate: Adult female, blonde hair, green eyes.
- Alessandro: 8-year-old boy, dark hair, green eyes.
- Sebastian: 5-year-old boy, blonde hair, blue eyes.

Provide a descriptive and fun caption suitable for a travel journal.
Also identify if the picture is an actual Picture or AI-Generated (Pixar style). It is highly likely that images with a cartoon look are AI-Generated.
Identify which family members are present.
Identify which animals are present and their quantity (e.g. "3 Lions").

Output strictly a JSON object with this exact schema:
{
  "caption": "A group of people enjoying a meal together. Here Alessandro seems to really love South Africa nature!",
  "picture_type": "Picture", // or "AI-Generated"
  "family_members": ["Riccardo", "Kate", "Alessandro"],
  "confidence": 0.95,
  "animals": ["3 Lions", "2 Zebras", "1 Giraffe"]
}
"""

    response = client.models.generate_content(
        model='gemini-2.5-flash',
        contents=[img, prompt],
        config=types.GenerateContentConfig(
            response_mime_type="application/json",
        ),
    )

    try:
        content_text = response.text.strip()
        # Clean up markdown code blocks if the model insists on adding them
        if content_text.startswith('```json'):
            content_text = content_text[7:]
            if content_text.endswith('```'):
                content_text = content_text[:-3]
        
        parsed_json = json.loads(content_text.strip())
        
        # Try to find date in images_mappings.csv first
        creation_date = None
        csv_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'images_mappings.csv')
        image_basename = os.path.basename(image_path)
        
        if os.path.exists(csv_path):
            try:
                with open(csv_path, 'r', encoding='utf-8') as f:
                    reader = csv.DictReader(f)
                    for row in reader:
                        orig_path = row.get("OriginalPhotoPath", "")
                        if orig_path and os.path.basename(orig_path) == image_basename:
                            timestamp_str = row.get("Timestamp", "")
                            if timestamp_str:
                                dt = datetime.fromisoformat(timestamp_str.replace('Z', '+00:00'))
                                creation_date = dt.strftime("%Y-%m-%d")
                                break
            except Exception as e:
                print(f"Warning: Could not read images_mappings.csv: {e}", file=sys.stderr)

        if not creation_date:
            # Fallback to file modification/creation time
            stat = os.stat(image_path)
            try:
                c_time = stat.st_birthtime
            except AttributeError:
                c_time = stat.st_mtime
            creation_date = datetime.fromtimestamp(c_time).strftime("%Y-%m-%d")
        
        parsed_json["creation_date"] = creation_date
        
        print(json.dumps(parsed_json, indent=2))
        
    except Exception as e:
        print(f"Error parsing response: {e}")
        print("Response text was:", response.text)
        sys.exit(1)

if __name__ == "__main__":
    main()
