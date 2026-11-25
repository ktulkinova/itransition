SELECT SUM(CAST(trip_count AS BIGINT)) AS trips FROM dbo.FactTaxiDaily;

SELECT SUM(measurement_count) AS measurements FROM dbo.FactAirQualityDaily;

SELECT SUM(CAST(trips AS BIGINT)) AS trips FROM dbo.FactCityHourly;

SELECT TOP 5 * FROM dbo.FactCityHourly ORDER BY date_key, hour;
