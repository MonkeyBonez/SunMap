# GOES fog POC — running report

Updated 2026-10-23T22:21+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 11584 |
| agreement | 0.8442679558011049 |
| station_disagreements | 138 |
| goes_right_share | 0.6231884057971014 |
| om_right_share | 0.37681159420289856 |
| median_latency_min | 1.7166666666666666 |
| median_delivery_min | 99.5 |
| fog_mornings | 0 |
| burnoff_error_min | {"goes": null, "om": null} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
