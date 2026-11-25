# Data dictionary

## Gold: warehouse `gold`, schema `dbo`

### DimDate: 1,096 rows, one per day of 2023-2025

| Column | Type | Description |
|---|---|---|
| date_key | INT | PK, date as yyyymmdd |
| date | DATE | calendar date |
| year | INT | year |
| quarter | INT | quarter 1-4 |
| month | INT | month 1-12 |
| month_name | VARCHAR(10) | month name |
| day | INT | day of month |
| day_of_week | INT | 1 = Sunday |
| day_name | VARCHAR(10) | weekday name |
| is_weekend | BIT | 1 on Saturday and Sunday |

### DimZone: 263 rows

| Column | Type | Description |
|---|---|---|
| zone_key | INT | PK, TLC zone id |
| borough | VARCHAR(50) | borough |
| zone | VARCHAR(100) | zone name |
| service_zone | VARCHAR(50) | TLC service zone |

### DimFX: 1,096 rows

| Column | Type | Description |
|---|---|---|
| date_key | INT | PK, date |
| usd_per_eur | DECIMAL(10,4) | USD per 1 EUR from ECB |

### DimGDP: 3 rows

| Column | Type | Description |
|---|---|---|
| year | INT | PK |
| country_code | VARCHAR(3) | USA |
| gdp_usd | DECIMAL(20,2) | US GDP, current USD |

### FactTaxiDaily: 246,482 rows, one per day and pickup zone

| Column | Type | Description |
|---|---|---|
| date_key | INT | PK, FK to DimDate and DimFX |
| zone_key | INT | PK, FK to DimZone, pickup zone |
| year | INT | FK to DimGDP |
| trip_count | INT | trips |
| total_fare_usd | DECIMAL(18,2) | sum of fare_amount |
| total_amount_usd | DECIMAL(18,2) | sum of total_amount |
| total_distance_miles | DECIMAL(18,2) | sum of distance |
| total_duration_min | DECIMAL(18,2) | sum of duration |
| avg_fare_usd | DECIMAL(10,2) | average fare, this row only |
| avg_amount_usd | DECIMAL(10,2) | average total amount, this row only |
| avg_distance_miles | DECIMAL(10,2) | average distance, this row only |
| avg_duration_min | DECIMAL(10,2) | average duration, this row only |

### FactAirQualityDaily: 18,841 rows, one per day, station and pollutant

| Column | Type | Description |
|---|---|---|
| date_key | INT | PK, FK to DimDate |
| year | INT | FK to DimGDP |
| location_id | INT | PK, OpenAQ station id |
| location_name | VARCHAR(100) | station name |
| parameter | VARCHAR(10) | PK, pm25 or no2 |
| units | VARCHAR(10) | µg/m³ for pm25, ppm for no2 |
| avg_value | FLOAT | daily mean |
| min_value | FLOAT | daily min |
| max_value | FLOAT | daily max |
| measurement_count | INT | hourly values in the day |

### FactCityHourly: 26,301 rows, one per day and hour for the whole city

| Column | Type | Description |
|---|---|---|
| date_key | INT | PK, FK to DimDate |
| hour | INT | PK, hour 0-23, New York time |
| trips | INT | trips in the hour |
| pm25_avg | FLOAT | mean PM2.5 of all stations, NULL if no data |
| no2_avg | FLOAT | mean NO2 of all stations, NULL if no data |

## Silver: lakehouse `silver`, `Tables/dbo`

### nyc_taxi_trips: 119,359,262 rows, partitioned by year and month

| Column | Type | Description |
|---|---|---|
| vendor_id | int | data provider |
| pickup_datetime | timestamp | trip start, New York time |
| dropoff_datetime | timestamp | trip end, New York time |
| passenger_count | int | passengers, 0 replaced with NULL |
| trip_distance | double | miles |
| rate_code_id | int | rate code, 99 replaced with NULL |
| store_and_fwd_flag | string | Y if the meter stored the trip first |
| pu_location_id | int | pickup zone |
| do_location_id | int | dropoff zone |
| payment_type | int | payment type code |
| fare_amount | double | meter fare, USD |
| extra | double | extras, USD |
| mta_tax | double | MTA tax, USD |
| tip_amount | double | tip, USD |
| tolls_amount | double | tolls, USD |
| improvement_surcharge | double | improvement surcharge, USD |
| total_amount | double | total paid, USD |
| congestion_surcharge | double | congestion surcharge, USD |
| airport_fee | double | airport fee, USD |
| cbd_congestion_fee | double | CBD congestion fee, USD, 2025 only |
| year | int | year of the source file |
| month | int | month of the source file |
| trip_duration_min | double | duration, minutes |
| pickup_date | date | pickup date |
| pickup_hour | int | pickup hour |
| day_of_week | int | 1 = Sunday |
| is_weekend | boolean | Saturday or Sunday |

