# Use Python 3.11 instead of 3.9 for better compatibility
FROM python:3.11-slim

# Set working directory in container
WORKDIR /app

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PORT=5000
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

# Install PyTorch CPU-only version first (much smaller and faster)
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu --timeout=1000

# Install other dependencies
RUN pip install --no-cache-dir Flask transformers sentencepiece protobuf --timeout=1000

# Install remaining packages
RUN pip install --no-cache-dir numpy pandas scikit-learn Werkzeug gunicorn --timeout=1000

# Copy the entire application
COPY . .

# Create model directory if it doesn't exist
RUN mkdir -p model

# Expose port
EXPOSE $PORT

# Health check
HEALTHCHECK --interval=30s --timeout=60s --start-period=120s --retries=3 \
    CMD curl -f http://localhost:$PORT/health || exit 1

# Run the application with gunicorn for production
CMD gunicorn --bind 0.0.0.0:$PORT --workers 1 --timeout 120 app:app