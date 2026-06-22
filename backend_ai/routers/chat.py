from fastapi import APIRouter, HTTPException
from typing import List
from backend_ai.config import GEMINI_API_KEY, MONGO_URI
from backend_ai.models.chat import MessageRequest, ChatMessageModel, ChatSessionModel
from pymongo import MongoClient
import google.generativeai as genai
from datetime import datetime
import uuid

router = APIRouter(prefix="/api/chat", tags=["chat"])

# Connect to MongoDB
client = MongoClient(MONGO_URI)
db = client.get_default_database()
if db is None:
    db = client['test']
chat_sessions_col = db['chatsessions']

# Initialize Gemini GenAI
gemini_available = False
if GEMINI_API_KEY:
    try:
        genai.configure(api_key=GEMINI_API_KEY)
        gemini_available = True
        print("🤖 Gemini GenAI successfully initialized in FastAPI backend.")
    except Exception as e:
        print(f"⚠️ Failed to configure Gemini API: {e}")
else:
    print("⚠️ GEMINI_API_KEY environment variable is empty. FastAPI chatbot will run in Mock Mode.")

SYSTEM_INSTRUCTION = """You are Saathi, a specialized pet training and pet care assistant. You ONLY answer questions related to:

PET TRAINING:
- Dog training techniques and commands
- Cat training methods
- Bird training and behavior
- Puppy and kitten training
- Housebreaking and potty training
- Obedience training
- Behavior modification
- Training schedules and routines

PET CARE:
- Pet health and wellness
- Pet nutrition and diet
- Pet exercise and enrichment
- Pet grooming and hygiene
- Pet socialization
- Pet safety and first aid
- Pet behavior understanding

IMPORTANT RULES:
1. ONLY answer questions about pets, pet training, and pet care
2. If asked about anything else (coding, math, history, etc.), politely redirect to pet topics
3. Keep responses friendly, practical, and actionable
4. Use emojis occasionally to make responses engaging
5. Always provide specific, helpful advice for pet owners
6. If unsure about a pet topic, suggest consulting a veterinarian or professional trainer

Example responses for off-topic questions:
- "I'm specialized in pet training and care! 🐕🐱 I'd be happy to help with any questions about your furry friends instead."
- "That's outside my expertise! I focus on helping pet owners with training and care. What pet-related questions do you have?"
- "I'm your pet training assistant! 🐾 Let's talk about your pets instead. How can I help with training or care?"
"""

def get_mock_response(message: str) -> str:
    lower_message = message.lower()
    if 'hello' in lower_message or 'hi' in lower_message:
        return 'Hello! 👋 I\'m Saathi, your pet training assistant. How can I help you with your furry friend today?'
    elif 'dog' in lower_message and 'train' in lower_message:
        return 'Great question! 🐕 For dog training, start with basic commands like "sit" and "stay". Use positive reinforcement with treats and praise. Keep sessions short (5-10 minutes) and consistent. What specific behavior are you working on?'
    elif 'cat' in lower_message and 'train' in lower_message:
        return 'Cats can be trained too! 😸 Use clicker training and treats. Start with simple commands like "come" or "sit". Be patient - cats learn at their own pace. What would you like to teach your cat?'
    elif 'bark' in lower_message or 'noise' in lower_message:
        return 'Excessive barking can be challenging! 🐕 Try identifying the trigger (boredom, attention, fear). Provide mental stimulation, exercise, and teach the "quiet" command. Would you like specific techniques for your situation?'
    elif 'litter' in lower_message or 'potty' in lower_message:
        return 'Litter box issues are common! 🐱 Ensure the box is clean, in a quiet location, and the right size. Try different litter types if needed. How long has this been happening?'
    elif 'aggressive' in lower_message or 'bite' in lower_message:
        return 'Aggression needs careful handling! 🚨 First, identify the trigger. Never punish - use positive reinforcement. Consider consulting a professional trainer. What type of aggression are you seeing?'
    elif 'puppy' in lower_message or 'young' in lower_message:
        return 'Puppies are like sponges! 🐾 Start training early with socialization and basic commands. Use crate training for housebreaking. Be consistent and patient. How old is your puppy?'
    elif 'exercise' in lower_message or 'energy' in lower_message:
        return 'High energy pets need outlets! ⚡ Provide daily exercise, mental stimulation, and structured playtime. Consider puzzle toys and training sessions. What type of pet do you have?'
    elif 'food' in lower_message or 'diet' in lower_message:
        return 'Nutrition is key! 🍽️ Feed high-quality food appropriate for your pet\'s age and size. Use treats sparingly for training. Always provide fresh water. Any specific dietary concerns?'
    elif 'social' in lower_message or 'other pets' in lower_message:
        return 'Socialization is important! 🤝 Introduce pets gradually in neutral territory. Use positive reinforcement and never force interactions. How are your pets currently getting along?'
    elif 'vet' in lower_message or 'health' in lower_message:
        return 'Health comes first! 🏥 Regular vet checkups are essential. Watch for changes in behavior, appetite, or energy. Don\'t hesitate to consult your vet for concerns. Any specific health issues?'
    elif 'thank' in lower_message or 'thanks' in lower_message:
        return 'You\'re welcome! 😊 I\'m here to help with all your pet training questions. Feel free to ask anything anytime!'
    elif 'bye' in lower_message or 'goodbye' in lower_message:
        return 'Goodbye! 👋 Feel free to come back anytime for more pet training advice. Good luck with your furry friend!'
    else:
        return 'That\'s an interesting question! 🤔 I\'d love to help you with pet training. Could you provide more details about your specific situation or what you\'d like to achieve? I can help with training techniques, behavior issues, pet care, and more!'

