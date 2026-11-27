# GOES fog POC — running report

Updated 2026-11-27T23:31+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 16 |
| cell_times | 5344 |
| agreement | 0.7080838323353293 |
| station_disagreements | 89 |
| goes_right_share | 0.39325842696629215 |
| om_right_share | 0.6067415730337079 |
| median_latency_min | 2.0166666666666666 |
| median_delivery_min | 101.3 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 90, "om": 30} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
