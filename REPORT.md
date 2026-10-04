# GOES fog POC — running report

Updated 2026-10-04T18:40+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 4 |
| cell_times | 2528 |
| agreement | 0.6313291139240507 |
| station_disagreements | 35 |
| goes_right_share | 0.2571428571428571 |
| om_right_share | 0.7428571428571429 |
| median_latency_min | 1.8833333333333333 |
| median_delivery_min | 99.2 |
| fog_mornings | 2 |
| burnoff_error_min | {"goes": 90.0, "om": 90.0} |
| decision | "do not build (forecast is good enough)" |

only 4 daytime days logged; the decision needs ≥ 10

Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
