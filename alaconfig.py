#! /usr/local/bin/python3

import toml 
import os
import sys

args = sys.argv[1:]

all_themes = [f for f in os.listdir('/Users/user/.config/alacritty/themes/')]

def usage():
    print("""
alaconfig <option> <param> <value>
    
    option : set | get
    param : font | theme | opacity | fontsize

    """)
    sys.exit()

try:
    with open("/Users/user/.config/alacritty/alacritty.toml") as f:
        data = (toml.load((f)))
except FileNotFoundError:
    raise FileNotFoundError("Do you have an alacritty.toml file?")    

if len(args) <= 1:
    usage()

match args[0]:
    case "set":
        if len(args) < 3:
            usage()

        match args[1]:
            case "opacity":
                data['window']['opacity'] = float(args[2]) 
            case "font":
                data['font']['normal']['family'] = ' '.join(args[2:]).title()
            case "fontsize":
                data['font']['size'] = int(args[2])
            case "theme":
                theme = ' '.join(args[2:]).replace(' ', '-') + '.toml'
                if theme in all_themes:
                    data['import'][0] = '/'.join(data['import'][0].split('/')[:-1]) + '/' + theme 
                else:
                    print(f"No such theme [{theme}]")
            case "blur":
                data['window']['blur'] = True if args[2] in ['yes', 'true', '1'] else False
            case _:
                print("Huh?")
    case "get":
        if len(args) < 2:
            usage()

        match args[1]:
            case "opacity":
                print(data['window']['opacity'])
            case "font":
                print(data['font']['normal']['family'])
            case "fontsize":
                print(data['font']['size'])
            case "theme":
                print(data['import'][0].split('/')[-1])
            case "blur":
                print(data['window']['blur'])
            case _:
                print("Huh?")

    case _:
        print("Huh?")

with open("/Users/user/.config/alacritty/alacritty.toml", 'w') as f:
    toml.dump(data, f)

