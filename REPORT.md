# GOES fog POC — running report

Updated 2026-10-23T19:20+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 11232 |
| agreement | 0.8425035612535613 |
| station_disagreements | 125 |
| goes_right_share | 0.608 |
| om_right_share | 0.392 |
| median_latency_min | 1.7166666666666666 |
| median_delivery_min | 99.6 |
| fog_mornings | 0 |
| burnoff_error_min | {"goes": null, "om": null} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
