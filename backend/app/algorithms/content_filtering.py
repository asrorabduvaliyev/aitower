
from .haversine import calculate_distance

def recommend_attractions(
    attractions,
    user_lat,
    user_lon,
    interests,
    max_distance=100
):
    results = []

    for attraction in attractions:

        distance = calculate_distance(
            user_lat,
            user_lon,
            attraction["latitude"],
            attraction["longitude"]
        )

        if distance > max_distance:
            continue

        category_match = (
            1.0 if attraction["category"].lower()
            in [x.lower() for x in interests] else 0.0
        )

        rating = attraction.get("rating", 0) / 5

        proximity = 1 - distance / max_distance

        score = (
            0.55 * category_match
            + 0.25 * rating
            + 0.20 * proximity
        )

        results.append({
            "id": attraction["id"],
            "name": attraction["name"],
            "category": attraction["category"],
            "distance": round(distance, 2),
            "score": round(score, 4)
        })

    return sorted(
        results,
        key=lambda x: x["score"],
        reverse=True
    )
