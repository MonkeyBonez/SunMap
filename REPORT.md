# GOES fog POC — running report

Updated 2026-10-15T01:33+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 14 |
| cell_times | 9408 |
| agreement | 0.795812074829932 |
| station_disagreements | 86 |
| goes_right_share | 0.47674418604651164 |
| om_right_share | 0.5232558139534884 |
| median_latency_min | 1.7333333333333334 |
| median_delivery_min | 100.6 |
| fog_mornings | 3 |
| burnoff_error_min | {"goes": 90.0, "om": 15} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
