import logging
import ollama
from flask import Flask, request, jsonify
from flask_cors import CORS  # Import CORS here
import time

# Setup logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

# Initialize Flask app
app = Flask(__name__)

# Enable CORS for all domains (you can restrict this later if needed)
CORS(app)

@app.route('/api/chat', methods=['POST'])
def chat_with_gemma():
    try:
        # Log the incoming request
        logger.info("Received POST request on /api/chat")
        data = request.get_json()
        logger.debug(f"Request body: {data}")

        user_message = data.get('messages', [{}])[0].get('content', '')
        if not user_message:
            logger.warning("No user message found in request")
            return jsonify({'error': 'No message content provided'}), 400

        conversation = [{'role': 'user', 'content': user_message}]
        logger.info("User message received: %s", user_message)

        # Processing the chat with Gemma
        logger.info("Sending message to Gemma model...")
        response_stream = ollama.chat(
            model='gemma',
            messages=conversation,
            stream=True
        )

        full_response = ""
        for chunk in response_stream:
            if 'message' in chunk:
                content = chunk['message']['content']
                logger.debug(f"Received chunk: {content}")
                full_response += content

        # Log the final response before sending
        logger.info("Gemma's response: %s", full_response)

        # Send response back to the frontend
        return jsonify({'message': {'content': full_response}})

    except Exception as e:
        logger.error("Error during chat interaction: %s", str(e))
        return jsonify({'error': str(e)}), 500

if __name__ == "__main__":
    logger.info("Starting backend server...")
    app.run(debug=True, host='0.0.0.0', port=11434)
