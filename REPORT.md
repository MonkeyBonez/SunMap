# GOES fog POC — running report

Updated 2026-10-20T22:26+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 10816 |
| agreement | 0.8446745562130178 |
| station_disagreements | 105 |
| goes_right_share | 0.6190476190476191 |
| om_right_share | 0.38095238095238093 |
| median_latency_min | 1.6833333333333333 |
| median_delivery_min | 98.0 |
| fog_mornings | 0 |
| burnoff_error_min | {"goes": null, "om": null} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
