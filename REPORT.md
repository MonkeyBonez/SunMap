# GOES fog POC — running report

Updated 2026-11-14T02:29+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 14 |
| cell_times | 8192 |
| agreement | 0.784423828125 |
| station_disagreements | 88 |
| goes_right_share | 0.3409090909090909 |
| om_right_share | 0.6590909090909091 |
| median_latency_min | 1.975 |
| median_delivery_min | 101.0 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 135, "om": 135} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
