# GOES fog POC — running report

Updated 2026-10-01T21:52+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 1 |
| cell_times | 416 |
| agreement | 0.7932692307692307 |
| station_disagreements | 3 |
| goes_right_share | 0.0 |
| om_right_share | 1.0 |
| median_latency_min | 2.033333333333333 |
| median_delivery_min | 78.1 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 180, "om": 180} |
| decision | "do not build (forecast is good enough)" |

only 1 daytime days logged; the decision needs ≥ 10

Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
