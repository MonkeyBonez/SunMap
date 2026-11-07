# GOES fog POC — running report

Updated 2026-11-07T23:40+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 10400 |
| agreement | 0.8173076923076923 |
| station_disagreements | 84 |
| goes_right_share | 0.35714285714285715 |
| om_right_share | 0.6428571428571429 |
| median_latency_min | 2.0166666666666666 |
| median_delivery_min | 96.6 |
| fog_mornings | 2 |
| burnoff_error_min | {"goes": 105.0, "om": 105.0} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
