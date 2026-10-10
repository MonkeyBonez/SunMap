# GOES fog POC — running report

Updated 2026-10-10T22:40+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 10 |
| cell_times | 6752 |
| agreement | 0.7169727488151659 |
| station_disagreements | 85 |
| goes_right_share | 0.47058823529411764 |
| om_right_share | 0.5294117647058824 |
| median_latency_min | 1.7833333333333334 |
| median_delivery_min | 100.3 |
| fog_mornings | 3 |
| burnoff_error_min | {"goes": 90.0, "om": 15} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
