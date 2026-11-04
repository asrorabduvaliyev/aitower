from math import radians, sin, cos, asin, sqrt

R_KM = 6371.0088

def haversine_km(a, b):
    """a, b = (lat, lon) gradusda. Ikki nuqta orasidagi katta doira masofasi (km)."""
    la1, lo1, la2, lo2 = map(radians, (a[0], a[1], b[0], b[1]))
    h = sin((la2 - la1) / 2) ** 2 + cos(la1) * cos(la2) * sin((lo2 - lo1) / 2) ** 2
    return 2 * R_KM * asin(sqrt(h))

def distance_matrix(coords):
    n = len(coords)
    m = [[0.0] * n for _ in range(n)]
    for i in range(n):
        for j in range(i + 1, n):
            m[i][j] = m[j][i] = haversine_km(coords[i], coords[j])
    return m
