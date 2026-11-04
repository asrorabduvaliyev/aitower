from ..models import Attraction
from ..algorithms.haversine import haversine_km

def nearby(db, lat, lon, radius_km=25.0, limit=20):
    res = []
    for a in db.query(Attraction).all():
        d = haversine_km((lat, lon), (a.lat, a.lon))
        if d <= radius_km:
            res.append((d, a))
    res.sort(key=lambda x: x[0])
    return res[:limit]
