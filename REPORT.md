# GOES fog POC — running report

Updated 2026-11-04T21:21+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 10912 |
| agreement | 0.8355938416422287 |
| station_disagreements | 95 |
| goes_right_share | 0.47368421052631576 |
| om_right_share | 0.5263157894736842 |
| median_latency_min | 1.9666666666666666 |
| median_delivery_min | 97.0 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 75, "om": 75} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
