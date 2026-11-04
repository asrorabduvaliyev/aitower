import os
BASE = os.path.dirname(os.path.abspath(__file__))
DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./tourism.db")
CSV_PATH = os.getenv("CSV_PATH", os.path.join(BASE, "..", "..", "data", "attractions.csv"))
