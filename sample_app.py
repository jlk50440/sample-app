from flask import Flask
from flask import render_template
from wsgiref.simple_server import make_server

sample = Flask(__name__)

@sample.route("/")
def main():
    return render_template("index.html")

if __name__ == "__main__":
    httpd = make_server("0.0.0.0", 5050, sample)
    httpd.serve_forever()