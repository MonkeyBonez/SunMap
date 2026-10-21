# GOES fog POC — running report

Updated 2026-10-21T01:41+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 14 |
| cell_times | 10272 |
| agreement | 0.8396612149532711 |
| station_disagreements | 111 |
| goes_right_share | 0.5945945945945946 |
| om_right_share | 0.40540540540540543 |
| median_latency_min | 1.6666666666666667 |
| median_delivery_min | 99.6 |
| fog_mornings | 0 |
| burnoff_error_min | {"goes": null, "om": null} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
