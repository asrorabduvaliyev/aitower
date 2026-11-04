from typing import List, Optional
from pydantic import BaseModel, ConfigDict

class AttractionOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    id: int
    name: str
    city: str
    category: str
    tags: str
    lat: float
    lon: float
    rating: float
    visit_minutes: int
    cost_usd: float
    description: str

class RecommendRequest(BaseModel):
    interests: List[str]
    city: Optional[str] = None
    lat: Optional[float] = None
    lon: Optional[float] = None
    limit: int = 10

class RecommendationOut(AttractionOut):
    score: float

class RoutePlanRequest(BaseModel):
    attraction_ids: List[int]
    start_lat: Optional[float] = None
    start_lon: Optional[float] = None
    max_minutes_per_day: int = 480

class StopOut(BaseModel):
    id: int
    name: str
    lat: float
    lon: float
    visit_minutes: int
    cost_usd: float
    travel_km: float
    travel_minutes: float

class DayOut(BaseModel):
    day: int
    stops: List[StopOut]
    distance_km: float
    minutes: float
    cost_usd: float
    path: List[List[float]]

class RoutePlanOut(BaseModel):
    days: List[DayOut]
    total_distance_km: float
    total_cost_usd: float
