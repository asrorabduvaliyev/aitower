CREATE TABLE IF NOT EXISTS attractions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    city VARCHAR(100),
    category VARCHAR(60),
    tags VARCHAR(200) DEFAULT '',
    lat DOUBLE PRECISION NOT NULL,
    lon DOUBLE PRECISION NOT NULL,
    rating DOUBLE PRECISION DEFAULT 4.0,
    visit_minutes INTEGER DEFAULT 60,
    cost_usd DOUBLE PRECISION DEFAULT 0,
    description TEXT DEFAULT ''
);
CREATE INDEX IF NOT EXISTS idx_attractions_city ON attractions(city);
