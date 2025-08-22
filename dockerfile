# Use official Python image
FROM python:3.12-slim

# Set working directory in container
WORKDIR /app

# Copy requirements.txt and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your Python script(s)
COPY my_app.py .

# Expose the port your Flask app uses
EXPOSE 5000

# Run your Python script
CMD ["python", "my_app.py"]
