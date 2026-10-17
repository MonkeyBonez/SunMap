# GOES fog POC — running report

Updated 2026-10-17T20:43+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 10208 |
| agreement | 0.8809757053291536 |
| station_disagreements | 57 |
| goes_right_share | 0.5964912280701754 |
| om_right_share | 0.40350877192982454 |
| median_latency_min | 1.7333333333333334 |
| median_delivery_min | 100.0 |
| fog_mornings | 2 |
| burnoff_error_min | {"goes": 0, "om": 7.5} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
