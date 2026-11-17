# GOES fog POC — running report

Updated 2026-11-17T08:04+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 14 |
| cell_times | 7424 |
| agreement | 0.7687230603448276 |
| station_disagreements | 87 |
| goes_right_share | 0.3793103448275862 |
| om_right_share | 0.6206896551724138 |
| median_latency_min | 2.0 |
| median_delivery_min | 100.6 |
| fog_mornings | 2 |
| burnoff_error_min | {"goes": 112.5, "om": 82.5} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
