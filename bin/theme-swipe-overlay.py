#!/usr/bin/env python3
import argparse
import os
import signal
import sys
import time

import gi

gi.require_version('Gtk', '3.0')
gi.require_version('Gdk', '3.0')
gi.require_version('GtkLayerShell', '0.1')
from gi.repository import Gdk, GdkPixbuf, GLib, Gtk, GtkLayerShell


def _clip_half_plane(poly, k):
    def inside(p):
        return (p[0] + p[1]) <= k

    def intersect(p1, p2):
        x1, y1 = p1
        x2, y2 = p2
        d1 = (x1 + y1) - k
        d2 = (x2 + y2) - k
        denom = (d1 - d2)
        if abs(denom) < 1e-9:
            return p2
        t = d1 / denom
        return (x1 + (x2 - x1) * t, y1 + (y2 - y1) * t)

    if not poly:
        return []

    out = []
    prev = poly[-1]
    prev_in = inside(prev)
    for curr in poly:
        curr_in = inside(curr)
        if curr_in:
            if not prev_in:
                out.append(intersect(prev, curr))
            out.append(curr)
        elif prev_in:
            out.append(intersect(prev, curr))
        prev = curr
        prev_in = curr_in
    return out


class SwipeOverlay:
    def __init__(self, image_path, duration, delay, cleanup_path=None):
        self.image_path = image_path
        self.duration = max(0.05, duration)
        self.delay = max(0.0, delay)
        self.cleanup_path = cleanup_path

        self.window = Gtk.Window.new(Gtk.WindowType.TOPLEVEL)
        self.window.set_decorated(False)
        self.window.set_app_paintable(True)
        self.window.set_accept_focus(False)
        self.window.set_resizable(False)
        self.window.set_keep_above(True)
        self.window.connect('destroy', self._on_destroy)
        self.window.connect('draw', self._on_draw)

        GtkLayerShell.init_for_window(self.window)
        GtkLayerShell.set_layer(self.window, GtkLayerShell.Layer.OVERLAY)
        GtkLayerShell.set_keyboard_mode(self.window, GtkLayerShell.KeyboardMode.NONE)
        GtkLayerShell.set_exclusive_zone(self.window, -1)
        for edge in (
            GtkLayerShell.Edge.TOP,
            GtkLayerShell.Edge.RIGHT,
            GtkLayerShell.Edge.BOTTOM,
            GtkLayerShell.Edge.LEFT,
        ):
            GtkLayerShell.set_anchor(self.window, edge, True)

        screen = Gdk.Screen.get_default()
        self.width = screen.get_width()
        self.height = screen.get_height()

        self.pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_scale(
            self.image_path,
            self.width,
            self.height,
            True,
        )

        self.start_ts = None
        self.timer_id = None

    def run(self):
        self.window.show_all()
        GLib.timeout_add(int(self.delay * 1000), self._start_animation)
        Gtk.main()

    def _start_animation(self):
        self.start_ts = time.monotonic()
        self.timer_id = GLib.timeout_add(1000 // 120, self._tick)
        return False

    def _tick(self):
        self.window.queue_draw()
        elapsed = time.monotonic() - self.start_ts
        if elapsed >= self.duration:
            self.window.destroy()
            return False
        return True

    def _on_draw(self, _widget, cr):
        # Progress 0..1 where 0 = fully old frame, 1 = fully revealed new frame.
        if self.start_ts is None:
            progress = 0.0
        else:
            progress = max(0.0, min(1.0, (time.monotonic() - self.start_ts) / self.duration))

        # Move a -45deg line (x+y=k) from far bottom-right to far top-left.
        k_start = float(self.width + self.height + 2)
        k_end = -2.0
        k = k_start + (k_end - k_start) * progress

        rect = [
            (0.0, 0.0),
            (float(self.width), 0.0),
            (float(self.width), float(self.height)),
            (0.0, float(self.height)),
        ]
        poly = _clip_half_plane(rect, k)

        if not poly:
            return False

        cr.save()
        cr.new_path()
        cr.move_to(poly[0][0], poly[0][1])
        for x, y in poly[1:]:
            cr.line_to(x, y)
        cr.close_path()
        cr.clip()

        Gdk.cairo_set_source_pixbuf(cr, self.pixbuf, 0, 0)
        cr.paint()
        cr.restore()

        return False

    def _on_destroy(self, _widget):
        if self.timer_id is not None:
            GLib.source_remove(self.timer_id)
            self.timer_id = None
        if self.cleanup_path:
            try:
                os.remove(self.cleanup_path)
            except FileNotFoundError:
                pass
        Gtk.main_quit()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--image', required=True)
    parser.add_argument('--duration', type=float, default=0.8)
    parser.add_argument('--delay', type=float, default=0.08)
    parser.add_argument('--cleanup')
    args = parser.parse_args()

    if not os.path.isfile(args.image):
        print(f'image not found: {args.image}', file=sys.stderr)
        return 1

    signal.signal(signal.SIGTERM, lambda *_: Gtk.main_quit())
    signal.signal(signal.SIGINT, lambda *_: Gtk.main_quit())

    app = SwipeOverlay(args.image, args.duration, args.delay, args.cleanup)
    app.run()
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
