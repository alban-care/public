# CDN — Setup a Literally Free CDN with jsDelivr & Statically + Download Script 🚀

Welcome to the **"Free CDN Party"** 🎉! Why pay for expensive CDNs when you can use amazing free services like **jsDelivr** and **Statically**? Plus, I’ll hook you up with a handy Linux script to download your assets locally — preserving folder structure, skipping duplicates, and making your life easier. Let’s dive in!

---

## How to Setup a Literally Free CDN 🆓✨

You just need to host your assets on GitHub (or similar), then serve them through jsDelivr or Statically CDN like this:

### jsDelivr Examples:

- `https://cdn.jsdelivr.net/gh/alban-care/public@main/assets/platform/Google/icon.svg`
- `https://cdn.jsdelivr.net/gh/alban-care/public@main/assets/platform/Google/logo.svg`

### Statically Examples:

- `https://cdn.statically.io/gh/alban-care/public/main/assets/platform/Google/icon.svg`
- `https://cdn.statically.io/gh/alban-care/public/main/assets/platform/Google/logo.svg`

---

## Want to download all those assets locally? Here’s a script for you! 💻🐧

If you want to **mirror those assets on your machine**, this script:

- Reads a list of URLs from a file (`urls.txt`)
- Creates the folder structure automatically
- Skips already downloaded files unless you force redownload
- Shows detailed output if you want
- Handles any URL and preserves path structure after the domain

---

### How to use it?

1. Put your URLs in `urls.txt` (one URL per line)
2. Run the script with optional flags `--verbose` and `--force`:

```bash
./download-assets.sh --verbose
./download-assets.sh --force --verbose
```

### The magic script: download-assets.sh

```bash
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
```

### Why this script rocks 🤘

- Keeps your folder structure intact — no messy file dumps

- Smart skipping — won’t waste time redownloading existing files unless you tell it

- Verbose mode — for when you want all the juicy details

- Works for any URL — just make sure URLs start with http:// or https://

- Simple to modify — easily add extra options or change base directory

### Example urls.txt file 📄

```bash
https://<domaine>/assets/platform/Google/logo.svg
https://<domaine>/assets/platform/Google/icon.svg
https://<domaine>/assets/platform/Linkedin/logo.svg
https://<domaine>/assets/platform/Linkedin/icon.svg
```

### Final notes ✍️

- Make sure the script is executable:

```bash
chmod +x download-assets.sh
```

- Run the script from the folder where you want the files to be saved (or modify BASE_DIR in the script).

- Enjoy your free CDN workflow! 🌐💥

- Need help? Just ask!
