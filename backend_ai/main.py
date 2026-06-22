from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from backend_ai.routers import chat, matchmaker
import uvicorn
import os

app = FastAPI(
    title="Saathi AI Backend",
    description="Python FastAPI service handling AI chatbot and matchmaking algorithms for Saathi Pet App.",
    version="1.0.0"
)

# CORS middleware configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # In production, restrict this to your mobile app client calls
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(chat.router)
app.include_router(matchmaker.router)

@app.get("/")
def read_root():
    return {
        "status": "healthy",
        "service": "Saathi AI Microservice",
        "endpoints": {
            "chat": "/api/chat/message",
            "chat_history": "/api/chat/history/{user_id}",
            "matchmaker": "/api/matchmaker/score"
        }
    }

if __name__ == "__main__":
    import sys
    current_dir = os.path.dirname(os.path.abspath(__file__))
    parent_dir = os.path.dirname(current_dir)
    if parent_dir not in sys.path:
        sys.path.insert(0, parent_dir)
        
    port = int(os.getenv("PORT", 8000))
    # Run uvicorn server with the correct module path
    uvicorn.run("backend_ai.main:app", host="0.0.0.0", port=port, reload=True)
