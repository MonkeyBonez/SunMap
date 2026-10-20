# GOES fog POC — running report

Updated 2026-10-20T00:26+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 14 |
| cell_times | 10112 |
| agreement | 0.8777689873417721 |
| station_disagreements | 80 |
| goes_right_share | 0.8 |
| om_right_share | 0.2 |
| median_latency_min | 1.6833333333333333 |
| median_delivery_min | 98.4 |
| fog_mornings | 0 |
| burnoff_error_min | {"goes": null, "om": null} |
| decision | "build the GOES job" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
