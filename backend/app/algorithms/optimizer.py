
from .content_filtering import recommend_attractions
from .genetic_algorithm import genetic_algorithm


def generate_optimal_route(
    attractions,
    latitude,
    longitude,
    interests,
    max_distance=100,
    limit=10
):

    recommendations = recommend_attractions(
        attractions=attractions,
        user_lat=latitude,
        user_lon=longitude,
        interests=interests,
        max_distance=max_distance
    )

    selected_ids = {
        item["id"]
        for item in recommendations[:limit]
    }

    selected = [
        item for item in attractions
        if item["id"] in selected_ids
    ]

    result = genetic_algorithm(
        attractions=selected,
        start=(latitude, longitude)
    )

    return {
        "algorithm": "CBF + Genetic Algorithm",
        "recommended_count": len(selected),
        "route": result["route"],
        "estimated_distance_km": result["distance_km"]
    }
