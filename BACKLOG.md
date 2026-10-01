# Backlog

Things we have decided to do later, with enough context to pick them up cold.
Newest at the bottom. Move an item to `LEARNINGS.md` when it is done and taught us something.

## Fog from satellite, not forecast — GOES job build-out (POC running)

**Status:** the proof of concept is built and logging (`Pipeline/goes_poc.py`,
`goes_log.py` hourly in GitHub Actions (`goes-log` branch) and every 15 min on the Mac via
`Pipeline/launchd/com.sunmap.goes-log.plist`,
`goes_report.py`; LEARNINGS §9.6). Build the job only if, after ≥ 10 days of daytime
logs, GOES is right in ≥ 70 % of its disagreements with the forecast at SFO/OAK and the
median latency is ≤ 15 min (`goes_report.py` prints the decision).

**What the build-out is:** a scheduled job (GitHub Actions cron at 30 min fits the free
2,000 min/month; a 10-min cadence needs the Mac or a €4 VPS) runs `goes_poc.observe()` and
writes `sky/goes/<city>.json` (the `--json` output) next to the tiles on the static host;
`WeatherService` gains a `SkySource.observed` that wins for |now − t| ≤ 20 min, HRRR keeps
scrubbed future times; Sun Map's status says "Fog (satellite, 9:50)". The JSON is
documented in README as a public, best-effort endpoint (attribution, no uptime promise).

**Trigger:** the POC verdict. **Effort:** 1 day after the verdict.

## Tree canopy

Moorpark's dominant midday error is trees, not houses or hills (LEARNINGS §3.7). NLCD
Tree Canopy Cover (30 m, US-only) as a per-edge shade factor is the cheap first step;
LiDAR-derived canopy height where a city publishes it is the real one.

## Go live on Cloudflare (owner's step; everything is ready)

`publish.py --target pages` after `npx wrangler login`; the Worker (`Worker/`) after creating
its KV namespace; then build the app with `SUNMAP_BUNDLE_BASE_URL` (and
`SUNMAP_COVERAGE_REQUEST_URL`). README "Hosting" has the commands; all of it is tested locally.
**Trigger:** the owner wants a second phone (or a tester) to download tiles.

## Open-Meteo proxy before scale

**Status:** written and off — the Worker's `/sky` (15-min shared cache, optional paid key)
answers 404 until `SKY_PROXY=on`. The app still calls Open-Meteo directly; switching them
to the proxy is a `WeatherService` URL change.

Nine points per request against the 10k-points/day free tier is ~1,100 requests/day: fine
for one user, not for a thousand. A caching proxy (one fetch per lattice cell per 30 min,
shared by everyone) or a paid key is needed before any public release.

## Non-US metros

Nothing is US-bound: terrain abroad is ~30 m, no sidewalk surveys or
canopy (synthesis defaults), 15-min DNI only from HRRR (N. America) and ICON-D2/AROME
(central Europe), GOES covers the Americas only. **First candidate:** Toronto (HRDPS
2.5 km). **Trigger:** owner decision. **Effort:** one `metros.yaml` entry + a build.

## Scheduled rebuilds for freshness

OSM changes daily, Overture monthly. Pinned builds (`buildKey`) make a rebuild safe to roll
out. **Trigger:** a user-reported stale street. **Effort:** a cron entry over
`build_places.py --rebuild`.

## Fully automatic build-on-request

Today a human approves each `metros.yaml` entry produced by `requests_to_places.py`.
**Trigger:** the wish-list outgrows nightly review. **Effort:** ~1 day (thresholds,
Nominatim → place, auto-append, budget guard).

## Stable node ids (bundle v4)

Node ids are row numbers of one build, so tiles from two builds can't be mixed (C5 pins
builds instead). Stable ids (hash of rounded coordinates + way id) would allow per-tile
incremental rebuilds. **Trigger:** rebuild time or download size becomes the problem.

## Sun by block: sky per cell, shadows across tile borders

The zoomed-out field reads the beam once at the screen centre (9 forecast cells ≈ 7 km),
so a 40 km Bay view fades uniformly even when the fog line is inside it; and each metro
tile is scored from its own buildings only (LEARNINGS §13: 1.5 % of 70 m blocks change
band at the border). **What:** sample the forecast field per cell (needs a wider lattice
fetch — more Open-Meteo calls; the owner's rate-limit lever), and give the tile-alone
scorer a 300 m strip of the neighbours' buildings. **Trigger:** a visible fog line or seam
in the block view on a real walk. **Effort:** ½ day each.

## GOES cloud-top height at 2 km

`ABI-L2-ACHAC` is 10 km, so the "low vs mid/high" class is one pixel for ~16 lattice cells
and `top is None` with a liquid phase reads as mid/high. The 2 km `ACHA2KC` product isn't
on the public bucket today; check again before the build-out, else derive "low" from the
11 µm brightness temperature in `CMIPC` C14 (fog is warm). **Trigger:** the POC verdict.

## Sun-only bundle diet

The pipeline still builds for routing (it came from Like Water). For Sun Map three of its
choices cost something: (1) `--min-component` / largest-component pruning drops small
connected pieces, and with them sidewalks we could have painted (a plaza, a stranded
synthesised kerb); (2) interest scoring (`interest()`, OSM interest points) costs build
time and one byte per edge the app never reads; (3) tiles are cut only where there are
edges, so buildings in an edge-free tile (a park edge, a waterfront) are dropped and can't
shade into the neighbour. **What:** a `--sun` profile in `build_metro.py` that keeps every
component, skips interest (write zeros, the format stays v3), and keeps building-only
tiles. **Trigger:** the next full rebuild of the metros (no format change, but every tile
changes, so do it once). **Effort:** ½ day + rebuild time (~1 h for the six metros).
