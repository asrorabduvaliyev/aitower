
import math

def calculate_distance(lat1, lon1, lat2, lon2):
    """
    Ikki geografik koordinata orasidagi masofani km da hisoblaydi.
    Haversine formulasi.
    """
    R = 6371.0088

    lat1 = math.radians(lat1)
    lat2 = math.radians(lat2)

    dlat = lat2 - lat1
    dlon = math.radians(lon2 - lon1)

    a = (
        math.sin(dlat / 2) ** 2
        + math.cos(lat1)
        * math.cos(lat2)
        * math.sin(dlon / 2) ** 2
    )

    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))

    return R * c
