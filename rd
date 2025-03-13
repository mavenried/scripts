#! /bin/env python3
import pygame as pg
import sys
import os

pg.init()
screen = pg.display.set_mode((1920, 1080), pg.FULLSCREEN)
pg.display.set_caption("Reader")
icon = pg.image.load("/home/maverikio/Pictures/GameIcons/Reader.png")

pg.display.set_icon(icon)
MAXLEN = 95


def init(file):
    lines = []
    line_labels = []

    font = pg.font.SysFont("JetbrainsMono Nerd Font", 32)
    with open(file) as f:
        rawlines = list(f)

    for line in rawlines:
        if (len(line)) > MAXLEN:
            new_lines = [line]
            while len(new_lines[-1]) > MAXLEN:
                i = MAXLEN
                l = new_lines[-1]
                while l[i] != " ":
                    i -= 1
                new_lines.pop()
                new_lines.append(l[:i])
                new_lines.append(l[i + 1 :])
            lines.extend(new_lines)
        else:
            lines.append(line)

    cleaned = []
    repeated = False
    for line in lines:
        if line == "\n" and not repeated:
            cleaned.append(line)
            repeated = True
        elif line != "\n":
            cleaned.append(line)
            repeated = False
    for line in cleaned:
        line_labels.append(font.render(line.replace("\n", " "), True, "#ebdbb2"))

    page = 0
    maxpages = len(cleaned) // 26

    while True:
        for event in pg.event.get():
            if event.type == pg.QUIT:
                pg.quit()
                sys.exit()
            if event.type == pg.KEYDOWN:
                if event.key in [pg.K_SPACE, pg.K_UP, pg.K_RIGHT, pg.K_l]:
                    page = min((page + 1, maxpages))
                elif event.key in [pg.K_LSHIFT, pg.K_DOWN, pg.K_LEFT, pg.K_h]:
                    page = max((page - 1, 0))
                elif event.key == pg.K_n:
                    return
                elif event.key == pg.K_ESCAPE:
                    pg.quit()
                    sys.exit()

        screen.fill("#000000")
        for i, surf in enumerate(line_labels[page * 26 : (page + 1) * 26]):
            screen.blit(surf, (20, 20 + 40 * i))
        pg.display.flip()


def update(chno):
    with open("/home/maverikio/.bookmarks/shadowslave", "w") as f:
        f.write(str(chno))


if __name__ == "__main__":
    base = os.getcwd()
    if len(sys.argv) == 2:
        chno = int(sys.argv[-1])
        while True:
            init(base + f"/{chno:0>5}.txt")
            chno += 1
            update(chno)
    else:
        with open("/home/maverikio/.bookmarks/shadowslave") as f:
            chno = int(f.read().strip())
        while True:
            init(os.getcwd() + f"/{chno:0>5}.txt")
            chno += 1
            update(chno)
