# GOES fog POC — running report

Updated 2026-10-18T23:21+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 10656 |
| agreement | 0.8606418918918919 |
| station_disagreements | 79 |
| goes_right_share | 0.6582278481012658 |
| om_right_share | 0.34177215189873417 |
| median_latency_min | 1.6833333333333333 |
| median_delivery_min | 98.9 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": null, "om": 15} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
