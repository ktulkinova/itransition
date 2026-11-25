SELECT
    SUM(CASE WHEN date_key IS NULL THEN 1 ELSE 0 END) AS null_date_key,
    SUM(CASE WHEN zone_key IS NULL THEN 1 ELSE 0 END) AS null_zone_key,
    SUM(CASE WHEN trip_count IS NULL THEN 1 ELSE 0 END) AS null_trip_count,
    SUM(CASE WHEN total_amount_usd IS NULL THEN 1 ELSE 0 END) AS null_total_amount,
    SUM(CASE WHEN avg_fare_usd IS NULL THEN 1 ELSE 0 END) AS null_avg_fare
FROM dbo.FactTaxiDaily;

SELECT
    SUM(CASE WHEN date_key IS NULL THEN 1 ELSE 0 END) AS null_date_key,
    SUM(CASE WHEN location_id IS NULL THEN 1 ELSE 0 END) AS null_location_id,
    SUM(CASE WHEN parameter IS NULL THEN 1 ELSE 0 END) AS null_parameter,
    SUM(CASE WHEN avg_value IS NULL THEN 1 ELSE 0 END) AS null_avg_value
FROM dbo.FactAirQualityDaily;

SELECT
    SUM(CASE WHEN date_key IS NULL THEN 1 ELSE 0 END) AS null_date_key,
    SUM(CASE WHEN hour IS NULL THEN 1 ELSE 0 END) AS null_hour,
    SUM(CASE WHEN trips IS NULL THEN 1 ELSE 0 END) AS null_trips,
    SUM(CASE WHEN pm25_avg IS NULL THEN 1 ELSE 0 END) AS null_pm25_avg,
    SUM(CASE WHEN no2_avg IS NULL THEN 1 ELSE 0 END) AS null_no2_avg
FROM dbo.FactCityHourly;
