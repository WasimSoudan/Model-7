from flask import Flask, request, render_template, jsonify
import torch
from transformers import MarianMTModel, MarianTokenizer
import os
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

class TranslationModel:
    def __init__(self):
        self.model = None
        self.tokenizer = None
        self.model_name = "Helsinki-NLP/opus-mt-en-fr"  # English to French
        self.load_model()
    
    def load_model(self):
        """Load the pre-trained translation model"""
        try:
            logger.info("Loading translation model...")
            self.tokenizer = MarianTokenizer.from_pretrained(self.model_name)
            self.model = MarianMTModel.from_pretrained(self.model_name)
            logger.info("Model loaded successfully!")
        except Exception as e:
            logger.error(f"Error loading model: {str(e)}")
            raise e
    
    def translate(self, text, max_length=512):
        """Translate English text to French"""
        try:
            if not text.strip():
                return "Please enter some text to translate."
            
            # Tokenize input text
            inputs = self.tokenizer(text, return_tensors="pt", padding=True, truncation=True, max_length=max_length)
            
            # Generate translation
            with torch.no_grad():
                outputs = self.model.generate(**inputs, max_length=max_length, num_beams=4, early_stopping=True)
            
            # Decode the translation
            translation = self.tokenizer.decode(outputs[0], skip_special_tokens=True)
            return translation
        
        except Exception as e:
            logger.error(f"Translation error: {str(e)}")
            return f"Error during translation: {str(e)}"

# Initialize the model
translator = TranslationModel()

@app.route('/')
def home():
    """Render the main page"""
    return render_template('index.html')

@app.route('/translate', methods=['POST'])
def translate_text():
    """Handle translation requests"""
    try:
        data = request.get_json()
        text = data.get('text', '')
        
        if not text:
            return jsonify({'error': 'No text provided'}), 400
        
        # Perform translation
        translation = translator.translate(text)
        
        return jsonify({
            'original_text': text,
            'translated_text': translation,
            'source_language': 'English',
            'target_language': 'French'
        })
    
    except Exception as e:
        logger.error(f"API error: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/health')
def health_check():
    """Health check endpoint"""
    return jsonify({'status': 'healthy', 'model_loaded': translator.model is not None})

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)