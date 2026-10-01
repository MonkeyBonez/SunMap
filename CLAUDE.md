# Sun Map

iOS app that colours the sidewalks around you by sun, at any zoom, with the live sky.
One app target (`SunMap`), one Swift engine (`Engine/`, the SwiftPM package
`SunMapEngine`), and per-city binary bundles / tiled metros built by the Python pipeline
in `Pipeline/`. `Worker/` is the small Cloudflare Worker for "Request this area".
See `README.md` for architecture and how to run.

Split on 2026-10-01 from `MonkeyBonez/LikeWater` (tag `sunmap-split`), where the route,
ETA and corridor work is parked. Sun Map is the main line of work.

## Keep `LEARNINGS.md` current

`LEARNINGS.md` is the running record of what we have learned building this — data-source
verdicts, measured effects, wrong assumptions we had to unlearn, and the process we ended
up needing beyond "download OSM". It covers three single cities (San Francisco, Berkeley,
Moorpark), the weather layer (§9), the tiled metros (§10), loading anywhere (§12) and the
whole-screen sun field (§13).

**Whenever you learn something new here — a data source that did or didn't pan out, a
measured effect, a bug that came from a bad assumption, a difference between places —
add it to `LEARNINGS.md` in the same turn.** Prefer a measured number over an opinion;
say what tool produced it (`suntool …`, a `--no-*` baseline diff, a test). Update the
urban-vs-suburban table and the "process we needed" table when a new step or city changes
them. Don't move things out of it into chat; the doc is the memory.

## `BACKLOG.md` is where deferred work goes

When we decide to do something later, write it into `BACKLOG.md` with enough context to
pick it up cold (why, what, trigger, effort). When an item is done, delete it from there and
record what it taught in `LEARNINGS.md`.

## Ground rules that came from experience

- Big cities are metros: `Pipeline/build_metros.sh [seattle|nyc|la]` or
  `build_places.py` writes tiles to `Server/`; `suntool … --metro Server/<id>` stitches
  them like the app does. Serve with `cd Server && python3 -m http.server 8765` for the
  metro UI tests.
- Phone: `./install_phone.sh` installs Sun Map and sideloads `Server/` metros into its
  Application Support (no public server yet). The phone must be unlocked, or the
  developer disk image won't mount (error 0xE80000E2).
- Measure, don't eyeball: `Engine/.build/release/suntool {coverage,sun,sunbias,blocks,sky}`,
  the pipeline's `--no-sidewalk-synthesis` / `--global-default-height` /
  `--terrain-margin-m 0` baselines, `--max-height 100` / `--no-far` / `--no-terrain` for
  shadow reach, and diffing two bundles' GeoJSON.
- A tag named after what you want is not evidence you have it. Classify edges by the
  physical thing.
- Any global default in per-place data is a bug waiting for the place it doesn't fit.
- A fast-passing UI test is a smell; dump the accessibility tree.
- Nothing map-shaped is fetched at runtime except tiles from the configured static host.
  The pipeline builds places; the app never computes sun outside built tiles (an unbuilt
  place is a banner, not a guess). The live sky (Open-Meteo, `WeatherService`) is the
  one other runtime fetch and must always degrade to the clear-sky map when it fails.
- Never stitch tiles of two builds; never evict files a configured server can't give back.
- The bundle format keeps its legacy names (`.lwbundle`, magic `LWB1`) and the app keeps
  bundle id `com.likewater.sunmap`, so built tiles and installed copies stay valid.
- USA only for now. The owner owns scaling plans (weather proxy, paid keys, rate limits):
  write triggers and options, don't build them.
- Publishing (Pages, Worker deploy) is the owner's step. Agents stage and test locally
  (`publish.py --dry-run`, `wrangler dev`) and stop there. Credentials only come from
  the environment.
- Commit and push to `MonkeyBonez/SunMap` (private) after each tested step.

## `REVIEW.md` is the review list

Open questions the owner wants to come back to. Don't act on them unasked; when one is
decided, move it to `BACKLOG.md` or `LEARNINGS.md` and delete it there.

## Current plan

`PLAN.md` holds where Sun Map stands and what's next. Work from it; when a milestone
lands, tick it off there and move what it taught into `LEARNINGS.md`.
