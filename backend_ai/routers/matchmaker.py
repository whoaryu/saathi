from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
from typing import List

router = APIRouter(prefix="/api/matchmaker", tags=["matchmaker"])

class UserPreference(BaseModel):
    activity_level: float  # 0.0 (low) to 1.0 (high)
    space_available: float  # 0.0 (apartment) to 1.0 (large yard)
    time_commitment: float  # 0.0 (busy) to 1.0 (flexible)

class PetAttribute(BaseModel):
    pet_id: str
    energy_level: float  # 0.0 (lazy) to 1.0 (active)
    space_needed: float   # 0.0 (small) to 1.0 (large yard)
    attention_needed: float # 0.0 (independent) to 1.0 (clingy)

@router.post("/score")
def calculate_matchmaker(user_pref: UserPreference, pet_attr: PetAttribute):
    try:
        # Construct vectors
        user_vector = np.array([[
            user_pref.activity_level,
            user_pref.space_available,
            user_pref.time_commitment
        ]])
        
        pet_vector = np.array([[
            pet_attr.energy_level,
            pet_attr.space_needed,
            pet_attr.attention_needed
        ]])
        
        # Calculate cosine similarity score
        similarity = cosine_similarity(user_vector, pet_vector)[0][0]
        
        # Ensure similarity is bounded [0.0, 1.0]
        score = max(0.0, min(1.0, float(similarity)))
        
        # Formulate reasoning text based on attributes comparison
        reasons = []
        
        # Activity level
        diff_activity = abs(user_pref.activity_level - pet_attr.energy_level)
        if diff_activity < 0.2:
            reasons.append("Your physical activity habits align perfectly with the pet's natural energy.")
        elif user_pref.activity_level > pet_attr.energy_level:
            reasons.append("This pet fits a relaxed environment, matching your capacity for light play.")
        else:
            reasons.append("This energetic pet will motivate you to stay active and go on long walks.")
            
        # Space
        if user_pref.space_available >= pet_attr.space_needed:
            reasons.append("Your home layout provides generous space for this pet's requirements.")
        else:
            reasons.append("This pet is independent enough to adapt to more compact apartment living.")
            
        # Attention/Time
        diff_attention = abs(user_pref.time_commitment - pet_attr.attention_needed)
        if diff_attention < 0.3:
            reasons.append("You have sufficient availability to provide the care and mental stimulation they need.")
        elif user_pref.time_commitment < pet_attr.attention_needed:
            reasons.append("This pet is independent and copes well when you're away at work.")
        else:
            reasons.append("You have plenty of time to pamper and train this highly affectionate companion.")

        return {
            "pet_id": pet_attr.pet_id,
            "score": round(score, 2),
            "reasons": reasons
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Matchmaking scoring error: {str(e)}")
