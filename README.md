### **Gemma AI Chat API Documentation**

#### **Overview**
This backend API provides an interface to interact with the "Gemma" model using Flask. It allows you to send messages to the model via a POST request and receive responses. The API uses CORS to handle requests from different origins and includes detailed logging for debugging and monitoring purposes.

---


## Codebase Structure
```
flutter_project/
├── frontend
└── backend
```

## FRONTEND

### **Installation Requirements**

To run the frontend part of the project are also required:

1. **flutter**
   open-source framework based on dart
2. **pubspec.yaml**
   Dependencies are the list of packages that you can immediately download throgh running: **flutter pub get**
```
   dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.4.0  # For database operations
  path_provider: ^2.0.0  # To find the correct path for the database
  http: ^0.13.3  # For chatbot API calls (if needed)
  auto_route: ^7.8.4
  dio: ^5.4.1
  equatable: ^2.0.5
  flutter_bloc: ^8.1.4
  get_it: ^7.6.7
  injectable: ^2.3.2
```
   Dev dependencies are the environment and running package for the whole creation of flutter environment
```
dev_dependencies:
  auto_route_generator: ^7.3.2
  build_runner: ^2.4.8
  injectable_generator: ^2.4.1
  flutter_test:
    sdk: flutter
```

Create a new flutter project and based it off here and so on:
```
lib/
├── chat_assistant.dart
└──home_page.dart
└── main.dart
└── note_editor.dart
```

---



## BACKEND



#### **Installation Requirements**

To run this backend API, the following Python packages are required:

1. **flask**  
   A web framework to create the API server.
   
   ```bash
   pip install flask
   ```

2. **flask-cors**  
   A package to handle Cross-Origin Resource Sharing (CORS) for allowing requests from different domains.
   
   ```bash
   pip install flask-cors
   ```

3. **ollama**  
   The Python client for interacting with the Ollama AI model.

   ```bash
   pip install ollama
   ```

---

#### **Setup**

1. Clone or download the project.
2. Create and activate a virtual environment (optional but recommended).
   ```bash
   python -m venv venv
   source venv/bin/activate   # On Linux/MacOS
   venv\Scripts\activate      # On Windows
   ```

3. Install the required dependencies.
   ```bash
   pip install -r requirements.txt
   ```

4. Run the Flask app.
   ```bash
   python main.py
   ```

   The server will be accessible at `http://0.0.0.0:11434` (or `http://localhost:11434`).

---

#### **API Endpoints**

- **POST /api/chat**

  This endpoint receives a user message, processes it with the Gemma model, and returns a response.

  **Request:**

  - Method: `POST`
  - URL: `http://<server_ip>:11434/api/chat`
  - Body: The body should be a JSON object containing a `messages` array with an object that includes the user's message.

  **Example Request Body:**

  ```json
  {
    "messages": [
      {
        "role": "user",
        "content": "Hello, Gemma!"
      }
    ]
  }
  ```

  **Response:**

  The response will contain the AI's message in the `content` field under the `message` object.

  **Example Response Body:**

  ```json
  {
    "message": {
      "content": "I am ready to begin the game. Please provide me with the details of the turn, such as the actions you would like me to take. I will respond with the results of your turn."
    }
  }
  ```

  If an error occurs, a response with an error message will be returned:

  **Error Response Example:**

  ```json
  {
    "error": "No message content provided"
  }
  ```

  **HTTP Status Codes:**
  - `200 OK`: Successful request
  - `400 Bad Request`: No content provided in the user message
  - `500 Internal Server Error`: Unexpected server error

---

#### **Code Explanation**

- **Logging:**

  The code uses Python's built-in `logging` module to provide detailed logs of incoming requests and responses. This is useful for debugging and understanding the flow of data. 

  - **Log Levels**: The logging is set to the `DEBUG` level, meaning all log messages (debug, info, warning, error) will be captured.
  - **Logs** include incoming requests, user messages, responses from Gemma, and any errors.

- **CORS Handling:**

  The `flask-cors` library is used to enable Cross-Origin Resource Sharing (CORS) for all domains. This allows the API to accept requests from different origins (e.g., your frontend app or Postman).

  ```python
  CORS(app)
  ```

- **Flask Routes:**

  The app defines one route, `/api/chat`, which listens for `POST` requests. This route expects a JSON body containing user messages, processes them using the Ollama AI model (`gemma`), and returns a response.

  ```python
  @app.route('/api/chat', methods=['POST'])
  def chat_with_gemma():
  ```

  - **Request Handling**: The server reads the incoming JSON request and extracts the user message.
  - **Message Handling**: The user message is then sent to the Ollama model via the `ollama.chat()` function, which streams the response.
  - **Error Handling**: Any errors that occur during the request handling are caught and logged, and a JSON error response is returned with a status code of 500.

- **Starting the Server:**

  The Flask app is started with `app.run(debug=True, host='0.0.0.0', port=11434)` on port `11434`. The app runs in debug mode to provide detailed logs during development.

  ```python
  if __name__ == "__main__":
      logger.info("Starting backend server...")
      app.run(debug=True, host='0.0.0.0', port=11434)
  ```

---

#### **Example Usage with Postman**

1. Set the request type to `POST`.
2. Enter the API URL: `http://<your_server_ip>:11434/api/chat`
3. In the `Body` tab, select `raw` and `JSON`.
4. Paste the following JSON body:

   ```json
   {
     "messages": [
       {
         "role": "user",
         "content": "Hello, Gemma!"
       }
     ]
   }
   ```

5. Send the request, and you should receive the AI's response in the format specified above.

---

#### **Debugging Tips**

1. **Check Logs**: If you encounter any issues, check the terminal or console where the Flask app is running. It will show detailed logs of requests, responses, and errors.

2. **Verify CORS**: If you're sending requests from a different domain (e.g., a frontend app), make sure CORS is enabled properly. You can restrict allowed domains by configuring `CORS(app, origins=["http://yourfrontenddomain.com"])` if needed.

3. **Port Availability**: Ensure that port `11434` is not blocked by a firewall or already in use by another application.

---

This API provides a simple yet powerful backend to integrate with the Gemma model and interact with it through messages. It supports JSON communication and can be extended or customized based on specific needs.

**Don't forget to follow guidelines that we shared**
