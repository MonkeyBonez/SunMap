# To review

Open questions to come back to and decide on. When an item is decided, move it to
`BACKLOG.md` (if we'll do it) or `LEARNINGS.md` (if it taught us something), and delete
it here.

## Data quality: what we might be missing, and what it means for automatic builds

*Added 2026-10-01.*

What we might be missing, roughly in order of impact:

1. **Trees.** No place has canopy data. It's probably the biggest error in suburbs
   (Moorpark at midday). The national option is NLCD tree canopy (30 m); some cities
   publish their own canopy layers.
2. **Building heights where Overture is thin.** For example, 30% of Seattle buildings
   have no height. Two options:
   - USGS 3DEP lidar covers most of the US and could give real heights (and trees)
     anywhere.
   - Many cities publish footprints with heights: NYC, Chicago, Boston, DC,
     Philadelphia, among others.
3. **City sidewalk inventories.** Several big cities publish them (Boston, DC and
   others), and OpenSidewalks/Tile2Net cover a few more. Without one, sidewalks are
   guessed.
4. **Roof shapes.** Buildings are flat-topped boxes everywhere; there's no national
   source for this.

Implications for automatic builds:

- **Same quality floor everywhere.** Every place gets the same baseline: good where OSM
  and Overture are good, guessed where they aren't. We already saw this in LA, where
  Boyle Heights and Watts are 93–100% synthesised sidewalks.
- **Measure each build.** For each auto-built place, record the share of sidewalk edges
  that were synthesised (`suntool coverage`) and the share of buildings with a measured
  height. Then flag thin places instead of presenting them as equally accurate.
- **A per-city data registry, filled in by a person.** Keep a list of known city surveys
  and height datasets in `metros.yaml`. When a requested city has one, someone adds it,
  and the build uses it. The automatic path stays national-sources-only.
- **One big national upgrade.** 3DEP lidar heights and NLCD canopy would raise every
  place at once. Both are worth a backlog entry; canopy already has one ("Tree canopy").
