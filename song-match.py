#!/usr/bin/env python3
import sys
from mutagen.mp3 import MP3
from mutagen.easyid3 import EasyID3
from collections import defaultdict
from pathlib import Path

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

    for files in metadata_map.values():
        if len(files) > 1:
            # Check if filenames are different
            filenames = {Path(f).name for f in files}
            if len(filenames) > 1:
                print("Matching song with different filenames:")
                for f in files:
                    print(f)
                print()

if __name__ == "__main__":
    main()

