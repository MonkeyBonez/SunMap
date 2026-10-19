# GOES fog POC — running report

Updated 2026-10-19T06:21+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 14 |
| cell_times | 9856 |
| agreement | 0.8994521103896104 |
| station_disagreements | 63 |
| goes_right_share | 0.7777777777777778 |
| om_right_share | 0.2222222222222222 |
| median_latency_min | 1.6833333333333333 |
| median_delivery_min | 99.4 |
| fog_mornings | 0 |
| burnoff_error_min | {"goes": null, "om": null} |
| decision | "build the GOES job" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
