from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    return "Hello from Flask, on Vishy's machine!\n"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=161)