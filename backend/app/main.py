
from fastapi import FastAPI
from pydantic import BaseModel
from typing import List

from algorithms.content_filtering import recommend_attractions
from algorithms.optimizer import generate_optimal_route

app = FastAPI(
    title="AI Smart Tourism",
    description="Qashqadaryo turistik marshrut tizimi",
    version="1.0"
)

# Dastlabki sinov uchun ma'lumotlar.
# Keyinchalik PostgreSQL/PostGIS bilan almashtiriladi.

attractions = []


class TouristRequest(BaseModel):
    latitude: float
    longitude: float
    interests: List[str] = []
    max_distance: float = 100


@app.get("/")
def home():
    return {
        "message": "AI Smart Tourism API ishlamoqda"
    }


@app.get("/health")
def health():
    return {
        "status": "online"
    }


@app.get("/attractions")
def get_attractions():
    return attractions


@app.post("/attractions")
def add_attraction(data: dict):
    data["id"] = len(attractions) + 1
    attractions.append(data)

    return {
        "message": "Obyekt qo'shildi",
        "data": data
    }


@app.post("/recommend")
def recommend(request: TouristRequest):

    result = recommend_attractions(
        attractions,
        request.latitude,
        request.longitude,
        request.interests,
        request.max_distance
    )

    return {
        "recommendations": result
    }


@app.post("/optimal-route")
def optimal_route(request: TouristRequest):

    result = generate_optimal_route(
        attractions,
        request.latitude,
        request.longitude,
        request.interests,
        request.max_distance
    )

    return result
