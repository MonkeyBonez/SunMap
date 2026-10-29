# GOES fog POC — running report

Updated 2026-10-29T20:21+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 12096 |
| agreement | 0.8171296296296297 |
| station_disagreements | 125 |
| goes_right_share | 0.568 |
| om_right_share | 0.432 |
| median_latency_min | 1.9 |
| median_delivery_min | 97.2 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 75, "om": 75} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
