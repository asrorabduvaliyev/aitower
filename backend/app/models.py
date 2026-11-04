from sqlalchemy import Column, Integer, String, Float, Text
from .database import Base

class Attraction(Base):
    __tablename__ = "attractions"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(200), nullable=False)
    city = Column(String(100), index=True)
    category = Column(String(60))
    tags = Column(String(200), default="")
    lat = Column(Float, nullable=False)
    lon = Column(Float, nullable=False)
    rating = Column(Float, default=4.0)
    visit_minutes = Column(Integer, default=60)
    cost_usd = Column(Float, default=0)
    description = Column(Text, default="")
