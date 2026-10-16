# GOES fog POC — running report

Updated 2026-10-16T22:08+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 10432 |
| agreement | 0.8285084355828221 |
| station_disagreements | 83 |
| goes_right_share | 0.4939759036144578 |
| om_right_share | 0.5060240963855421 |
| median_latency_min | 1.7333333333333334 |
| median_delivery_min | 100.4 |
| fog_mornings | 2 |
| burnoff_error_min | {"goes": 0, "om": 7.5} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
