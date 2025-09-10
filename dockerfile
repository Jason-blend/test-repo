# --- Step 1: Use official lightweight Python image ---
FROM python:3.12-slim

# --- Step 2: Set working directory in the container ---
WORKDIR /app

# --- Step 3: Install dependencies ---
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip setuptools wheel \
    && pip install --no-cache-dir -r requirements.txt

# --- Step 4: Copy all project files ---
COPY . .

# --- Step 5: Expose Flask port ---
EXPOSE 5000

# --- Step 6: Run Flask app (assume entrypoint app.py) ---
CMD ["python", "app.py"]
