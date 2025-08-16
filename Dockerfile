# Use Python 3.11 slim
FROM python:3.11-slim

# Set working directory in container
WORKDIR /app

# Environment settings
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_TIMEOUT=1000
ENV PIP_RETRIES=10

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip first
RUN pip install --upgrade pip

# Copy requirements first (for better caching)
COPY requirements.txt .

# Install PyTorch CPU-only (smaller + faster)
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu --timeout=1000

# Install other dependencies
RUN pip install --no-cache-dir Flask transformers sentencepiece protobuf --timeout=1000

# Install remaining packages
RUN pip install --no-cache-dir numpy pandas scikit-learn Werkzeug gunicorn --timeout=1000

# Copy project files
COPY . .

# Ensure model directory exists
RUN mkdir -p model

# Expose Render-provided port
EXPOSE $PORT

# Run the application with Gunicorn
CMD gunicorn --bind 0.0.0.0:$PORT --workers 1 --timeout 120 app:app
