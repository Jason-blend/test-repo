from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello from my mock website! This is a DevSecOps test."

@app.route("/health")
def health():
    return {"status": "ok"}, 200

if __name__ == "__main__":
    # Bind to all interfaces so Jenkins can access it
    app.run(host="0.0.0.0", port=5000)
