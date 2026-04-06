import os
import sys
from google import genai
from google.genai import types

api_key = "AIzaSyDJEB-1UBlqLjWtR3leusk4B3A1FLe8XCc"
client = genai.Client(api_key=api_key)

prompts = [
    ("A 3d pixar style cartoon image of an adult man with short brown hair, beaming smile, enjoying a South Africa adventure in front of a delivery truck, happy, sunny.", "jekyll-site/assets/images/2026-02-26/pixar_20260226_091218113.png"),
    ("A 3d pixar style cartoon image of a family: an adult man with short brown hair, an 8-year-old boy with dark hair, and a 5-year-old boy with blonde hair, all smiling and happy in South Africa.", "jekyll-site/assets/images/2026-02-26/pixar_20260226_173216465.png")
]

for prompt, output_path in prompts:
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

