# GOES fog POC — running report

Updated 2026-11-03T03:57+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 14 |
| cell_times | 10752 |
| agreement | 0.7911086309523809 |
| station_disagreements | 120 |
| goes_right_share | 0.39166666666666666 |
| om_right_share | 0.6083333333333333 |
| median_latency_min | 1.9666666666666666 |
| median_delivery_min | 97.7 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 75, "om": 75} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
