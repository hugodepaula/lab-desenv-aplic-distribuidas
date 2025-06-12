from flask import request, Flask
import json

app2 = Flask(__name__)


@app2.route('/')
def hello_world():
    return '\n<h1>Requisição tratada pelo Host 2</h1>\n'


if __name__ == '__main__':
   app2.run(debug=True, host='0.0.0.0')
