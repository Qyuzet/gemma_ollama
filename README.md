# Gemma AI Assistant - Flutter Chat Application

## Overview

Gemma AI Assistant is a Flutter-based mobile application that provides a real-time conversational interface with an AI model using the Ollama backend. The app features a streaming chat experience, allowing users to interact with an AI assistant seamlessly.

## Features

- Real-time chat interface
- Word-by-word AI response streaming
- Local AI model integration
- Error handling and user-friendly UI
- Supports Ollama backend

## Prerequisites

Before you begin, ensure you have the following installed:

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio or VS Code
- Ollama (local AI model server)
- Llama3 or other compatible AI model

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/Qyuzet/gemma_ollama.git
cd gemma_ollama
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Set Up Ollama

- Install Ollama from [ollama.ai](https://ollama.ai)
- Pull the Llama3 model:
  ```bash
  ollama pull llama3
  ```
- Start the Ollama server:
  ```bash
  ollama serve
  ```

### 4. Configure Backend URL

In `chat_assistant.dart`, verify the backend URL:
```dart
Uri.parse('http://127.0.0.1:11434/api/chat')
```
Adjust if your Ollama server runs on a different host/port.

## Running the App

### Android
```bash
flutter run
```

### iOS
```bash
flutter run -d ios
```

### Web
```bash
flutter create .  # Add web support
flutter run -d chrome
```

## Customization

### Changing AI Model
Modify the `model` parameter in `sendMessage()`:
```dart
'model': 'your-preferred-model:version'
```

### Adjusting Streaming Speed
In `_streamResponseWords()`, change the timer duration:
```dart
Timer.periodic(Duration(milliseconds: 50), ...)
```

## Troubleshooting

- Ensure Ollama is running before launching the app
- Check network connectivity
- Verify model availability
- Confirm Flutter and Dart versions are up to date

## Dependencies

- Flutter
- http package
- Ollama
- Llama3 (or alternative AI model)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Contact

Project Link: [https://github.com/Qyuzet/gemma_ollama](https://github.com/Qyuzet/gemma_ollama)

## Acknowledgments

- Flutter Team
- Ollama
- AI Model Creators
