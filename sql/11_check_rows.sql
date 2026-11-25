SELECT 'DimDate' AS table_name, COUNT(*) AS row_count FROM dbo.DimDate
UNION ALL
SELECT 'DimZone', COUNT(*) FROM dbo.DimZone
UNION ALL
SELECT 'DimFX', COUNT(*) FROM dbo.DimFX
UNION ALL
SELECT 'DimGDP', COUNT(*) FROM dbo.DimGDP
UNION ALL
SELECT 'FactTaxiDaily', COUNT(*) FROM dbo.FactTaxiDaily
UNION ALL
SELECT 'FactAirQualityDaily', COUNT(*) FROM dbo.FactAirQualityDaily
UNION ALL
SELECT 'FactCityHourly', COUNT(*) FROM dbo.FactCityHourly;
