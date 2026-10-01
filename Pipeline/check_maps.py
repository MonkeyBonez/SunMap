"""Render the engine's sun output (`suntool sun`) on a slippy map.

Reads GeoJSON written by Engine's `suntool`, so what you see is exactly what the
app computes, not a second implementation that might agree by accident.

    .venv/bin/python check_maps.py ../check ../check/maps
"""
import json, sys
from pathlib import Path
import folium

SUN_COLORS = {2: ("#f5a300", 5, 0.95), 1: ("#d8c37a", 4, 0.85), 0: ("#33475c", 4, 0.9)}


def load(path):
    with open(path) as f:
        return json.load(f)


def sun_map(doc, title):
    meta = doc["meta"]
    m = folium.Map(location=meta["center"], zoom_start=17, tiles="OpenStreetMap")
    for feat in doc["features"]:
        color, weight, opacity = SUN_COLORS[feat["properties"]["bucket"]]
        coords = [[c[1], c[0]] for c in feat["geometry"]["coordinates"]]
        props = feat["properties"]
        kind = "synthesised sidewalk" if props.get("synthetic") and props.get("sidewalk") else (
               "synthesised crossing" if props.get("synthetic") and props.get("crossing") else (
               "synthesised link" if props.get("synthetic") else (
               "OSM sidewalk" if props.get("sidewalk") else ("crossing" if props.get("crossing") else "other"))))
        folium.PolyLine(coords, color=color, weight=weight, opacity=opacity,
                        dash_array="6 4" if props.get("synthetic") else None,
                        tooltip=f"sun {props['sun']:.1f} · {kind}").add_to(m)
    folium.map.Marker(
        meta["center"],
        icon=folium.DivIcon(html=(
            f'<div style="font:600 13px -apple-system;background:#111;color:#fff;'
            f'padding:6px 9px;border-radius:7px;white-space:nowrap">{title}<br>'
            f'<span style="font-weight:400;color:#bbb">az {meta["azimuth"]:.0f}° · '
            f'el {meta["elevation"]:.0f}° · {meta["edges"]} edges · '
            f'{meta["computeMs"]:.1f} ms</span></div>'))).add_to(m)
    return m


def main():
    src = Path(sys.argv[1] if len(sys.argv) > 1 else "../check")
    dst = Path(sys.argv[2] if len(sys.argv) > 2 else "../check/maps")
    dst.mkdir(parents=True, exist_ok=True)

    titles = {
        "sun10am": "SoMa sun · 10:00 am, 23 Sep",
        "sun4pm": "SoMa sun · 4:00 pm, 23 Sep",
    }
    for path in sorted(src.glob("*.geojson")):
        key = path.stem
        doc = load(path)
        title = titles.get(key, key)
        if "azimuth" not in doc["meta"]:
            continue  # not `suntool sun` output (e.g. `suntool blocks`)
        out = dst / f"{key}.html"
        sun_map(doc, title).save(str(out))
        print(f"{key:8s} az {doc['meta']['azimuth']:.0f} el {doc['meta']['elevation']:.0f} "
              f"{doc['meta']['edges']} edges {doc['meta']['computeMs']:.1f} ms -> {out.name}")


if __name__ == "__main__":
    main()
