# GOES fog POC — running report

Updated 2026-11-24T02:19+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 14 |
| cell_times | 5440 |
| agreement | 0.7729779411764706 |
| station_disagreements | 74 |
| goes_right_share | 0.36486486486486486 |
| om_right_share | 0.6351351351351351 |
| median_latency_min | 2.0166666666666666 |
| median_delivery_min | 103.3 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 90, "om": 30} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
