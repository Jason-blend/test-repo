# --- Step 1: Use an official Python image ---
FROM python:3.12-slim

# --- Step 2: Set working directory in the container ---
WORKDIR /app

# --- Step 3: Copy requirements file and install dependencies ---
COPY requirements.txt .
RUN pip install --upgrade pip setuptools
RUN pip install -r requirements.txt

# --- Step 4: Copy all project files into the container ---
COPY . .

# --- Step 5: Find the Python file that has Flask app ---
# This assumes only one Python file in repo contains 'Flask(__name__)', adjust if needed
RUN PY_FILE=$(grep -l "Flask(__name__)" *.py) && echo "Running $PY_FILE" > /dev/null

# --- Step 6: Expose Flask port ---
EXPOSE 5000

# --- Step 7: Set default command to run the Flask app ---
CMD PY_FILE=$(grep -l "Flask(__name__)" *.py) && python "$PY_FILE"
