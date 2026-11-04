
import random
from .haversine import calculate_distance


def route_distance(route, start):
    total = 0
    lat, lon = start

    for item in route:
        total += calculate_distance(
            lat, lon,
            item["latitude"],
            item["longitude"]
        )

        lat = item["latitude"]
        lon = item["longitude"]

    return total


def genetic_algorithm(
    attractions,
    start,
    population_size=40,
    generations=100
):
    if len(attractions) <= 1:
        return attractions

    def fitness(route):
        return route_distance(route, start)

    population = []

    for _ in range(population_size):
        chromosome = attractions.copy()
        random.shuffle(chromosome)
        population.append(chromosome)

    for generation in range(generations):

        population.sort(key=fitness)

        elite_count = max(2, population_size // 5)
        new_population = population[:elite_count]

        while len(new_population) < population_size:

            parent1, parent2 = random.sample(
                population[:elite_count], 2
            )

            n = len(parent1)
            left, right = sorted(random.sample(range(n), 2))

            child = [None] * n
            child[left:right] = parent1[left:right]

            remaining = [
                x for x in parent2 if x not in child
            ]

            j = 0

            for i in range(n):
                if child[i] is None:
                    child[i] = remaining[j]
                    j += 1

            # Mutatsiya
            if random.random() < 0.2:
                i, j = random.sample(range(n), 2)
                child[i], child[j] = child[j], child[i]

            new_population.append(child)

        population = new_population

    best_route = min(population, key=fitness)

    return {
        "route": best_route,
        "distance_km": round(
            route_distance(best_route, start), 2
        )
    }
