from app import app

def test_homepage():
    client = app.test_client()
    response = client.get("/notes")
    assert response.status_code == 200
