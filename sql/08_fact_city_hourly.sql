CREATE TABLE dbo.FactCityHourly (
    date_key INT NOT NULL,
    hour INT NOT NULL,
    trips INT NOT NULL,
    pm25_avg FLOAT NULL,
    no2_avg FLOAT NULL
);

INSERT INTO dbo.FactCityHourly
SELECT
    t.date_key,
    t.hour,
    t.trips,
    a.pm25_avg,
    a.no2_avg
FROM (
    SELECT
        YEAR(pickup_date) * 10000 + MONTH(pickup_date) * 100 + DAY(pickup_date) AS date_key,
        pickup_hour AS hour,
        COUNT(*) AS trips
    FROM silver.dbo.nyc_taxi_trips
    GROUP BY pickup_date, pickup_hour
) AS t
LEFT JOIN (
    SELECT
        YEAR(date) * 10000 + MONTH(date) * 100 + DAY(date) AS date_key,
        hour,
        AVG(CASE WHEN parameter = 'pm25' THEN value END) AS pm25_avg,
        AVG(CASE WHEN parameter = 'no2' THEN value END) AS no2_avg
    FROM silver.dbo.air_quality
    GROUP BY date, hour
) AS a
    ON a.date_key = t.date_key
    AND a.hour = t.hour;
