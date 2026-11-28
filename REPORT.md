# GOES fog POC — running report

Updated 2026-11-28T08:00+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 4800 |
| agreement | 0.6933333333333334 |
| station_disagreements | 83 |
| goes_right_share | 0.40963855421686746 |
| om_right_share | 0.5903614457831325 |
| median_latency_min | 2.0166666666666666 |
| median_delivery_min | 99.2 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 90, "om": 30} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
