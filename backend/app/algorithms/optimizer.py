from .haversine import distance_matrix
from .astar import build_graph, astar
from .genetic_algorithm import genetic_tsp

CITY_SPEED, INTERCITY_SPEED = 30.0, 70.0  # km/soat

def plan_route(items, start=None, max_minutes=480):
    """GA tashrif tartibini topadi, A* har bir bo'g'in yo'lini hisoblaydi,
    so'ng vaqt limiti bo'yicha kunlarga bo'linadi."""
    nodes = items[:]
    if start:
        nodes = [{"id": 0, "name": "Boshlang'ich nuqta", "lat": start[0], "lon": start[1],
                  "visit_minutes": 0, "cost_usd": 0.0}] + nodes
    coords = [(n["lat"], n["lon"]) for n in nodes]
    order = genetic_tsp(distance_matrix(coords))
    graph = build_graph(coords)
    new = lambda d: {"day": d, "stops": [], "distance_km": 0.0, "minutes": 0.0, "cost_usd": 0.0, "path": []}
    days, cur, prev = [], new(1), None
    for idx in order:
        n = nodes[idx]
        if start and idx == 0:
            cur["path"].append(list(coords[0])); prev = 0; continue
        km = tm = 0.0
        seg = [list(coords[idx])]
        if prev is not None:
            p, km = astar(graph, coords, prev, idx)
            tm = km / (INTERCITY_SPEED if km > 80 else CITY_SPEED) * 60
            seg = [list(coords[i]) for i in p]
        need = tm + n["visit_minutes"]
        if cur["stops"] and cur["minutes"] + need > max_minutes:
            days.append(cur); cur = new(len(days) + 1)
        cur["stops"].append({"id": n["id"], "name": n["name"], "lat": n["lat"], "lon": n["lon"],
                             "visit_minutes": n["visit_minutes"], "cost_usd": n["cost_usd"],
                             "travel_km": round(km, 1), "travel_minutes": round(tm)})
        cur["distance_km"] += km; cur["minutes"] += need; cur["cost_usd"] += n["cost_usd"]
        cur["path"] += seg
        prev = idx
    days.append(cur)
    for d in days:
        d["distance_km"] = round(d["distance_km"], 1); d["minutes"] = round(d["minutes"])
    return {"days": days,
            "total_distance_km": round(sum(d["distance_km"] for d in days), 1),
            "total_cost_usd": round(sum(d["cost_usd"] for d in days), 2)}
