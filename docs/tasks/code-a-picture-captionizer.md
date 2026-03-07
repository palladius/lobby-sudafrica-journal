Code a script "bin/find_caption_for_image.py <IMAGE>".

Use a nice prompt which can be used in a safari or Family trip to South Africa.

It should say if its Picture or Generated.

It should output a JSON object with the following fields:

- caption: The caption for the image. Put particular attention to the people in it, maybe there are 3 family members and another adult? How does he look like? Who might it be? Also which animals are in there?
- picture_type: The type of the image (Picture or Generated).
- confidence: The confidence level of the picture_type.
- family_members: The family members in the picture, based on facts below.
- animals: The animals in the picture, with respective cardinality.

Something like:

```json
{
  "caption": "A group of people enjoying a meal together. Here Alessandro seems to really love South Africa nature!",
  "type": "Picture", // or "AI-Generated"
  "family_members": ["Riccardo", "Kate", "Alessandro"],
  "confidence": 0.95,
  "animals": ["3 Lions", "2 Zebras", "1 Giraffe"]
}
```

Note the family is:

- Riccardo (me, adult with black/white short hair, brown hair)
- Kate (wife, blonde adult, green eyes)
- Alessandro (my 8y son, dark hair, green eyes)
- Sebastian (my 5y son, blonde hair, blue eyes)
