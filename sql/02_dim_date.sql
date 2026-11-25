CREATE TABLE dbo.DimDate (
    date_key INT NOT NULL,
    date DATE NOT NULL,
    year INT NOT NULL,
    quarter INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(10) NOT NULL,
    day INT NOT NULL,
    day_of_week INT NOT NULL,
    day_name VARCHAR(10) NOT NULL,
    is_weekend BIT NOT NULL
);

INSERT INTO dbo.DimDate
SELECT
    YEAR(d.date) * 10000 + MONTH(d.date) * 100 + DAY(d.date) AS date_key,
    d.date,
    YEAR(d.date) AS year,
    DATEPART(QUARTER, d.date) AS quarter,
    MONTH(d.date) AS month,
    DATENAME(MONTH, d.date) AS month_name,
    DAY(d.date) AS day,
    DATEPART(WEEKDAY, d.date) AS day_of_week,
    DATENAME(WEEKDAY, d.date) AS day_name,
    CASE WHEN DATEPART(WEEKDAY, d.date) IN (1, 7) THEN 1 ELSE 0 END AS is_weekend
FROM (
    SELECT DATEADD(DAY, value, CAST('2023-01-01' AS DATE)) AS date
    FROM GENERATE_SERIES(0, 1095)
) AS d;
