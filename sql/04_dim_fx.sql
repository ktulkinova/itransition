CREATE TABLE dbo.DimFX (
    date_key INT NOT NULL,
    usd_per_eur DECIMAL(10, 4) NOT NULL
);

INSERT INTO dbo.DimFX
SELECT
    YEAR(fx.date) * 10000 + MONTH(fx.date) * 100 + DAY(fx.date) AS date_key,
    CAST(fx.usd_per_eur AS DECIMAL(10, 4)) AS usd_per_eur
FROM silver.dbo.ecb_fx AS fx;
