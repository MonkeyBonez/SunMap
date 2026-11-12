# GOES fog POC — running report

Updated 2026-11-12T21:51+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 8896 |
| agreement | 0.7704586330935251 |
| station_disagreements | 100 |
| goes_right_share | 0.37 |
| om_right_share | 0.63 |
| median_latency_min | 1.9916666666666667 |
| median_delivery_min | 98.1 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 135, "om": 135} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
