CREATE TABLE dbo.DimGDP (
    year INT NOT NULL,
    country_code VARCHAR(3) NOT NULL,
    gdp_usd DECIMAL(20, 2) NOT NULL
);

INSERT INTO dbo.DimGDP
SELECT
    g.year,
    g.country_code,
    CAST(g.gdp_usd AS DECIMAL(20, 2)) AS gdp_usd
FROM silver.dbo.gdp AS g;
