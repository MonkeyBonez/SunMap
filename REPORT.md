# GOES fog POC — running report

Updated 2026-10-19T20:38+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 10208 |
| agreement | 0.893123040752351 |
| station_disagreements | 71 |
| goes_right_share | 0.7887323943661971 |
| om_right_share | 0.2112676056338028 |
| median_latency_min | 1.6833333333333333 |
| median_delivery_min | 98.9 |
| fog_mornings | 0 |
| burnoff_error_min | {"goes": null, "om": null} |
| decision | "build the GOES job" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
