# GOES fog POC — running report

Updated 2026-10-30T05:58+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 14 |
| cell_times | 11552 |
| agreement | 0.7953601108033241 |
| station_disagreements | 127 |
| goes_right_share | 0.5590551181102362 |
| om_right_share | 0.4409448818897638 |
| median_latency_min | 1.9 |
| median_delivery_min | 95.7 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 75, "om": 75} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
