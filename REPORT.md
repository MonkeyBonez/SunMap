# GOES fog POC — running report

Updated 2026-10-25T01:19+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 14 |
| cell_times | 11296 |
| agreement | 0.8713703966005666 |
| station_disagreements | 98 |
| goes_right_share | 0.5714285714285714 |
| om_right_share | 0.42857142857142855 |
| median_latency_min | 1.7666666666666666 |
| median_delivery_min | 98.9 |
| fog_mornings | 0 |
| burnoff_error_min | {"goes": null, "om": null} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
