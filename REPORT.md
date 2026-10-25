# GOES fog POC — running report

Updated 2026-10-25T21:53+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 11936 |
| agreement | 0.8643599195710456 |
| station_disagreements | 104 |
| goes_right_share | 0.5480769230769231 |
| om_right_share | 0.4519230769230769 |
| median_latency_min | 1.7833333333333334 |
| median_delivery_min | 98.3 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 75, "om": 75} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
