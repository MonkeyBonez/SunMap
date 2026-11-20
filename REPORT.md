# GOES fog POC — running report

Updated 2026-11-20T04:02+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 6432 |
| agreement | 0.752021144278607 |
| station_disagreements | 77 |
| goes_right_share | 0.4155844155844156 |
| om_right_share | 0.5844155844155844 |
| median_latency_min | 2.0166666666666666 |
| median_delivery_min | 100.2 |
| fog_mornings | 2 |
| burnoff_error_min | {"goes": 112.5, "om": 82.5} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
