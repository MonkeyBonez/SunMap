# GOES fog POC — running report

Updated 2026-10-05T01:03+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 4 |
| cell_times | 3104 |
| agreement | 0.6014819587628866 |
| station_disagreements | 45 |
| goes_right_share | 0.2222222222222222 |
| om_right_share | 0.7777777777777778 |
| median_latency_min | 1.8666666666666667 |
| median_delivery_min | 100.3 |
| fog_mornings | 3 |
| burnoff_error_min | {"goes": 90.0, "om": 15} |
| decision | "do not build (forecast is good enough)" |

only 4 daytime days logged; the decision needs ≥ 10

Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
