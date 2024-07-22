#! /usr/local/bin/python3
import os
import toml
import random

with open("/Users/user/.config/alacritty/alacritty.toml", 'r') as f:
    data = toml.load(f)

while True:
    print("""
Alacritty Configurator

    - (1) Font
    - (2) Theme
    - (3) Opacity
    - (4) Save & Quit

""")

    choice = input(":")

    match choice:
        case '1':
            fname = input("Enter the exact name of the font: ")
            data['font']['normal']['family'] = fname
        case '2':
            theme = input("Enter the name of the theme: ").replace(' ', '_')
            if theme == 'random':
                all_themes = [f for f in os.listdir('/Users/user/.config/alacritty/themes/')]
                theme = random.choice(all_themes).split(".")[0]
            data['import'][0] = '/'.join(data['import'][0].split('/')[:-1]) + '/' + theme + '.toml'
        
        case '3':
            opacity = float(input('Opacity in percentage: '))/100
            data['window']['opacity'] = opacity

        case '4':
            with open('/Users/user/.config/alacritty/alacritty.toml', 'w') as f:
                toml.dump(data, f)

            break

        case _:
            print('Invalid Option...')

    print()
