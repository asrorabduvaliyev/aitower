from typing import List
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from ..database import get_db
from ..models import Attraction
from ..schemas import RecommendRequest, RecommendationOut, AttractionOut
from ..algorithms.content_filtering import recommend

router = APIRouter(prefix="/recommendations", tags=["recommendations"])

@router.post("", response_model=List[RecommendationOut])
def recommendations(req: RecommendRequest, db: Session = Depends(get_db)):
    q = db.query(Attraction)
    if req.city: q = q.filter(Attraction.city == req.city)
    ranked = recommend(q.all(), req.interests, req.lat, req.lon, req.limit)
    return [RecommendationOut(**AttractionOut.model_validate(a).model_dump(), score=s) for s, a in ranked]
