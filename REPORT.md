# GOES fog POC — running report

Updated 2026-10-30T23:53+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 12256 |
| agreement | 0.7923466057441253 |
| station_disagreements | 142 |
| goes_right_share | 0.5492957746478874 |
| om_right_share | 0.4507042253521127 |
| median_latency_min | 1.9166666666666667 |
| median_delivery_min | 95.7 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": 75, "om": 75} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
