# GOES fog POC — running report

Updated 2026-10-26T00:28+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 14 |
| cell_times | 11520 |
| agreement | 0.8449652777777777 |
| station_disagreements | 113 |
| goes_right_share | 0.5398230088495575 |
| om_right_share | 0.46017699115044247 |
| median_latency_min | 1.8 |
| median_delivery_min | 98.3 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 75, "om": 75} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
