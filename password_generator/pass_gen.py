import string
import random

characters = list(string.ascii_lowercase + string.digits)


def passgen():
    lenght = input('Enter password lenght: ')

    if not lenght.isdigit():
        print('Use digits only')
        passgen()
    else:
        password = []
        for _ in range(int(lenght)):
            password.append(random.choice(characters))
        random.shuffle(password)
        print('\n' + ''.join(password))


passgen()
