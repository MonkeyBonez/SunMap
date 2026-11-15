# GOES fog POC — running report

Updated 2026-11-15T06:45+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 14 |
| cell_times | 8128 |
| agreement | 0.7890009842519685 |
| station_disagreements | 85 |
| goes_right_share | 0.38823529411764707 |
| om_right_share | 0.611764705882353 |
| median_latency_min | 1.9666666666666666 |
| median_delivery_min | 100.6 |
| fog_mornings | 2 |
| burnoff_error_min | {"goes": 112.5, "om": 82.5} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
