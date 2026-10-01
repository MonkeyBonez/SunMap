# GOES fog POC — running report

Updated 2026-10-01T06:14+00:00. Daytime (9 am–5 pm Pacific) scans only.

| metric | value |
|---|---|
| days | 0 |
| cell_times | 0 |
| agreement | null |
| station_disagreements | 0 |
| goes_right_share | null |
| om_right_share | null |
| median_latency_min | null |
| fog_mornings | 0 |
| burnoff_error_min | {"goes": null, "om": null} |
| decision | "insufficient data" |

only 0 daytime days logged; the decision needs ≥ 10

Decision rule: build the GOES job if GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the median latency is ≤ 15 min (PLAN.md §2 E).
