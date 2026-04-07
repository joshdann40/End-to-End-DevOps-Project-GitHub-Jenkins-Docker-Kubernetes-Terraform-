from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def home():
    return jsonify({"message": "DevOps demo app is running"})


@app.get("/healthz")
def healthz():
    return jsonify({"status": "ok"})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
