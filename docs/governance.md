# Governance

## Data quality rules

Silver, taxi trips (`silver_taxi`):

- Pickup year and month must match the source file.
- Duration from 1 to 180 minutes.
- Distance above 0 and up to 100 miles.
- Speed up to 80 mph.
- `fare_amount` above 0 and up to 1,000 USD.
- `total_amount` above 0.
- Trips with pickup or dropoff zone 264 or 265 (unknown) are removed.
- `passenger_count = 0` and `rate_code_id = 99` become NULL. The rows stay.
- Full duplicates are removed.
- Column names and types are the same for all years.
- Result: 128,202,548 raw rows, 119,359,262 after cleaning (6.9% removed).

Silver, other tables (`silver_others`):

- `taxi_zones`: zones 264 and 265 removed, one row per zone.
- `ecb_fx`: empty rates removed, one row per day. Weekends and holidays get the last known rate. Only 2023-2025.
- `gdp`: empty values removed. Only 2023-2025.
- `air_quality`: empty and negative values removed. Time converted from UTC to America/New_York. One row per sensor and hour. Archive rows are added only for hours the API does not have.
- No upper limit for PM2.5. The 548 µg/m³ peak in June 2023 is real wildfire smoke.

Gold (`gold_load`):

- Keys are declared as NOT ENFORCED. The warehouse does not check them.
- Four check queries run after the load: row counts, fact rows without a dimension match, NULLs, totals.
- Expected: no fact rows without a match; NULLs only in `pm25_avg` (738) and `no2_avg` (834); 119,359,262 trips in both taxi facts; 426,692 air measurements.
- The checks show results but do not stop the pipeline.

Pipeline (`pl_main`):

- A step starts only after the previous steps succeed.
- `refresh_silver_endpoint` fails if a Silver table did not sync to the SQL endpoint. Without this step Gold can read an old table version.
- `refresh_model` fails if the model refresh does not complete.

## Refresh schedule

- `pl_main` runs every day at 10:00 Tashkent time (UTC+5). The schedule is on until 31 Dec 2026.
- A run takes about 50 minutes.
- It reloads everything. For taxi data it reloads one year, set by parameter `year` (default 2025).
- No incremental load. The period is fixed to 2023-2025, and TLC publishes data with a 2-month lag.
- Dataflow `openaq` failed in 4 of 6 runs with a generic error. The pipeline retries it twice, 5 minutes apart.
- Nothing runs while capacity `kamola0708` is paused.
- Run history is in the pipeline run list in Fabric. No failure alerts are set up.

## Access

- Workspace `itransition coursework` has one user with the Admin role.
- Reports read only Gold, through semantic model `air_taxi_model`.
- No row-level security. The data is aggregated open data.
- No personal data. Trips have no passenger or driver details.

## Keys and secrets

- The OpenAQ API key is stored only in Dataflow `openaq`.
- No keys or passwords in code or docs.
- TLC, ECB, World Bank and the OpenAQ archive need no key.

## Known limitations

- OpenAQ API returns no data for about 44 days in early 2023. 24 of them were filled from the OpenAQ archive. 20 days (12-14 Jan, 24 Feb - 12 Mar 2023) are missing in the archive too.
- PM2.5 is available for 1,076 of 1,096 days, NO2 for 1,075.
- On filled days only 8-14 of 17 stations report.
- NO2 comes from 4 stations in New Jersey only.
- Stations are not mapped to taxi zones. Air values are city averages.
- Queens Near-road reports PM2.5 only until 7 Sep 2023.
- The last 5 hours of 31 Dec 2025 have no air data.
- TLC has almost no trips on 21-24 Sep 2023.
- 12.3% of trips have no passenger count.
- `FactCityHourly` has no 02:00 row on the three spring DST days (12 Mar 2023, 10 Mar 2024, 9 Mar 2025).
- GDP is yearly and covers the whole US.

## Not done

- Purview lineage and sensitivity labels.
- Row-level security.
- Failure alerts.
- Stopping the pipeline when a Gold check fails.
