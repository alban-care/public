#!/bin/bash

URL_FILE="urls.txt"
BASE_DIR="./"
FORCE_DOWNLOAD=false
VERBOSE=false

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --force) FORCE_DOWNLOAD=true ;;
    --verbose) VERBOSE=true ;;
    *) echo "⚠️ Unknown option: $1" ;;
  esac
  shift
done

# Check URLs file existence
if [ ! -f "$URL_FILE" ]; then
  echo "❌ File $URL_FILE not found!"
  exit 1
fi

# Read each URL line by line
while IFS= read -r url || [[ -n "$url" ]]; do
  [[ -z "$url" ]] && continue

  # Extract relative path after domain (everything after 3rd slash)
  relative_path=$(echo "$url" | cut -d/ -f4-)

  # Folder path to create
  dir_path="${relative_path%/*}"
  full_path="$BASE_DIR$relative_path"

  # Create directory if needed
  mkdir -p "$BASE_DIR$dir_path"

  # Skip if file exists and not forced
  if [ -f "$full_path" ] && [ "$FORCE_DOWNLOAD" = false ]; then
    echo "⏩ Skipped (already exists): $relative_path"
    continue
  fi

  # Download with verbose or quiet mode
  if [ "$VERBOSE" = true ]; then
    echo "⬇️ Downloading: $url → $full_path"
    wget --verbose "$url" -O "$full_path"
  else
    wget -q "$url" -O "$full_path"
  fi

  # Check download success
  if [ $? -eq 0 ]; then
    echo "✅ Downloaded: $relative_path"
  else
    echo "❌ Failed to download: $url"
  fi
done < "$URL_FILE"