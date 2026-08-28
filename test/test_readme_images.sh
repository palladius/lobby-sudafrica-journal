#!/bin/bash

missing=0
images=$(grep -oE '(!\[[^]]*\]\([^)]+\)|<(img|video)[^>]+src="[^"]+")' README.md | sed -n -e 's/.*(\(.*\)).*/\1/p' -e 's/.*src="\([^"]*\)".*/\1/p')

for img in $images; do
  if [ ! -f "$img" ]; then
    echo "❌ ERROR: Broken image link in README.md: $img"
    missing=$((missing + 1))
  else
    echo "✅ OK: $img"
  fi
done

if [ "$missing" -gt 0 ]; then
  echo "🚨 Found $missing broken images in README.md!"
  exit 1
else
  echo "🎉 All images in README.md are OK!"
  exit 0
fi
