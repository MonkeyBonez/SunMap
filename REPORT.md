# GOES fog POC — running report

Updated 2026-10-02T23:51+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 2 |
| cell_times | 1280 |
| agreement | 0.4484375 |
| station_disagreements | 29 |
| goes_right_share | 0.2413793103448276 |
| om_right_share | 0.7586206896551724 |
| median_latency_min | 1.9666666666666666 |
| median_delivery_min | 103.8 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 180, "om": 180} |
| decision | "do not build (forecast is good enough)" |

only 2 daytime days logged; the decision needs ≥ 10

Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
