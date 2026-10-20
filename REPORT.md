# GOES fog POC — running report

Updated 2026-10-20T19:22+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 10464 |
| agreement | 0.8615252293577982 |
| station_disagreements | 89 |
| goes_right_share | 0.7303370786516854 |
| om_right_share | 0.2696629213483146 |
| median_latency_min | 1.6833333333333333 |
| median_delivery_min | 98.2 |
| fog_mornings | 0 |
| burnoff_error_min | {"goes": null, "om": null} |
| decision | "build the GOES job" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
