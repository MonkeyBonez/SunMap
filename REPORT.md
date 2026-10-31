# GOES fog POC — running report

Updated 2026-10-31T19:22+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 11648 |
| agreement | 0.7712912087912088 |
| station_disagreements | 149 |
| goes_right_share | 0.5369127516778524 |
| om_right_share | 0.46308724832214765 |
| median_latency_min | 1.9333333333333333 |
| median_delivery_min | 96.5 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 75, "om": 75} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