def is_off_topic_response(response: str, message: str) -> bool:
    lower_response = response.lower()
    lower_message = message.lower()
    
    off_topic_keywords = [
        'python', 'javascript', 'java', 'coding', 'programming', 'code',
        'algorithm', 'function', 'variable', 'loop', 'database', 'api',
        'mathematics', 'algebra', 'calculus', 'geometry', 'statistics',
        'history', 'politics', 'economics', 'geography', 'science',
        'chemistry', 'physics', 'biology', 'astronomy', 'geology',
        'cooking', 'recipes', 'food', 'restaurant', 'cuisine',
        'travel', 'vacation', 'tourism', 'hotel', 'flight',
        'business', 'marketing', 'finance', 'investment', 'stock',
        'sports', 'football', 'basketball', 'tennis', 'golf',
        'music', 'art', 'literature', 'poetry', 'novel',
        'technology', 'computer', 'software', 'hardware', 'internet'
    ]
    
    pet_keywords = [
        'pet', 'dog', 'cat', 'bird', 'puppy', 'kitten', 'animal',
        'train', 'training', 'behavior', 'care', 'health', 'food',
        'exercise', 'groom', 'vet', 'veterinarian', 'adopt', 'adoption',
        '🐕', '🐱', '🐦', '🐾', '🏥', '🍽️', '⚡'
    ]
    
    is_pet_related_user = any(k in lower_message for k in pet_keywords)
    if is_pet_related_user:
        return False
        
    for keyword in off_topic_keywords:
        if keyword in lower_response:
            return True
            
    is_pet_related_resp = any(k in lower_response for k in pet_keywords)
    if not is_pet_related_resp:
        return True
        
    return False

@router.post("/message")
def post_message(req: MessageRequest):
    user_message_str = req.message.strip()
    if not user_message_str:
        raise HTTPException(status_code=400, detail="Message content cannot be empty.")

    user_msg_model = ChatMessageModel(
        id=str(uuid.uuid4()),
        content=user_message_str,
        type="user",
        timestamp=datetime.utcnow()
    )

    # 1. Fetch response (Gemini or Mock)
    bot_response_text = ""
    if gemini_available:
        try:
            model = genai.GenerativeModel(
                model_name='gemini-1.5-flash',
                system_instruction=SYSTEM_INSTRUCTION
            )
            # Build history list in Gemini schema
            contents = []
            
            # Select history context
            recent_history = req.history[-10:] if req.history else []
            for h in recent_history:
                role = "user" if h.type == "user" else "model"
                contents.append({
                    "role": role,
                    "parts": [{"text": h.content}]
                })
            
            # Add current message
            contents.append({
                "role": "user",
                "parts": [{"text": user_message_str}]
            })
            
            # Generate content
            response = model.generate_content(
                contents=contents,
                generation_config={
                    'temperature': 0.7,
                    'max_output_tokens': 500,
                }
            )
            
            if response and response.text:
                bot_response_text = response.text
                # Safe fallback if Gemini goes off topic despite instruction
                if is_off_topic_response(bot_response_text, user_message_str):
                    bot_response_text = 'I\'m specialized in pet training and care! 🐕🐱 I\'d be happy to help with any questions about your furry friends instead. What pet-related questions do you have?'
            else:
                bot_response_text = "I couldn't formulate a response. Please try again."
        except Exception as e:
            print(f"❌ Gemini Generation error: {e}")
            bot_response_text = get_mock_response(user_message_str)
    else:
        # Simulate short network latency for mock responses
        bot_response_text = get_mock_response(user_message_str)

    bot_msg_model = ChatMessageModel(
        id=str(uuid.uuid4()),
        content=bot_response_text,
        type="bot",
        timestamp=datetime.utcnow()
    )

    # 2. Persist to MongoDB
    try:
        chat_sessions_col.update_one(
            {"user_id": req.user_id},
            {
                "$push": {
                    "messages": {
                        "$each": [user_msg_model.model_dump(), bot_msg_model.model_dump()]
                    }
                },
                "$set": {"updated_at": datetime.utcnow()}
            },
            upsert=True
        )
    except Exception as e:
        print(f"⚠️ MongoDB Chat persistence error: {e}")

    return {
        "user_message": user_msg_model,
        "bot_message": bot_msg_model
    }

@router.get("/history/{user_id}", response_model=List[ChatMessageModel])
def get_chat_history(user_id: str):
    try:
        session = chat_sessions_col.find_one({"user_id": user_id})
        if session:
            # Parse messages into list of ChatMessageModel
            return session.get("messages", [])
        return []
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database retrieval error: {str(e)}")
