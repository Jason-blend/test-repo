from flask import Flask, request, jsonify
import sqlite3

app = Flask(__name__)
DB_NAME = "notes.db"

def init_db():
    conn = sqlite3.connect(DB_NAME)
    cursor = conn.cursor()
    cursor.execute("CREATE TABLE IF NOT EXISTS notes (id INTEGER PRIMARY KEY, text TEXT)")
    conn.commit()
    conn.close()

@app.route("/notes", methods=["GET"])
def get_notes():
    conn = sqlite3.connect(DB_NAME)
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM notes")
    rows = cursor.fetchall()
    conn.close()
    return jsonify(rows)

@app.route("/notes", methods=["POST"])
def add_note():
    data = request.get_json()
    conn = sqlite3.connect(DB_NAME)
    cursor = conn.cursor()
    cursor.execute("INSERT INTO notes (text) VALUES (?)", (data["text"],))
    conn.commit()
    conn.close()
    return jsonify({"message": "Note added"}), 201

@app.route("/notes/<int:note_id>", methods=["DELETE"])
def delete_note(note_id):
    conn = sqlite3.connect(DB_NAME)
    cursor = conn.cursor()
    cursor.execute("DELETE FROM notes WHERE id=?", (note_id,))
    conn.commit()
    conn.close()
    return jsonify({"message": "Note deleted"})

if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=5000)
