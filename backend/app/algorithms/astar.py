import heapq
from .haversine import haversine_km

ROAD_FACTOR = 1.3  # to'g'ri chiziq -> yo'l masofasi taxmini

def build_graph(coords, k=4):
    """Har bir nuqta eng yaqin k ta qo'shnisi bilan bog'lanadi (ikki tomonlama)."""
    n = len(coords)
    g = {i: {} for i in range(n)}
    for i in range(n):
        near = sorted((j for j in range(n) if j != i), key=lambda j: haversine_km(coords[i], coords[j]))[:k]
        for j in near:
            w = haversine_km(coords[i], coords[j]) * ROAD_FACTOR
            g[i][j] = g[j][i] = w
    return g

def astar(graph, coords, start, goal):
    """A*: heuristika = Haversine. Qaytaradi (yo'l indekslari, masofa km)."""
    h = lambda n: haversine_km(coords[n], coords[goal])
    heap = [(h(start), 0.0, start)]
    best, came = {start: 0.0}, {}
    while heap:
        _, g, cur = heapq.heappop(heap)
        if cur == goal:
            path = [cur]
            while cur in came:
                cur = came[cur]
                path.append(cur)
            return path[::-1], g
        if g > best.get(cur, float("inf")):
            continue
        for nb, w in graph[cur].items():
            ng = g + w
            if ng < best.get(nb, float("inf")):
                best[nb], came[nb] = ng, cur
                heapq.heappush(heap, (ng + h(nb), ng, nb))
    return [start, goal], haversine_km(coords[start], coords[goal]) * ROAD_FACTOR
