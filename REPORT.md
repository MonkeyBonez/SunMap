# GOES fog POC — running report

Updated 2026-10-25T18:27+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 11584 |
| agreement | 0.8655041436464088 |
| station_disagreements | 100 |
| goes_right_share | 0.56 |
| om_right_share | 0.44 |
| median_latency_min | 1.7666666666666666 |
| median_delivery_min | 98.3 |
| fog_mornings | 0 |
| burnoff_error_min | {"goes": null, "om": null} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
