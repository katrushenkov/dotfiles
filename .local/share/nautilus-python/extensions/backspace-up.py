# Backspace -> parent directory (same as Alt+Up) in Nautilus.
# The shortcut lives on the window in the bubble phase, so text entries
# (search, location bar, rename) consume Backspace first and keep working.
import gi

gi.require_version("Gtk", "4.0")
from gi.repository import GObject, Gtk, Nautilus


def _attach(window):
    if getattr(window, "_backspace_up", False):
        return
    window._backspace_up = True
    controller = Gtk.ShortcutController()
    controller.add_shortcut(Gtk.Shortcut.new(
        Gtk.ShortcutTrigger.parse_string("BackSpace"),
        Gtk.NamedAction.new("slot.up"),
    ))
    window.add_controller(controller)


def _on_toplevels_changed(model, position, removed, added):
    for i in range(position, position + added):
        _attach(model.get_item(i))


class BackspaceUp(GObject.GObject, Nautilus.MenuProvider):
    def __init__(self):
        super().__init__()
        toplevels = Gtk.Window.get_toplevels()
        toplevels.connect("items-changed", _on_toplevels_changed)
        _on_toplevels_changed(toplevels, 0, 0, toplevels.get_n_items())
