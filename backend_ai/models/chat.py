from pydantic import BaseModel, Field
from datetime import datetime
from typing import List, Optional

class ChatMessageModel(BaseModel):
    id: str
    content: str
    type: str  # 'user', 'bot', 'system'
    timestamp: datetime = Field(default_factory=datetime.utcnow)

class ChatSessionModel(BaseModel):
    user_id: str
    messages: List[ChatMessageModel] = []
    updated_at: datetime = Field(default_factory=datetime.utcnow)

class MessageRequest(BaseModel):
    user_id: str
    message: str
    history: List[ChatMessageModel] = []
