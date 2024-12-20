Sure! Here's the list of the required pip packages:

1. **flask**  
   - The web framework used to create the API.
   ```bash
   pip install flask
   ```

2. **flask-cors**  
   - A Flask extension to handle CORS (Cross-Origin Resource Sharing) issues.
   ```bash
   pip install flask-cors
   ```

3. **ollama**  
   - The Python client for interacting with the Ollama AI model.
   ```bash
   pip install ollama
   ```

These are the primary packages you'll need for the backend server. To install all of them at once, you can create a `requirements.txt` file with the following content:

```
flask
flask-cors
ollama
```

Then, run:

before that, create an environment variable (please run):
```bash
python -m venv venv
```

then build this backend structure:
```
backend/
├── venv/
└── main.py
```

run the backend

```bash
python main.py
```
