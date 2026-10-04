# GOES fog POC — running report

Updated 2026-10-04T07:01+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 3 |
| cell_times | 2208 |
| agreement | 0.6802536231884058 |
| station_disagreements | 29 |
| goes_right_share | 0.2413793103448276 |
| om_right_share | 0.7586206896551724 |
| median_latency_min | 1.9333333333333333 |
| median_delivery_min | 100.3 |
| fog_mornings | 2 |
| burnoff_error_min | {"goes": 90.0, "om": 90.0} |
| decision | "do not build (forecast is good enough)" |

only 3 daytime days logged; the decision needs ≥ 10

Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
