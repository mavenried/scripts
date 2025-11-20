#!/usr/bin/env python3
import sys
from mutagen.mp3 import MP3
from mutagen.easyid3 import EasyID3
from collections import defaultdict

def get_metadata(path):
    try:
        audio = MP3(path, ID3=EasyID3)
        title = audio.get('title', [''])[0].lower().strip()
        artist = audio.get('artist', [''])[0].lower().strip()
        album = audio.get('album', [''])[0].lower().strip()
        return (title, artist, album)
    except Exception:
        return None

def main():
    file_list = [line.strip() for line in sys.stdin if line.strip()]
    metadata_map = defaultdict(list)

    for file_path in file_list:
        meta = get_metadata(file_path)
        if meta:
            metadata_map[meta].append(file_path)

    # Print only truly unique songs (no duplicates)
    for files in metadata_map.values():
        if len(files) == 1:
            print(files[0])

if __name__ == "__main__":
    main()

