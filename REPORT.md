# GOES fog POC — running report

Updated 2026-10-27T20:08+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 12160 |
| agreement | 0.8411184210526316 |
| station_disagreements | 117 |
| goes_right_share | 0.5555555555555556 |
| om_right_share | 0.4444444444444444 |
| median_latency_min | 1.8333333333333333 |
| median_delivery_min | 98.3 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 75, "om": 75} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
