# GOES fog POC — running report

Updated 2026-11-26T23:54+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 16 |
| cell_times | 5472 |
| agreement | 0.6814692982456141 |
| station_disagreements | 97 |
| goes_right_share | 0.4020618556701031 |
| om_right_share | 0.5979381443298969 |
| median_latency_min | 2.0166666666666666 |
| median_delivery_min | 104.1 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 90, "om": 30} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
