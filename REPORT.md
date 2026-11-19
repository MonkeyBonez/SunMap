# GOES fog POC — running report

Updated 2026-11-19T22:42+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 16 |
| cell_times | 6944 |
| agreement | 0.7548963133640553 |
| station_disagreements | 83 |
| goes_right_share | 0.42168674698795183 |
| om_right_share | 0.5783132530120482 |
| median_latency_min | 2.0083333333333333 |
| median_delivery_min | 99.8 |
| fog_mornings | 2 |
| burnoff_error_min | {"goes": 112.5, "om": 82.5} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
