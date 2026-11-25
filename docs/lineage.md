# Lineage

```mermaid
flowchart TB
    subgraph SRC["Sources"]
        tlc["NYC TLC trips<br/>Parquet"]
        lookup["NYC TLC zones<br/>CSV"]
        ecb["ECB USD/EUR<br/>CSV API"]
        wb["World Bank GDP<br/>JSON API"]
        oaq["OpenAQ v3<br/>JSON API"]
        arch["OpenAQ archive<br/>csv.gz on S3"]
    end
    subgraph BRZ["Bronze: lakehouse bronze"]
        b_taxi["Files/nyc_taxi/yellow"]
        b_zones["Files/nyc_taxi/lookup"]
        b_fx["ecb_fx_raw"]
        b_gdp["worldwide_bank"]
        b_air["openaq"]
        b_arch["openaq_archive"]
    end
    p_st(["notebook silver_taxi"])
    p_so(["notebook silver_others"])
    subgraph SLV["Silver: lakehouse silver"]
        s_trips["nyc_taxi_trips"]
        s_zones["taxi_zones"]
        s_fx["ecb_fx"]
        s_gdp["gdp"]
        s_air["air_quality"]
    end
    p_gl(["notebook gold_load"])
    subgraph GLD["Gold: warehouse gold"]
        f_taxi["FactTaxiDaily"]
        f_hour["FactCityHourly"]
        f_air["FactAirQualityDaily"]
        d_date["DimDate"]
        d_zone["DimZone"]
        d_fx["DimFX"]
        d_gdp["DimGDP"]
    end
    model["Semantic model air_taxi_model<br/>Direct Lake"]
    report["Report NYC Taxi & Air Quality"]

    tlc -->|pipeline nyc_taxi| b_taxi
    lookup -->|CopyJob_1| b_zones
    ecb -->|Dataflow ecb_fx| b_fx
    wb -->|Dataflow bank| b_gdp
    oaq -->|Dataflow openaq| b_air
    arch -->|notebook bronze_openaq_archive| b_arch

    b_taxi --> p_st --> s_trips
    b_zones --> p_so
    b_fx --> p_so
    b_gdp --> p_so
    b_air --> p_so
    b_arch --> p_so
    p_so --> s_zones
    p_so --> s_fx
    p_so --> s_gdp
    p_so --> s_air

    s_trips --> p_gl
    s_zones --> p_gl
    s_fx --> p_gl
    s_gdp --> p_gl
    s_air --> p_gl
    p_gl --> f_taxi
    p_gl --> f_hour
    p_gl --> f_air
    p_gl --> d_date
    p_gl --> d_zone
    p_gl --> d_fx
    p_gl --> d_gdp

    GLD --> model --> report
```

| Gold table | Silver | Bronze | Source |
|---|---|---|---|
| FactTaxiDaily | nyc_taxi_trips | Files/nyc_taxi/yellow | NYC TLC |
| FactCityHourly | nyc_taxi_trips, air_quality | Files/nyc_taxi/yellow, openaq, openaq_archive | NYC TLC, OpenAQ |
| FactAirQualityDaily | air_quality | openaq, openaq_archive | OpenAQ API and archive |
| DimZone | taxi_zones | Files/nyc_taxi/lookup | NYC TLC |
| DimFX | ecb_fx | ecb_fx_raw | ECB |
| DimGDP | gdp | worldwide_bank | World Bank |
| DimDate | - | - | generated in gold_load |
