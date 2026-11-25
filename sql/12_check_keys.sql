SELECT 'FactTaxiDaily -> DimDate' AS link, COUNT(*) AS rows_without_pair
FROM dbo.FactTaxiDaily AS f
LEFT JOIN dbo.DimDate AS d ON d.date_key = f.date_key
WHERE d.date_key IS NULL
UNION ALL
SELECT 'FactTaxiDaily -> DimFX', COUNT(*)
FROM dbo.FactTaxiDaily AS f
LEFT JOIN dbo.DimFX AS fx ON fx.date_key = f.date_key
WHERE fx.date_key IS NULL
UNION ALL
SELECT 'FactTaxiDaily -> DimZone', COUNT(*)
FROM dbo.FactTaxiDaily AS f
LEFT JOIN dbo.DimZone AS z ON z.zone_key = f.zone_key
WHERE z.zone_key IS NULL
UNION ALL
SELECT 'FactTaxiDaily -> DimGDP', COUNT(*)
FROM dbo.FactTaxiDaily AS f
LEFT JOIN dbo.DimGDP AS g ON g.year = f.year
WHERE g.year IS NULL
UNION ALL
SELECT 'FactAirQualityDaily -> DimDate', COUNT(*)
FROM dbo.FactAirQualityDaily AS a
LEFT JOIN dbo.DimDate AS d ON d.date_key = a.date_key
WHERE d.date_key IS NULL
UNION ALL
SELECT 'FactAirQualityDaily -> DimGDP', COUNT(*)
FROM dbo.FactAirQualityDaily AS a
LEFT JOIN dbo.DimGDP AS g ON g.year = a.year
WHERE g.year IS NULL
UNION ALL
SELECT 'FactCityHourly -> DimDate', COUNT(*)
FROM dbo.FactCityHourly AS h
LEFT JOIN dbo.DimDate AS d ON d.date_key = h.date_key
WHERE d.date_key IS NULL;
