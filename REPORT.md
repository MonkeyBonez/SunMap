# GOES fog POC — running report

Updated 2026-11-11T22:02+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 9152 |
| agreement | 0.7908653846153846 |
| station_disagreements | 89 |
| goes_right_share | 0.3707865168539326 |
| om_right_share | 0.6292134831460674 |
| median_latency_min | 2.0166666666666666 |
| median_delivery_min | 96.8 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 135, "om": 135} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
