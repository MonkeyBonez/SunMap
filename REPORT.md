# GOES fog POC — running report

Updated 2026-10-18T01:10+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 14 |
| cell_times | 9728 |
| agreement | 0.8751027960526315 |
| station_disagreements | 57 |
| goes_right_share | 0.5964912280701754 |
| om_right_share | 0.40350877192982454 |
| median_latency_min | 1.7 |
| median_delivery_min | 99.8 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": null, "om": 15} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
