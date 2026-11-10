# GOES fog POC — running report

Updated 2026-11-10T07:28+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 14 |
| cell_times | 8832 |
| agreement | 0.7603034420289855 |
| station_disagreements | 94 |
| goes_right_share | 0.40425531914893614 |
| om_right_share | 0.5957446808510638 |
| median_latency_min | 2.0166666666666666 |
| median_delivery_min | 96.8 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 135, "om": 135} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
