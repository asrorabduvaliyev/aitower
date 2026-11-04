from math import sqrt
from .haversine import haversine_km

def _vec(tags, vocab):
    return [1.0 if t in tags else 0.0 for t in vocab]

def _cosine(a, b):
    na, nb = sqrt(sum(x * x for x in a)), sqrt(sum(x * x for x in b))
    return 0.0 if na == 0 or nb == 0 else sum(x * y for x, y in zip(a, b)) / (na * nb)

def item_tags(item):
    tags = {t.strip().lower() for t in (item.tags or "").split(",") if t.strip()}
    tags.add((item.category or "").lower())
    return tags

def recommend(items, interests, lat=None, lon=None, limit=10):
    """Kontentga asoslangan filtrlash: qiziqishlar vektori bilan joy teglari vektori
    orasidagi kosinus o'xshashligi + reyting + (bo'lsa) yaqinlik."""
    want = {i.strip().lower() for i in interests if i.strip()}
    vocab = sorted(want.union(*[item_tags(i) for i in items])) if items else []
    uvec = _vec(want, vocab)
    out = []
    for it in items:
        sim = _cosine(uvec, _vec(item_tags(it), vocab))
        prox = 0.0
        if lat is not None and lon is not None:
            prox = 1 / (1 + haversine_km((lat, lon), (it.lat, it.lon)) / 50)
        score = 0.7 * sim + 0.2 * (it.rating or 0) / 5 + 0.1 * prox
        out.append((round(score, 4), it))
    out.sort(key=lambda x: x[0], reverse=True)
    return out[:limit]
