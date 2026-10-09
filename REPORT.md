# GOES fog POC — running report

Updated 2026-10-09T20:09+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 9 |
| cell_times | 5696 |
| agreement | 0.7033005617977528 |
| station_disagreements | 64 |
| goes_right_share | 0.390625 |
| om_right_share | 0.609375 |
| median_latency_min | 1.8083333333333333 |
| median_delivery_min | 101.5 |
| fog_mornings | 3 |
| burnoff_error_min | {"goes": 90.0, "om": 15} |
| decision | "do not build (forecast is good enough)" |

only 9 daytime days logged; the decision needs ≥ 10

Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
