# GOES fog POC — running report

Updated 2026-10-02T19:59+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 2 |
| cell_times | 928 |
| agreement | 0.5344827586206896 |
| station_disagreements | 17 |
| goes_right_share | 0.4117647058823529 |
| om_right_share | 0.5882352941176471 |
| median_latency_min | 1.9833333333333334 |
| median_delivery_min | 108.0 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 180, "om": 180} |
| decision | "do not build (forecast is good enough)" |

only 2 daytime days logged; the decision needs ≥ 10

Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
