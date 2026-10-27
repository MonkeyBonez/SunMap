# GOES fog POC — running report

Updated 2026-10-27T23:50+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 12512 |
| agreement | 0.8396739130434783 |
| station_disagreements | 122 |
| goes_right_share | 0.5737704918032787 |
| om_right_share | 0.4262295081967213 |
| median_latency_min | 1.8333333333333333 |
| median_delivery_min | 98.3 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 75, "om": 75} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
