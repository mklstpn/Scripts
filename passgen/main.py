from flask import Flask
from flask import render_template, request
import string
import random

app = Flask(__name__)

@app.route('/', methods = ['POST', 'GET'])
def index():
    
    letters = ('$#@!%', string.ascii_lowercase, string.ascii_uppercase, string.digits)

    def generator(password):
        for letter in letters:
            password.append(random.choice(letter))
        return password    

    def passgen(length):
        length = int(length)
        password = []
        for _ in range(int(round(length / 4))):
            generator(password)
        if length%2 != 0:
            password.pop()
        random.shuffle(password)
        result = '\n' + ''.join(password)
        return result

    if request.method == 'POST':
        length = request.form.getlist('length')[0]
        if not length.isdigit():
            return render_template('index.html', result='word')
        elif int(length) < 6:
            return render_template('index.html', result='short')
        elif int(length) > 42:
            return render_template('index.html', result='long')
        else:
            return render_template('index.html', result=passgen(length))
    else:
        return render_template('index.html')

