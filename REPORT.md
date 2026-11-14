# GOES fog POC — running report

Updated 2026-11-14T23:58+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 8896 |
| agreement | 0.773943345323741 |
| station_disagreements | 102 |
| goes_right_share | 0.3431372549019608 |
| om_right_share | 0.6568627450980392 |
| median_latency_min | 1.9583333333333333 |
| median_delivery_min | 100.6 |
| fog_mornings | 2 |
| burnoff_error_min | {"goes": 112.5, "om": 82.5} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
