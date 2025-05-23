from libqtile import bar, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.backend.wayland import InputConfig
import os
import subprocess
from libqtile import hook


mod = "mod4"
terminal = "foot"


def wifi():
    qtile.cmd_spawn("sh -c ~/.scripts/rofi-wifi")


def bluetooth():
    qtile.cmd_spawn("sh -c ~/.scripts/rofi-bluetooth")


def logout():
    qtile.cmd_spawn("wlogout")


def search():
    qtile.cmd_spawn("rofi -show drun")


keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    # Media volume keys
    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute 0 toggle")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+")),
    # Brightness controll
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 2%-")),
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +2%")),
    # Launch rofi
    Key([mod], "d", lazy.spawn("rofi -show drun"), desc="Launch Rofi"),
    # Move through groups
    Key([mod], "Right", lazy.screen.next_group()),
    Key([mod], "Left", lazy.screen.prev_group()),
    # Screenshot
    Key([], "Print", lazy.spawn("grim"), desc="Take a screenshot"),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

groups = [
    Group(name="1", label=""),
    Group(name="2", label=""),
    Group(name="3", label=""),
    Group(name="4", label=""),
    Group(name="5", label=""),
    Group(name="6", label=""),
    Group(name="7", label=""),
    Group(name="8", label=""),
]

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            # mod + shift + group number = move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name),
                desc=f"Move focused window to group {i.name}",
            ),
        ]
    )

theme = {
    "border_width": 3,
    "border_focus": "#86b8db",
    "border_normal": "#326d98",
    "margin": 7
}

layouts = [
    # layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    # layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(**theme),
    layout.Floating(**theme),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="sans",
    fontsize=16,
    padding=3,
)
extension_defaults = widget_defaults.copy()


screens = [

    Screen(
        wallpaper='~/.config/qtile/wallpaper.png',
        wallpaper_mode='fill',

        top=bar.Bar(
            [
                widget.Spacer(
                    length=10
                ),
                widget.TextBox(
                    text="",
                    font="Font Awesome 6 Free Solid",
                    foreground='#a2dfda',
                    mouse_callbacks={"Button1": search},
                ),
                widget.Spacer(
                    length=50
                ),
                widget.GroupBox(
                    font="JetBrains Mono Bold",
                    borderwidth=3,
                    highlight_method='block',
                    active='#bb9fe2',
                    block_highlight_text_color="#d8d0a9",
                    inactive='#434254',
                    this_current_screen_border='#353446',
                    this_screen_border='#353446',
                    other_current_screen_border='#353446',
                    other_screen_border='#353446',
                    urgent_border='#ee93a6',
                    rounded=True,
                    disable_drag=True
                ),
                widget.Spacer(
                    length=bar.STRETCH
                ),
                widget.TextBox(
                    text=" ",
                    font="Font Awesome 6 Free Solid",
                    foreground='#eea393',
                ),
                widget.Clock(
                    format='%d/%m',
                    font='JetBrains Mono Bold',
                    foreground='#eea393',
                ),
                widget.Spacer(
                    length=10
                ),
                widget.TextBox(
                    text=" ",
                    font="Font Awesome 6 Free Solid",
                    foreground='#CAA9E0',
                ),
                widget.Clock(
                    format='%H:%M',
                    font='JetBrains Mono Bold',
                    foreground='#CAA9E0',
                ),
                widget.Spacer(
                    length=bar.STRETCH
                ),
                widget.Image(
                    filename='~/.config/qtile/bluetooth-rectangle.svg',
                    margin=6,
                    mouse_callbacks={"Button1": bluetooth},
                ),
                widget.Image(
                    filename='~/.config/qtile/wifi-pentagon.svg',
                    margin=2,
                    mouse_callbacks={"Button1": wifi},
                ),

                widget.Spacer(
                    length=10
                ),
                widget.TextBox(
                    text=" ",
                    font="Font Awesome 6 Free Solid",
                    foreground='#a9d8be',
                ),
                widget.Battery(
                    font="JetBrains Mono Bold",
                    foreground='#a9d8be',
                    format='{percent:2.0%}',
                ),
                widget.Spacer(
                    length=50
                ),
                widget.TextBox(
                    text='',
                    font="Font Awesome 6 Free Solid",
                    foreground="#ee93a6",
                    mouse_callbacks={"Button1": logout},
                ),
                widget.Spacer(
                    length=10
                ),
           ],
            35,
            background="191919",
            # border_width=[2, 2, 2, 2],  # Draw top and bottom borders
            # border_color=["ffffff", "ffffff", "ffffff", "ffffff"],  # Borders are magenta
            margin=[7, 10, 0, 10]
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = {
    "type:keyboard": InputConfig(
        kb_repeat_rate=20,
        kb_repeat_delay=400,
        kb_layout='br',
    ),
    "type:touchpad": InputConfig(drag=True, tap=True, natural_scroll=True),
}

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 32

@hook.subscribe.startup_once
def autostart():
    subprocess.call([os.path.expanduser('.config/qtile/autostart.sh')])

# Set this string if your java app doesn't work correctly:
wmname = "Qtile"