### taxi_zones: 263 rows

| Column | Type | Description |
|---|---|---|
| location_id | int | TLC zone id |
| borough | string | borough |
| zone | string | zone name |
| service_zone | string | TLC service zone |

### ecb_fx: 1,096 rows, one per day

| Column | Type | Description |
|---|---|---|
| date | date | day |
| usd_per_eur | double | USD per 1 EUR, last known rate on weekends and holidays |

### gdp: 3 rows

| Column | Type | Description |
|---|---|---|
| country_code | string | USA |
| year | int | year |
| gdp_usd | double | GDP, current USD |

### air_quality: 426,692 rows, one per sensor and hour

| Column | Type | Description |
|---|---|---|
| location_id | int | station id |
| location_name | string | station name |
| sensor_id | int | sensor id |
| parameter | string | pm25 or no2 |
| units | string | µg/m³ or ppm |
| datetime_utc | timestamp | start of the hour, UTC |
| datetime_local | timestamp | start of the hour, New York time |
| date | date | New York date |
| hour | int | New York hour |
| value | double | measured value |

## Bronze: lakehouse `bronze`

### Files/nyc_taxi/yellow/year=YYYY/month=MM/yellow_tripdata_YYYY-MM.parquet: 36 files, 128,202,548 rows

Types are from the 2023 files. Name case and some types differ between years.

| Column | Type | Description |
|---|---|---|
| VendorID | int32 | data provider |
| tpep_pickup_datetime | timestamp | trip start |
| tpep_dropoff_datetime | timestamp | trip end |
| passenger_count | int64 | passengers |
| trip_distance | double | miles |
| RatecodeID | int64 | rate code |
| store_and_fwd_flag | string | Y or N |
| PULocationID | int32 | pickup zone |
| DOLocationID | int32 | dropoff zone |
| payment_type | int64 | payment type code |
| fare_amount | double | meter fare, USD |
| extra | double | extras, USD |
| mta_tax | double | MTA tax, USD |
| tip_amount | double | tip, USD |
| tolls_amount | double | tolls, USD |
| improvement_surcharge | double | improvement surcharge, USD |
| total_amount | double | total paid, USD |
| congestion_surcharge | double | congestion surcharge, USD |
| Airport_fee | double | airport fee, name case differs by year |
| cbd_congestion_fee | double | CBD congestion fee, 2025 files only |

### Files/nyc_taxi/lookup/taxi_zone_lookup.csv: 265 rows

| Column | Type | Description |
|---|---|---|
| LocationID | text | zone id |
| Borough | text | borough |
| Zone | text | zone name |
| service_zone | text | service zone |

### dbo.ecb_fx_raw: 7,199 rows on 16 Nov 2026, business days since 1999

| Column | Type | Description |
|---|---|---|
| TIME_PERIOD | string | date |
| OBS_VALUE | string | USD per 1 EUR, empty on holidays |
| 30 other columns | string | ECB series metadata, not used |

### dbo.worldwide_bank: 66 rows, 1960-2025

| Column | Type | Description |
|---|---|---|
| countryiso3code | string | USA |
| date | string | year |
| value | double | GDP, current USD |

### dbo.openaq: 428,700 rows, 19 sensors at 17 stations

| Column | Type | Description |
|---|---|---|
| location_id | long | station id |
| location_name | string | station name |
| sensor_id | long | sensor id |
| parameter | string | pm25 or no2 |
| units | string | µg/m³ or ppm |
| datetime_utc | string | start of the hour, UTC |
| value | double | hourly mean |

### dbo.openaq_archive: 36,814 rows, Jan-Mar 2023, same 17 stations

| Column | Type | Description |
|---|---|---|
| location_id | long | station id |
| sensors_id | long | sensor id |
| location | string | station name |
| datetime | string | time with UTC offset |
| lat | double | latitude |
| lon | double | longitude |
| parameter | string | pm25, no2 and other pollutants |
| units | string | unit |
| value | double | measured value |
