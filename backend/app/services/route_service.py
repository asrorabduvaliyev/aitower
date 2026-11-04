from ..models import Attraction
from ..algorithms.optimizer import plan_route

def build_route(db, req):
    rows = db.query(Attraction).filter(Attraction.id.in_(req.attraction_ids)).all()
    items = [{"id": a.id, "name": a.name, "lat": a.lat, "lon": a.lon,
              "visit_minutes": a.visit_minutes, "cost_usd": a.cost_usd} for a in rows]
    if not items:
        return None
    start = (req.start_lat, req.start_lon) if req.start_lat is not None and req.start_lon is not None else None
    return plan_route(items, start, req.max_minutes_per_day)
