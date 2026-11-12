# GOES fog POC — running report

Updated 2026-11-12T03:08+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 14 |
| cell_times | 8544 |
| agreement | 0.7889747191011236 |
| station_disagreements | 89 |
| goes_right_share | 0.3707865168539326 |
| om_right_share | 0.6292134831460674 |
| median_latency_min | 2.0 |
| median_delivery_min | 98.3 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 135, "om": 135} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
