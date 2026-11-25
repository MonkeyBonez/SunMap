# GOES fog POC — running report

Updated 2026-11-25T23:41+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 16 |
| cell_times | 5600 |
| agreement | 0.7303571428571428 |
| station_disagreements | 85 |
| goes_right_share | 0.32941176470588235 |
| om_right_share | 0.6705882352941176 |
| median_latency_min | 2.025 |
| median_delivery_min | 101.3 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 90, "om": 30} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
