import os
import sys
from google import genai
from google.genai import types

api_key = "AIzaSyDJEB-1UBlqLjWtR3leusk4B3A1FLe8XCc"
client = genai.Client(api_key=api_key)

prompt = "A 3d pixar style cartoon image of an adult man with short brown hair, smiling, standing in front of a Google office building, holding affectionately a cute white lobster named Lobby. Romantic, nostalgic atmosphere."
output_path = "jekyll-site/assets/images/2026-02-26/pixar_me_with_lobster.png"

print(f"Generating {output_path}...")
response = client.models.generate_content(
    model="gemini-3-pro-image-preview",
    contents=prompt,
    config=types.GenerateContentConfig(
        response_modalities=["IMAGE"],
        image_config=types.ImageConfig(image_size="1024x1024")
    )
)
for part in response.parts:
    if part.inline_data is not None:
        image_data = part.inline_data.data
        with open(output_path, "wb") as f:
            f.write(image_data)
        print(f"Saved {output_path}")
