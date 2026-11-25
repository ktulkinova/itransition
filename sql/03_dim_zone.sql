CREATE TABLE dbo.DimZone (
    zone_key INT NOT NULL,
    borough VARCHAR(50) NOT NULL,
    zone VARCHAR(100) NOT NULL,
    service_zone VARCHAR(50) NOT NULL
);

INSERT INTO dbo.DimZone
SELECT
    z.location_id AS zone_key,
    z.borough,
    z.zone,
    z.service_zone
FROM silver.dbo.taxi_zones AS z;
