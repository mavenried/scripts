#!/bin/env python3
import sys
import urllib.request

from bs4 import BeautifulSoup

song, singers = [i.strip() for i in sys.stdin.read().strip().split(" by ")]
singers = singers.split("/")
song = "".join([i.lower() for i in song if not i.isspace()])
for i, singer in enumerate(singers):
    try:
        singer = "".join([i.lower() for i in singer if not i.isspace()])
        url = "https://www.azlyrics.com/lyrics/" + singer + "/" + song + ".html"

        raw = urllib.request.urlopen(url)
        data = raw.read()

        soup = BeautifulSoup(data, "html.parser")
        # print(f"From: {url}")
        print(
            soup.find_all("div", attrs={"class": None, "id": None})[0]
            .get_text()
            .strip()
        )
        break
    except:
        continue
else:
    print("No results :(")
