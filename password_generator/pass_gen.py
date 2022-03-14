import string
import random

characters = list(string.ascii_lowercase + string.digits)


def passgen():
    length = input('Enter password length: ')

    if not length.isdigit():
        print('Use digits only')
        passgen()
    else:
        password = []
        for _ in range(int(length)):
            password.append(random.choice(characters))
        random.shuffle(password)
        print('\n' + ''.join(password))


passgen()
