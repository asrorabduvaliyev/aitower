import csv
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .config import CSV_PATH
from .database import Base, engine, SessionLocal
from .models import Attraction
from .routers import attractions, recommendations, routes

Base.metadata.create_all(bind=engine)

def seed():
    db = SessionLocal()
    try:
        if db.query(Attraction).count():
            return
        with open(CSV_PATH, encoding="utf-8") as f:
            for r in csv.DictReader(f):
                db.add(Attraction(name=r["name"], city=r["city"], category=r["category"], tags=r["tags"],
                                  lat=float(r["lat"]), lon=float(r["lon"]), rating=float(r["rating"]),
                                  visit_minutes=int(r["visit_minutes"]), cost_usd=float(r["cost_usd"]),
                                  description=r["description"]))
        db.commit()
    finally:
        db.close()

seed()
app = FastAPI(title="AI Smart Tourism API")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])
app.include_router(attractions.router)
app.include_router(recommendations.router)
app.include_router(routes.router)

@app.get("/")
def health():
    return {"status": "ok"}
