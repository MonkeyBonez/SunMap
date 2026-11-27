# GOES fog POC — running report

Updated 2026-11-27T08:45+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 4992 |
| agreement | 0.7035256410256411 |
| station_disagreements | 84 |
| goes_right_share | 0.4166666666666667 |
| om_right_share | 0.5833333333333334 |
| median_latency_min | 2.0166666666666666 |
| median_delivery_min | 101.9 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 90, "om": 30} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
