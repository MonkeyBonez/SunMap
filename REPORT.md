# GOES fog POC — running report

Updated 2026-10-18T18:12+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 15 |
| cell_times | 9984 |
| agreement | 0.8697916666666666 |
| station_disagreements | 68 |
| goes_right_share | 0.6029411764705882 |
| om_right_share | 0.39705882352941174 |
| median_latency_min | 1.7 |
| median_delivery_min | 99.4 |
| fog_mornings | 1 |
| burnoff_error_min | {"goes": null, "om": 15} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
