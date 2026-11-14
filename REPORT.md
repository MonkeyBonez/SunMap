# GOES fog POC — running report

Updated 2026-11-14T19:58+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 8544 |
| agreement | 0.7734082397003745 |
| station_disagreements | 94 |
| goes_right_share | 0.3191489361702128 |
| om_right_share | 0.6808510638297872 |
| median_latency_min | 1.9666666666666666 |
| median_delivery_min | 100.8 |
| fog_mornings | 2 |
| burnoff_error_min | {"goes": 112.5, "om": 82.5} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
