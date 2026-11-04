
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE attractions (
    id SERIAL PRIMARY KEY,

    name VARCHAR(250) NOT NULL,

    category VARCHAR(100),

    description TEXT,

    location GEOGRAPHY(POINT, 4326),

    rating FLOAT DEFAULT 0,

    visit_duration_min INTEGER DEFAULT 60,

    entrance_fee NUMERIC(12,2) DEFAULT 0,

    opening_hours VARCHAR(150),

    accessibility BOOLEAN DEFAULT FALSE,

    verified BOOLEAN DEFAULT FALSE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX attraction_location_idx
ON attractions
USING GIST(location);


CREATE TABLE tourists (
    id SERIAL PRIMARY KEY,

    full_name VARCHAR(200),

    preferred_categories TEXT[],

    budget NUMERIC(12,2),

    transport_mode VARCHAR(50),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE tourist_routes (
    id SERIAL PRIMARY KEY,

    tourist_id INTEGER REFERENCES tourists(id),

    route_data JSONB,

    total_distance FLOAT,

    estimated_duration INTEGER,

    algorithm_name VARCHAR(100),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE route_feedback (
    id SERIAL PRIMARY KEY,

    route_id INTEGER REFERENCES tourist_routes(id),

    rating INTEGER CHECK(rating BETWEEN 1 AND 5),

    comment TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
