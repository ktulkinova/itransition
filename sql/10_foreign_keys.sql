ALTER TABLE dbo.FactTaxiDaily ADD CONSTRAINT FK_FactTaxiDaily_DimDate FOREIGN KEY (date_key) REFERENCES dbo.DimDate (date_key) NOT ENFORCED;
ALTER TABLE dbo.FactTaxiDaily ADD CONSTRAINT FK_FactTaxiDaily_DimFX FOREIGN KEY (date_key) REFERENCES dbo.DimFX (date_key) NOT ENFORCED;
ALTER TABLE dbo.FactTaxiDaily ADD CONSTRAINT FK_FactTaxiDaily_DimZone FOREIGN KEY (zone_key) REFERENCES dbo.DimZone (zone_key) NOT ENFORCED;
ALTER TABLE dbo.FactTaxiDaily ADD CONSTRAINT FK_FactTaxiDaily_DimGDP FOREIGN KEY (year) REFERENCES dbo.DimGDP (year) NOT ENFORCED;
ALTER TABLE dbo.FactAirQualityDaily ADD CONSTRAINT FK_FactAirQualityDaily_DimDate FOREIGN KEY (date_key) REFERENCES dbo.DimDate (date_key) NOT ENFORCED;
ALTER TABLE dbo.FactAirQualityDaily ADD CONSTRAINT FK_FactAirQualityDaily_DimGDP FOREIGN KEY (year) REFERENCES dbo.DimGDP (year) NOT ENFORCED;
ALTER TABLE dbo.FactCityHourly ADD CONSTRAINT FK_FactCityHourly_DimDate FOREIGN KEY (date_key) REFERENCES dbo.DimDate (date_key) NOT ENFORCED;
