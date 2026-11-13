# GOES fog POC — running report

Updated 2026-11-13T21:28+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 8704 |
| agreement | 0.7813648897058824 |
| station_disagreements | 102 |
| goes_right_share | 0.35294117647058826 |
| om_right_share | 0.6470588235294118 |
| median_latency_min | 2.0 |
| median_delivery_min | 99.5 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 135, "om": 135} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
