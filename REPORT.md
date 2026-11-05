# GOES fog POC — running report

Updated 2026-11-05T21:29+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 10688 |
| agreement | 0.8222305389221557 |
| station_disagreements | 99 |
| goes_right_share | 0.47474747474747475 |
| om_right_share | 0.5252525252525253 |
| median_latency_min | 1.9916666666666667 |
| median_delivery_min | 94.8 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 75, "om": 75} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
