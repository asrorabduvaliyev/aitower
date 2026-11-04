from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from ..database import get_db
from ..models import Attraction
from ..schemas import AttractionOut
from ..services.gps_service import nearby

router = APIRouter(prefix="/attractions", tags=["attractions"])

@router.get("", response_model=List[AttractionOut])
def list_all(city: Optional[str] = None, category: Optional[str] = None, db: Session = Depends(get_db)):
    q = db.query(Attraction)
    if city: q = q.filter(Attraction.city == city)
    if category: q = q.filter(Attraction.category == category)
    return q.all()

@router.get("/nearby")
def get_nearby(lat: float, lon: float, radius_km: float = 25, db: Session = Depends(get_db)):
    return [{**AttractionOut.model_validate(a).model_dump(), "distance_km": round(d, 2)}
            for d, a in nearby(db, lat, lon, radius_km)]

@router.get("/{item_id}", response_model=AttractionOut)
def get_one(item_id: int, db: Session = Depends(get_db)):
    a = db.get(Attraction, item_id)
    if not a: raise HTTPException(404, "Joy topilmadi")
    return a
