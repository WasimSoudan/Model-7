# Machine Translation Flask App

A web application that translates English text to French using a pre-trained Hugging Face transformer model, deployed with Flask and Docker.

## Features

- 🌐 English to French translation
- 🎨 Modern, responsive web interface
- 🐳 Dockerized deployment
- 🚀 Ready for cloud deployment
- ✅ Health check endpoints
- 📱 Mobile-friendly design

## Project Structure

```
ml-translation-app/
│
├── app.py                 # Main Flask application
├── templates/
│   └── index.html        # Web interface
├── static/
│   └── style.css         # Styling
├── requirements.txt      # Python dependencies
├── Dockerfile           # Docker configuration
└── README.md           # This file
```

## Local Development

### Prerequisites
- Python 3.9+
- pip

### Setup

1. **Clone/Download the project:**
   ```bash
   cd ml-translation-app
   ```

2. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Run the application:**
   ```bash
   python app.py
   ```

4. **Open your browser:**
   Navigate to `http://localhost:5000`

## Docker Deployment

### Build and Run with Docker

1. **Build the Docker image:**
   ```bash
   docker build -t ml-translation-app .
   ```

2. **Run the container:**
   ```bash
   docker run -p 5000:5000 ml-translation-app
   ```

3. **Access the application:**
   Open `http://localhost:5000` in your browser

## Cloud Deployment Options

### Option 1: Render.com
1. Connect your GitHub repository to Render
2. Create a new Web Service
3. Use Docker deployment
4. Set environment variables if needed

### Option 2: Railway.app
1. Connect your GitHub repository
2. Deploy with automatic Docker detection
3. Set PORT environment variable to 5000

### Option 3: Fly.io
1. Install Fly CLI
2. Run `flyctl launch` in project directory
3. Follow the deployment prompts

### Option 4: Hugging Face Spaces
1. Create a new Space with Docker SDK
2. Upload your files
3. Ensure your Dockerfile is properly configured

## API Endpoints

- `GET /` - Main web interface
- `POST /translate` - Translation API
  - Body: `{"text": "Hello world"}`
  - Response: `{"translated_text": "Bonjour le monde", ...}`
- `GET /health` - Health check

## Model Information

- **Model:** Helsinki-NLP/opus-mt-en-fr
- **Task:** English to French translation
- **Framework:** Hugging Face Transformers
- **Architecture:** MarianMT

## Dependencies

- Flask - Web framework
- PyTorch - ML framework
- Transformers - Pre-trained models
- Gunicorn - Production server

## Performance Notes

- First request may be slower due to model loading
- Consider using model caching for production
- Adjust worker count based on available resources

## Troubleshooting

### Common Issues:

1. **Out of Memory:**
   - Reduce model size or use CPU-only version
   - Increase container memory limits

2. **Slow Loading:**
   - Model downloads on first run
   - Consider pre-downloading models in Docker build

3. **Port Issues:**
   - Ensure PORT environment variable is set correctly
   - Check if port 5000 is available

## License

This project is for educational purposes.