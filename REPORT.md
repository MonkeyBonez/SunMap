# GOES fog POC — running report

Updated 2026-10-22T01:36+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 14 |
| cell_times | 10560 |
| agreement | 0.850284090909091 |
| station_disagreements | 113 |
| goes_right_share | 0.5929203539823009 |
| om_right_share | 0.40707964601769914 |
| median_latency_min | 1.6833333333333333 |
| median_delivery_min | 99.7 |
| fog_mornings | 0 |
| burnoff_error_min | {"goes": null, "om": null} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
