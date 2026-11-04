
import heapq

def astar(graph, start, goal, heuristic):
    """
    A* algoritmi.
    graph: {node: [(neighbor, edge_cost), ...]}
    heuristic: tugundan maqsadgacha taxminiy xarajat.
    """

    open_set = [(0, start)]

    came_from = {}

    g_score = {start: 0}

    f_score = {
        start: heuristic(start, goal)
    }

    while open_set:

        _, current = heapq.heappop(open_set)

        if current == goal:
            path = [current]

            while current in came_from:
                current = came_from[current]
                path.append(current)

            return path[::-1]

        for neighbor, cost in graph.get(current, []):

            tentative_g = g_score[current] + cost

            if tentative_g < g_score.get(
                neighbor, float("inf")
            ):

                came_from[neighbor] = current

                g_score[neighbor] = tentative_g

                f_score[neighbor] = (
                    tentative_g
                    + heuristic(neighbor, goal)
                )

                heapq.heappush(
                    open_set,
                    (f_score[neighbor], neighbor)
                )

    return []
