# GOES fog POC — running report

Updated 2026-10-24T20:57+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 11712 |
| agreement | 0.8627903005464481 |
| station_disagreements | 110 |
| goes_right_share | 0.5636363636363636 |
| om_right_share | 0.43636363636363634 |
| median_latency_min | 1.7333333333333334 |
| median_delivery_min | 99.5 |
| fog_mornings | 0 |
| burnoff_error_min | {"goes": null, "om": null} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
