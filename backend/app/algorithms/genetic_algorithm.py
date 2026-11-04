import random

def genetic_tsp(dm, pop=80, gens=200, mut=0.25, seed=42):
    """Genetik algoritm (TSP): 0-indeks boshlang'ich nuqta, qolganlari tartibi optimallanadi."""
    n = len(dm)
    if n <= 3:
        return list(range(n))
    rnd = random.Random(seed)
    cost = lambda r: sum(dm[r[i]][r[i + 1]] for i in range(n - 1))

    def rand():
        r = list(range(1, n)); rnd.shuffle(r); return [0] + r

    def pick(P):
        return min(rnd.sample(P, min(3, len(P))), key=cost)

    def crossover(a, b):  # Order crossover
        i, j = sorted(rnd.sample(range(1, n), 2))
        mid = a[i:j + 1]
        rest = [g for g in b if g not in mid and g != 0]
        return [0] + rest[:i - 1] + mid + rest[i - 1:]

    def mutate(r):
        if rnd.random() < mut:
            i, j = sorted(rnd.sample(range(1, n), 2))
            r[i:j + 1] = reversed(r[i:j + 1])  # 2-opt
        return r

    P = [rand() for _ in range(pop)]
    for _ in range(gens):
        P.sort(key=cost)
        nxt = P[:2]
        while len(nxt) < pop:
            nxt.append(mutate(crossover(pick(P), pick(P))))
        P = nxt
    return min(P, key=cost)
