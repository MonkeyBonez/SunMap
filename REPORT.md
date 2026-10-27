# GOES fog POC — running report

Updated 2026-10-27T06:24+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 14 |
| cell_times | 11808 |
| agreement | 0.8479844173441734 |
| station_disagreements | 115 |
| goes_right_share | 0.5478260869565217 |
| om_right_share | 0.45217391304347826 |
| median_latency_min | 1.8333333333333333 |
| median_delivery_min | 98.4 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 75, "om": 75} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
