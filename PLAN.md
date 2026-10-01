# Sun Map — where it stands

Split from `MonkeyBonez/LikeWater` on 2026-10-01 (tag `sunmap-split`; that repo's
`PLAN.md` has the full history of the round that built what is below). Sun Map is now the
main line of work; Like Water's route/ETA/corridor work is parked there.

## What Sun Map does today

- Sidewalks around you coloured by sun for any 15-minute step of the day, with the
  live sky (Open-Meteo HRRR, 15-min DNI per ~2.5 km cell) fading the palette; a sky picker
  overrides the forecast.
- The whole screen at any zoom: every sidewalk edge up to 2.5 km across, sun by block
  (70 m – 4.4 km cells) up to 160 km; scored per lattice tile through a cache, so a pan
  scores only what came into view, and the ring around the screen is prefetched.
- Seven places: San Francisco, Berkeley and Moorpark ship in the app; New York, Los
  Angeles, Seattle and Portland are tiled metros (sideloaded today; downloaded on demand
  once a host is configured).
- Load anywhere: coverage decided by the whole screen, "No sun data here yet" banner
  with the nearest built place, "Request this area" when the Worker URL is set; pinned
  builds, LRU cache (400 MB), Wi-Fi prefetch.

## Backend (all built and tested locally; going live is the owner's step)

| Piece | Status |
|---|---|
| Tiles on Cloudflare Pages (`sunmap-tiles`) | `publish.py --dry-run` stages it; owner runs `wrangler login` + `publish.py --target pages` |
| Worker `sunmap-api` (`/coverage-request`, export, `/sky` proxy off, auto-build off) | `wrangler dev` + `Worker/smoke.sh` |
| New places: `metros.yaml` → `build_places.py`, `build-places.yml` Action | Action inert until repo vars/secrets are set |
| GOES fog POC: `goes-log.yml` hourly → `goes-log` branch `REPORT.md` | logging; verdict after ≥ 10 days (BACKLOG) |

## Tests

51 engine (`swift test`), 24 pipeline (`pytest`), 24 UI (`xcodebuild test -scheme SunMap`,
with the local servers in README), Worker smoke.

## Next

To be decided with the owner. `REVIEW.md` holds open questions to review first
(data quality and what it means for automatic builds). Candidates already written up in `BACKLOG.md`: the GOES
build-out (after the verdict), going live on Pages, the sun-only bundle diet, sky per cell
and cross-border shadows in the block view, tree canopy. The five design directions from
the Like Water round (claude.ai/artifact/FXqMrQQje7dSRxgGLqUoJX) were drawn for the walk
screen; a Sun Map screen design would be a new round.
