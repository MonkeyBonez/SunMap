# GOES fog POC — running report

Updated 2026-10-01T16:34+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 1 |
| cell_times | 64 |
| agreement | 0.890625 |
| station_disagreements | 3 |
| goes_right_share | 0.0 |
| om_right_share | 1.0 |
| median_latency_min | 2.316666666666667 |
| median_delivery_min | 23.3 |
| fog_mornings | 0 |
| burnoff_error_min | {"goes": null, "om": null} |
| decision | "do not build (forecast is good enough)" |

only 1 daytime days logged; the decision needs ≥ 10

Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
