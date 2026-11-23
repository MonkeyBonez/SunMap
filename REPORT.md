# GOES fog POC — running report

Updated 2026-11-23T01:49+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 14 |
| cell_times | 5600 |
| agreement | 0.7832142857142858 |
| station_disagreements | 76 |
| goes_right_share | 0.42105263157894735 |
| om_right_share | 0.5789473684210527 |
| median_latency_min | 2.0083333333333333 |
| median_delivery_min | 101.3 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 90, "om": 30} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
