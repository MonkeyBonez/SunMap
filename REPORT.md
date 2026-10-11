# GOES fog POC — running report

Updated 2026-10-11T01:58+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 10 |
| cell_times | 6880 |
| agreement | 0.7215116279069768 |
| station_disagreements | 85 |
| goes_right_share | 0.47058823529411764 |
| om_right_share | 0.5294117647058824 |
| median_latency_min | 1.7666666666666666 |
| median_delivery_min | 102.3 |
| fog_mornings | 3 |
| burnoff_error_min | {"goes": 90.0, "om": 15} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
