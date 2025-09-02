#!/bin/env python3
from bs4 import BeautifulSoup
import urllib.request
from sys import argv

song, singer = "".join(argv[1:]).strip().split("by")
singer = "".join([i.lower() for i in singer if not i.isspace()])
song = "".join([i.lower() for i in song if not i.isspace()])
url = "https://www.azlyrics.com/lyrics/" + singer + "/" + song + ".html"

raw = urllib.request.urlopen(url)
data = raw.read()

soup = BeautifulSoup(data, "html.parser")
print(soup.find_all("div", attrs={"class": None, "id": None})[0].get_text().strip())
