import random
names = ["Jacob", "Jino", "Joseph", "Lia", "John", "Paul"]

for name in names.copy():
    print('\x1B[H\x1B[2J\x1B[3J', end='')
    print(f"{name}: get ready for Christmas!!", end='')
    input() 
    choice = random.choice(names)
    print(f"{choice} is your secret Santa recipient!")
    input()
    names.remove(choice)
    print('\x1B[H\x1B[2J\x1B[3J')

