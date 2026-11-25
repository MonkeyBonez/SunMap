# GOES fog POC — running report

Updated 2026-11-25T08:48+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 5248 |
| agreement | 0.7399009146341463 |
| station_disagreements | 77 |
| goes_right_share | 0.35064935064935066 |
| om_right_share | 0.6493506493506493 |
| median_latency_min | 2.05 |
| median_delivery_min | 101.9 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 90, "om": 30} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
