# GOES fog POC — running report

Updated 2026-11-07T00:58+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 14 |
| cell_times | 9760 |
| agreement | 0.8144467213114754 |
| station_disagreements | 81 |
| goes_right_share | 0.345679012345679 |
| om_right_share | 0.654320987654321 |
| median_latency_min | 2.0 |
| median_delivery_min | 97.0 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 75, "om": 75} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
