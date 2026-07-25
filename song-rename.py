#!/usr/bin/env python3
import sys
from mutagen.mp3 import MP3
from mutagen.easyid3 import EasyID3
from pathlib import Path
import re

def clean_filename(s):
    # Remove characters not allowed in filenames
    return re.sub(r'[<>:"/\\|?*]', '', s)

def get_metadata(path):
    try:
        audio = MP3(path, ID3=EasyID3)
        title = audio.get('title', [''])[0].strip()
        artist_list = audio.get('artist', [''])[0].strip()
        return title, artist_list
    except Exception:
        return None, None

def main():
    for line in sys.stdin:
        file_path = line.strip()
        if not file_path:
            continue

        title, artist_str = get_metadata(file_path)
        if not title or not artist_str:
            print(f"Skipping {file_path}: missing metadata")
            continue

        artists = [a.strip() for a in re.split(r'[/;]', artist_str)]
        new_name = f"{', '.join(artists)} - {title}.mp3"
        new_name = clean_filename(new_name)

        old_path = Path(file_path)
        new_path = old_path.with_name(new_name)

        # Avoid overwriting existing files
        if new_path.exists():
            print(f"Skipping {file_path}: target {new_path} already exists")
            continue

        old_path.rename(new_path)
        print(f"Renamed: {old_path} -> {new_path}")

if __name__ == "__main__":
    main()
