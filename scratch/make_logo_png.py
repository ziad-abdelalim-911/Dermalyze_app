"""
Renders the Dermalyze logo (the 3-D layered 'D' letter) as a 1024×1024 PNG
using only Pillow – no cairosvg / inkscape needed.

Outputs:
  assets/icons/play_store_512.png   (1024×1024, used as the launcher icon source)
  assets/icons/ic_launcher_foreground.png  (same image, kept for adaptive icon)
"""

import math
from PIL import Image, ImageDraw

SIZE = 1024
BG   = (14, 28, 47, 255)        # #0E1C2F

# ── helpers ────────────────────────────────────────────────────────────────

def lerp_colour(c1, c2, t):
    return tuple(int(c1[i] + (c2[i]-c1[i])*t) for i in range(3))

def hex_rgb(h):
    h = h.lstrip('#')
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

# gradients (top→bottom within the D-path)
GRADIENTS = [
    # (c_top, c_bot, opacity, rotation_deg, translate)
    (hex_rgb("#145E6E"), hex_rgb("#103870"), 0.45, -7,  (-24, -20)),
    (hex_rgb("#1E7A8A"), hex_rgb("#1A4D8A"), 0.62, -4.5,(-12, -10)),
    (hex_rgb("#3AADBE"), hex_rgb("#2F6DB5"), 0.80, -2,  (-4,  -4)),
    (hex_rgb("#62C8D8"), hex_rgb("#4A8FD4"), 1.00,  0,  (0,   0)),
]

STROKE_W  = [40, 42, 44, 48]   # scaled from 500→1024 ≈ ×2.048

# D-path control points (original 500-px space, will be scaled)
SCALE = SIZE / 500.0

# The D consists of:
#   vertical stem : x=148, y 108→392
#   top bar       : x 148→202, y=108
#   arc C(338,108)→(370,250)→(338,392) →back to x=202, y=392
#   bottom bar    : x 202→148, y=392

def make_d_points(n_arc=120):
    pts_stem  = [(148, y) for y in range(108, 393, 4)]
    pts_top   = [(x, 108) for x in range(148, 203, 2)]
    pts_arc   = []
    # cubic bezier: P0=(202,108) P1=(338,108) P2=(370,250) ... symmetric
    # approximated by two bezier halves
    def bezier3(p0, p1, p2, p3, steps):
        pts = []
        for i in range(steps+1):
            t = i/steps
            x = (1-t)**3*p0[0] + 3*(1-t)**2*t*p1[0] + 3*(1-t)*t**2*p2[0] + t**3*p3[0]
            y = (1-t)**3*p0[1] + 3*(1-t)**2*t*p1[1] + 3*(1-t)*t**2*p2[1] + t**3*p3[1]
            pts.append((x, y))
        return pts
    # top-right arc
    pts_arc += bezier3((202,108),(338,108),(370,172),(370,250), n_arc//2)
    # bottom-right arc
    pts_arc += bezier3((370,250),(370,328),(338,392),(202,392), n_arc//2)
    pts_bot = [(x, 392) for x in range(202, 147, -2)]
    return pts_stem + pts_top + pts_arc + pts_bot

D_PTS_RAW = make_d_points()

def transform_pts(pts, cx, cy, angle_deg, tx, ty, scale):
    """rotate around (cx,cy) then translate then scale"""
    rad = math.radians(angle_deg)
    cos_a, sin_a = math.cos(rad), math.sin(rad)
    out = []
    for px, py in pts:
        dx, dy = px - cx, py - cy
        rx = cos_a*dx - sin_a*dy + cx + tx
        ry = sin_a*dx + cos_a*dy + cy + ty
        out.append((rx*scale, ry*scale))
    return out

# ── draw ───────────────────────────────────────────────────────────────────

img = Image.new("RGBA", (SIZE, SIZE), BG)

# rounded-rect background (already filled with BG above)
mask = Image.new("L", (SIZE, SIZE), 0)
mask_draw = ImageDraw.Draw(mask)
r = int(88 * SCALE)
mask_draw.rounded_rectangle([0,0,SIZE-1,SIZE-1], radius=r, fill=255)
img.putalpha(mask)

cx = cy = 250  # rotation centre in original space

for idx, (c_top, c_bot, opacity, angle, (tx, ty)) in enumerate(GRADIENTS):
    pts = transform_pts(D_PTS_RAW, cx, cy, angle, tx, ty, SCALE)

    # draw each segment with gradient colour approximation
    sw = STROKE_W[idx]
    layer = Image.new("RGBA", (SIZE, SIZE), (0,0,0,0))
    ld = ImageDraw.Draw(layer)

    # determine y-extent for gradient
    ys = [p[1] for p in pts]
    y_min, y_max = min(ys), max(ys)
    y_range = max(y_max - y_min, 1)

    # draw with segmented colour
    for i in range(len(pts)-1):
        p1, p2 = pts[i], pts[i+1]
        t = ((p1[1]+p2[1])/2 - y_min) / y_range
        rgb = lerp_colour(c_top, c_bot, t)
        a = int(opacity * 255)
        ld.line([p1, p2], fill=rgb+(a,), width=sw)

    # composite
    img = Image.alpha_composite(img, layer)

# ── save ───────────────────────────────────────────────────────────────────

import os, shutil

out1 = r"assets\icons\play_store_512.png"
out2 = r"assets\icons\ic_launcher_foreground.png"

img.save(out1)
img.save(out2)
print(f"Saved {out1}  ({SIZE}x{SIZE})")
print(f"Saved {out2}  ({SIZE}x{SIZE})")
