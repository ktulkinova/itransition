CREATE TABLE dbo.FactAirQualityDaily (
    date_key INT NOT NULL,
    year INT NOT NULL,
    location_id INT NOT NULL,
    location_name VARCHAR(100) NOT NULL,
    parameter VARCHAR(10) NOT NULL,
    units VARCHAR(10) NOT NULL,
    avg_value FLOAT NOT NULL,
    min_value FLOAT NOT NULL,
    max_value FLOAT NOT NULL,
    measurement_count INT NOT NULL
);

INSERT INTO dbo.FactAirQualityDaily
SELECT
    YEAR(a.date) * 10000 + MONTH(a.date) * 100 + DAY(a.date) AS date_key,
    YEAR(a.date) AS year,
    a.location_id,
    a.location_name,
    a.parameter,
    a.units,
    AVG(a.value) AS avg_value,
    MIN(a.value) AS min_value,
    MAX(a.value) AS max_value,
    COUNT(*) AS measurement_count
FROM silver.dbo.air_quality AS a
GROUP BY a.date, a.location_id, a.location_name, a.parameter, a.units;
