# GOES fog POC — running report

Updated 2026-11-20T22:15+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 16 |
| cell_times | 6784 |
| agreement | 0.7455778301886793 |
| station_disagreements | 82 |
| goes_right_share | 0.4268292682926829 |
| om_right_share | 0.573170731707317 |
| median_latency_min | 2.0 |
| median_delivery_min | 100.1 |
| fog_mornings | 2 |
| burnoff_error_min | {"goes": 112.5, "om": 82.5} |
| decision | "do not build (forecast is good enough)" |



Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min.
