import os
from dotenv import load_dotenv

# Load variables from .env file
load_dotenv()

MONGO_URI = os.getenv("MONGO_URI", "mongodb+srv://aryanpshah1:Aryandiya@cluster0.dyju0uh.mongodb.net/test?retryWrites=true&w=majority&appName=Cluster0")
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY", "")
PORT = int(os.getenv("PORT", "8000"))
