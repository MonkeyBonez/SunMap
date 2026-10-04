# GOES fog POC — running report

Updated 2026-10-04T22:22+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 4 |
| cell_times | 2880 |
| agreement | 0.6013888888888889 |
| station_disagreements | 43 |
| goes_right_share | 0.23255813953488372 |
| om_right_share | 0.7674418604651163 |
| median_latency_min | 1.8833333333333333 |
| median_delivery_min | 98.1 |
| fog_mornings | 3 |
| burnoff_error_min | {"goes": 90.0, "om": 15} |
| decision | "do not build (forecast is good enough)" |

only 4 daytime days logged; the decision needs ≥ 10

Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
