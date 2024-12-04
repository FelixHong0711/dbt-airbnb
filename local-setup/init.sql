-- Apply to airbnb database
\c airbnb

-- Use the raw schema
CREATE SCHEMA IF NOT EXISTS raw;
SET search_path TO raw;

-- Create tables
CREATE TABLE IF NOT EXISTS raw_listings (
    id INTEGER,
    listing_url TEXT,
    name TEXT,
    room_type TEXT,
    minimum_nights INTEGER,
    host_id INTEGER,
    price TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS raw_reviews (
    listing_id INTEGER,
    date TIMESTAMP,
    reviewer_name TEXT,
    comments TEXT,
    sentiment TEXT
);

CREATE TABLE IF NOT EXISTS raw_hosts (
    id INTEGER,
    name TEXT,
    is_superhost TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Load data from the mounted directory
COPY raw_listings (id, listing_url, name, room_type, minimum_nights, host_id, price, created_at, updated_at)
FROM '/s3data/listings.csv'
DELIMITER ','
CSV HEADER;

COPY raw_reviews (listing_id, date, reviewer_name, comments, sentiment)
FROM '/s3data/reviews.csv'
DELIMITER ','
CSV HEADER;

COPY raw_hosts (id, name, is_superhost, created_at, updated_at)
FROM '/s3data/hosts.csv'
DELIMITER ','
CSV HEADER;

-- Grant role privileges
-- Create the `transform` role
DO $$ BEGIN
    CREATE ROLE transform;
EXCEPTION WHEN DUPLICATE_OBJECT THEN
    RAISE NOTICE 'Role transform already exists.';
END $$;

-- Create the `dbt` user and assign to the `transform` role
DO $$ BEGIN
    CREATE ROLE dbt WITH LOGIN PASSWORD 'dbtPassword123';
EXCEPTION WHEN DUPLICATE_OBJECT THEN
    RAISE NOTICE 'Role dbt already exists.';
END $$;

GRANT transform TO dbt;

-- Grant permissions to the `transform` role on the schema
-- (workaround, not recommended, in a real life scenario, specific privileges should be assigned instead)
ALTER ROLE transform WITH SUPERUSER;
