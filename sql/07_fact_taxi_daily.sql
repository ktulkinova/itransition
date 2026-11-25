CREATE TABLE dbo.FactTaxiDaily (
    date_key INT NOT NULL,
    zone_key INT NOT NULL,
    year INT NOT NULL,
    trip_count INT NOT NULL,
    total_fare_usd DECIMAL(18, 2) NOT NULL,
    total_amount_usd DECIMAL(18, 2) NOT NULL,
    total_distance_miles DECIMAL(18, 2) NOT NULL,
    total_duration_min DECIMAL(18, 2) NOT NULL,
    avg_fare_usd DECIMAL(10, 2) NOT NULL,
    avg_amount_usd DECIMAL(10, 2) NOT NULL,
    avg_distance_miles DECIMAL(10, 2) NOT NULL,
    avg_duration_min DECIMAL(10, 2) NOT NULL
);

INSERT INTO dbo.FactTaxiDaily
SELECT
    YEAR(t.pickup_date) * 10000 + MONTH(t.pickup_date) * 100 + DAY(t.pickup_date) AS date_key,
    t.pu_location_id AS zone_key,
    YEAR(t.pickup_date) AS year,
    COUNT(*) AS trip_count,
    CAST(SUM(t.fare_amount) AS DECIMAL(18, 2)) AS total_fare_usd,
    CAST(SUM(t.total_amount) AS DECIMAL(18, 2)) AS total_amount_usd,
    CAST(SUM(t.trip_distance) AS DECIMAL(18, 2)) AS total_distance_miles,
    CAST(SUM(t.trip_duration_min) AS DECIMAL(18, 2)) AS total_duration_min,
    CAST(AVG(t.fare_amount) AS DECIMAL(10, 2)) AS avg_fare_usd,
    CAST(AVG(t.total_amount) AS DECIMAL(10, 2)) AS avg_amount_usd,
    CAST(AVG(t.trip_distance) AS DECIMAL(10, 2)) AS avg_distance_miles,
    CAST(AVG(t.trip_duration_min) AS DECIMAL(10, 2)) AS avg_duration_min
FROM silver.dbo.nyc_taxi_trips AS t
GROUP BY t.pickup_date, t.pu_location_id;
