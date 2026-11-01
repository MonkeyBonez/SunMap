# GOES fog POC — running report

Updated 2026-11-01T02:19+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 14 |
| cell_times | 11392 |
| agreement | 0.7506144662921348 |
| station_disagreements | 159 |
| goes_right_share | 0.5031446540880503 |
| om_right_share | 0.4968553459119497 |
| median_latency_min | 1.9333333333333333 |
| median_delivery_min | 97.1 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 75, "om": 75} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
