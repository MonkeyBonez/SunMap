# GOES fog POC — running report

Updated 2026-10-29T05:58+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 14 |
| cell_times | 11744 |
| agreement | 0.8197377384196185 |
| station_disagreements | 122 |
| goes_right_share | 0.5737704918032787 |
| om_right_share | 0.4262295081967213 |
| median_latency_min | 1.8833333333333333 |
| median_delivery_min | 97.3 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 75, "om": 75} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
