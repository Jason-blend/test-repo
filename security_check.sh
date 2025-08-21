#!/bin/bash
set -e

echo "==== Running Python Script ===="
python3 hello-world.py || echo "Python script failed"

echo "==== Running Bandit SAST Scan ===="
pip install --user bandit
bandit -r . || echo "Bandit found issues"

echo "==== Running Safety Dependency Scan ===="
pip install --user safety
if [ -f requirements.txt ]; then
    safety check -r requirements.txt || echo "Safety found vulnerabilities"
else
    echo "No requirements.txt found"
fi

echo "==== Optional: Docker Image Scan ===="
if command -v trivy &> /dev/null; then
    trivy image python:3.12 || echo "Trivy found vulnerabilities"
else
    echo "Trivy not installed, skipping container scan"
fi

echo "==== Security Checks Completed ===="
