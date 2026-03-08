#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <YYYY-MM-DD>"
  echo "Example: $0 2026-02-06"
  exit 1
fi

DATE1="$1"
DATE2=$(echo "$1" | tr -d '-')

echo "IMPOTYANT NOTE FROM RICCARDO: this might be obsoleted today: we have a better ruby script in the Lobby Pupurabbux SKILL. Consider retiring this script."
echo "🔍 Searching for media matching '$DATE1' or '$DATE2' in /home/riccardo/.openclaw..."

find /home/riccardo/.openclaw -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.mp4" \) 2>/dev/null | grep -E "($DATE1|$DATE2)" || echo "No files found."

echo "🔍 Searching for media matching '$DATE1' or '$DATE2' in here..."

find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.mp4" \) 2>/dev/null | grep -E "($DATE1|$DATE2)" || echo "No files found."
