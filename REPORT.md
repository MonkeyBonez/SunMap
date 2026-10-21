# GOES fog POC — running report

Updated 2026-10-21T19:21+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 10624 |
| agreement | 0.8438441265060241 |
| station_disagreements | 112 |
| goes_right_share | 0.5892857142857143 |
| om_right_share | 0.4107142857142857 |
| median_latency_min | 1.6833333333333333 |
| median_delivery_min | 99.4 |
| fog_mornings | 0 |
| burnoff_error_min | {"goes": null, "om": null} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
