# GOES fog POC — running report

Updated 2026-11-22T01:26+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 14 |
| cell_times | 5664 |
| agreement | 0.72704802259887 |
| station_disagreements | 85 |
| goes_right_share | 0.43529411764705883 |
| om_right_share | 0.5647058823529412 |
| median_latency_min | 1.9666666666666666 |
| median_delivery_min | 100.5 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 90, "om": 30} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
