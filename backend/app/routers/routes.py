from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from ..database import get_db
from ..schemas import RoutePlanRequest, RoutePlanOut
from ..services.route_service import build_route

router = APIRouter(prefix="/routes", tags=["routes"])

@router.post("/plan", response_model=RoutePlanOut)
def plan(req: RoutePlanRequest, db: Session = Depends(get_db)):
    res = build_route(db, req)
    if res is None: raise HTTPException(400, "Joylar tanlanmagan")
    return res
