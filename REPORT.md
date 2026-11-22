# GOES fog POC — running report

Updated 2026-11-22T21:06+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 6016 |
| agreement | 0.7423537234042553 |
| station_disagreements | 86 |
| goes_right_share | 0.43023255813953487 |
| om_right_share | 0.5697674418604651 |
| median_latency_min | 2.0 |
| median_delivery_min | 100.4 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 90, "om": 30} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
