# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
import os
import re
import socket
import subprocess

from typing import List  # noqa: F401
from libqtile import bar, layout, qtile, hook, extension
from qtile_extras import widget


from qtile_extras.popup.toolkit import (
        PopupRelativeLayout,
        PopupImage,
        PopupText
        )
from qtile_extras.widget.decorations import RectDecoration

from libqtile.config import Click, Drag, Group, Key, Match, Screen

from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

mod = "mod4"
terminal = 'alacritty'

keys = [
        # Switch between windows
        Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
        Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
        Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
        Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
        Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),

        Key([mod], "p", lazy.window.kill(), desc="Kill focused window"),
        Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),

        Key([mod, "shift"], "j",
            lazy.layout.shuffle_down(),
            lazy.layout.section_down(),
            desc='Move windows down in current stack'
            ),
        Key([mod, "shift"], "k",
            lazy.layout.shuffle_up(),
            lazy.layout.section_up(),
            desc='Move windows up in current stack'
            ),

        # Grow windows. If current window is on the edge of screen and direction

        Key([mod, "control"], "h", lazy.layout.grow_left(),
            desc="Grow window to the left"),
        Key([mod, "control"], "l", lazy.layout.grow_right(),
            desc="Grow window to the right"),
        Key([mod, "control"], "j", lazy.layout.grow_down(),
            desc="Grow window down"),
        Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),


        Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

        Key([mod], "m", lazy.layout.maximize(), desc='toggle window between minimum and maximum sizes'),
        Key([mod, "shift"], "f", lazy.window.toggle_floating(), desc='toggle floating'),
        Key([mod], "f", lazy.window.toggle_fullscreen(), desc='toggle fullscreen'),

        Key([mod, "shift"], "h", lazy.layout.swap_left()),
        Key([mod, "shift"], "l", lazy.layout.swap_right()),
        Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
        Key([mod, "shift"], "k", lazy.layout.shuffle_up()),

        # Tree tabs stuff 
        # Key([mod, "shift"], "h", lazy.layout.move_left(), desc='Move up a section in treetab'),
        # Key([mod, "shift"], "l", lazy.layout.move_right(), desc='Move down a section in treetab'),

        # Monitor support 
        # TODO: Make a alt tab kinda feature
        Key([mod], "e", lazy.to_screen(0), desc='Keyboard focus to monitor 1'),
Key([mod], "w", lazy.to_screen(1), desc='Keyboard focus to monitor 2'),

    # Launchers 
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),

    Key([mod, "shift"], "Return", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),

    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod], "d", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    Key([mod], "r", lazy.spawn("bash /home/ex/.config/rofi/app_launcher.sh"), desc="Run rofi"),

    Key([mod], "i", lazy.spawn("bash /home/ex/.config/rofi/switcher.sh"), desc="Run rofi"),

    # Screenshotter 
    Key([], "Print", lazy.spawn("flameshot gui")),

]


groups = [Group(i) for i in "1234567890"]
group_names = [
        ("", {'layout': 'monadtall', "spawn":"/opt/waterfox/waterfox"}),
        ("", {'layout': 'monadtall', "spawn":terminal}),
        ("", {'layout': 'monadtall' }),
        ("", {'layout': 'monadtall'}),
        ("", {'layout': 'monadtall'}),
        ("ﭮ", {'layout': 'monadtall', "spawn":"discord"}),
        ("", {'layout': 'monadtall'}),
        ("", {'layout': 'monadtall', "spawn":"/opt/BlueMail/bluemail --disable-gpu-sandbox"}),
        ("", {'layout': 'floating', "spawn":"/opt/binaryninja/binaryninja"}),
        ]


groups = [Group(name, **kwargs) for name, kwargs in group_names]

for i, (name, kwargs) in enumerate(group_names, 1):
    keys.append(Key([mod], str(i), lazy.group[name].toscreen(toggle=True)))        # Switch to another group
    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name))) # Send current window to another group


# for i in groups:
#     keys.extend([
#         # mod1 + letter of group = switch to group
#         Key([mod], i.name, lazy.group[i.name].toscreen(),
#             desc="Switch to group {}".format(i.name)),

#         # mod1 + shift + letter of group = switch to & move focused window to group
#         Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
#             desc="Switch to & move focused window to group {}".format(i.name)),
#         # Or, use below if you prefer not to switch to that group.
#         # # mod1 + shift + letter of group = move focused window to group
#         # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
#         #     desc="move focused window to group {}".format(i.name)),
#     ])

layout_theme = {"border_width": 3,
                "margin": 8,
                "border_focus": "#268bd2",
                "border_normal": "#002b36"
                }

font = "JetBrainsMono Nerd Font Mono"
layouts = [
        layout.Columns(**layout_theme),
        layout.Max(),
        layout.MonadTall(**layout_theme),
        layout.TreeTab(
            font = font,
            fontsize = 10,
            sections = ["FIRST", "SECOND", "THIRD", "FOURTH"],
            section_fontsize = 10,
            border_width = 2,
            bg_color = "#002b36",
            active_bg = "#268bd2",
            active_fg = "000000",
            inactive_bg = "#2aa198",
            inactive_fg = "1c1f24",
            padding_left = 0,
            padding_x = 0,
            padding_y = 5,
            section_top = 10,
            section_bottom = 20,
            level_shift = 8,
            vspace = 3,
            panel_width = 200
            ),
        ]

widget_defaults = dict(
        font=font,
        fontsize=15,
        padding=3,
        )
extension_defaults = widget_defaults.copy()

colors = [["#002b36", "#002b36"], # panel background
          ["#3d3f4b", "#434758"], # background for current screen tab
          # ["000000", "#000000"], # font color for group names
          ["#fdf6e3", "#fdf6e3"], # font color for group names
          ["#268bd2", "#268bd2"], # border line color for current tab
          ["#268bd2", "#268bd2"], # border line color for 'other tabs' and color for 'odd widgets'
          ["#2aa198", "#2aa198"], # color for the 'even widgets'
          # ["#586e75", "#586e75"], # window name
          ["#268bd2", "#268bd2"], # window name
          ["#93a1a1", "#93a1a1"]] # backbround for inactive screens

prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())

# def init_widgets_list():
#     widgets_list = [
#         widget.Sep(
#             linewidth = 0,
#             padding = 6,
#             foreground = colors[2],
#             background = colors[0]
#         ),
#         widget.GroupBox(
#             font = font,
#             fontsize = 40,
#             margin_x = 0,
#             margin_y = 3,

#             padding_y = 3,
#             padding_x = 3,

#             borderwidth = 3,
#             active =  "#fdf6e3" ,
#             inactive = "#657b83" ,

#             rounded = False,
#             highlight_color = colors[1],
#             highlight_method = "text",
#             this_current_screen_border = colors[6],
#             this_screen_border = "#d33682" ,
#             other_current_screen_border = colors[6],
#             other_screen_border = colors[4],
#             foreground = colors[2],
#             background = colors[0]
#         ),
#         widget.Prompt(
#             prompt = prompt,
#             font = font,
#             padding = 10,
#             foreground = colors[3],
#             background = colors[0]
#         ),

#         widget.Sep(
#             linewidth = 0,
#             padding = 6,
#             foreground = colors[2],
#             background = colors[0]
#         ),

#         widget.WindowName(
#             foreground = colors[6],
#             background = colors[0],
#             fontsize = 16,
#             padding = 0,
#             font = font 
#         ),


#         widget.Systray(
#             background = colors[0],
#             padding = 5
#         ),
#         widget.TextBox(
#             text = '',
#             background = colors[0],
#             foreground = colors[5],
#             padding = 0,
#             fontsize = 37,
#             font = font 
#         ),
#         widget.Battery(
#             foreground = colors[2],
#             background = colors[5],
#                 ),

#         widget.TextBox(
#             text = '',
#             background = colors[5],
#             foreground = colors[4],
#             padding = 0,
#             fontsize = 37,
#             font = font 
#         ),
#         widget.TextBox(
#             text = "",
#             foreground = colors[2],
#             background = colors[4],
#             padding = 0,
#             fontsize = 14,
#             font = font 
#         ),

#         widget.Memory(
#             foreground = colors[2],
#             background = colors[4],
#             mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e htop')},
#             padding = 5
#         ),


#         widget.TextBox(
#             text = '',
#             background = colors[4],
#             foreground = colors[5],
#             padding = 0,
#             fontsize = 37,
#             font = font 
#         ),
#         widget.TextBox(
#             text = " Vol:",
#             foreground = colors[2],
#             background = colors[5],
#             padding = 0,
#             font = font 
#         ),

#         widget.Volume(
#             foreground = colors[2],
#             background = colors[5],
#             padding = 10,
#             font = font,
#         ),

#         widget.TextBox(
#             text = '',
#             background = colors[5],
#             foreground = colors[4],
#             padding = 0,
#             fontsize = 37,
#             font = font 
#         ),
#         widget.CurrentLayoutIcon(
#             custom_icon_paths = [os.path.expanduser("~/.config/qtile/icons")],
#             foreground = colors[0],
#             background = colors[4],
#             padding = 0,
#             scale = 0.7,
#             font = font 
#         ),

#         widget.CurrentLayout(
#             foreground = colors[2],
#             background = colors[4],
#             padding = 5
#         ),


#         widget.TextBox(
#             text = '',
#             background = colors[4],
#             foreground = colors[5],
#             padding = 0,
#             fontsize = 37,
#             font = font 
#         ),
#         widget.Clock(
#             foreground = colors[2],
#             background = colors[5],
#             format = "%A, %B %d - %I:%M %p ",
#             font = font 
#         ),

#     ]
#     return widgets_list

colors = { 
          "base0": ["#657b83", "#657b83"],
          "base1": ["#586e75", "#586e75"],
          "base2": ["#073642", "#073642"],
          "base3": ["#002b36", "#002b36"],
          "grey": ["#839496", "#839496"],
          "yellow": ["#b58900", "#b58900"],
          "orange": ["#cb4b16", "#cb4b16"],
          "mag": ["#d33682", "#d33682"],
          "blue": ["#268bd2", "#268bd2"],
          "cyan": ["#2aa198", "#2aa198"],
          "green": ["#859900", "#859900"],
          "clear": ["#00859900", "#00859900"],
          }



cust_spacer = widget.Spacer(length=5)

def init_widgets_list(two=False):
    decor = {
            "decorations": [
                RectDecoration(colour=colors["base2"], radius=10,  line_width =0, filled=True, clip=True, linewidth=2, padding_x=0, use_widget_background=False, line_colour="#000000"),
                ],
            "padding": 18,
            }
    widgets_list = [
            widget.Clock(
                font = font,
                foreground = colors["cyan"],
                background = colors["clear"],
                format = "%A, %B %d - %I:%M %p ",
                **decor,
                ),

            cust_spacer,
            widget.CurrentLayout(
                foreground = colors["orange"],
                background = colors["clear"],
                **decor,
                ),

            widget.Spacer(300 if two else 500),

            widget.GroupBox(
                font = font,
                fontsize = 35,
                **decor,
                highlight_method = "text",
                block_highlight_text_color = colors["mag"],
                padding_x = 4,
                rounded=True,
                this_current_screen_border = colors["blue"],
                ), 

            widget.Systray(
                background = colors["clear"],
                ),

            cust_spacer,
            widget.WindowName(
                foreground = colors["clear"],
                background = colors["clear"],
                fontsize = 16,
                padding = 0,
                font = font 
                ),

            cust_spacer,
            widget.NetGraph(),
            cust_spacer,
            widget.Net(
                    format=r"{down:} ↓↑ {up}",
                    foreground = colors["yellow"],
                    **decor,

                    ),
            cust_spacer,

            widget.Memory(
                foreground = colors["green"],
                background = colors["clear"],
                format = '{MemUsed: .0f}{mm}',
                **decor,
                ),
            cust_spacer,
            widget.UPowerWidget(
                    text_charging = "{percentage:.0f}%",
                    margin=10,
                    spacing=10,
                    **decor,
                    battery_name="hidpp_battery_32"
                    ),

            cust_spacer,
            widget.Volume(
                    foreground = colors["mag"],
                    fmt="奔 {}",
                    **decor),


    ]
    return widgets_list



def init_widgets_screen1():
    widgets_screen1 = init_widgets_list(two=True)
    return widgets_screen1

def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    return widgets_screen2                 # Monitor 2 will display all widgets in widgets_list

def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_screen1() , opacity=1.0, size=30, background="#00000000", margin=[5,5,2,5])),
            Screen(top=bar.Bar(widgets=init_widgets_screen2(), opacity=1, size=30, background="#00000000", margin=[10,10,2,10] ))]

if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()
    widgets_screen1 = init_widgets_screen1()
    widgets_screen2 = init_widgets_screen2()


# Drag floating layouts.
mouse = [
        Drag([mod], "Button1", lazy.window.set_position_floating(),
             start=lazy.window.get_position()),
        Drag([mod], "Button3", lazy.window.set_size_floating(),
             start=lazy.window.get_size()),
        Click([mod], "Button2", lazy.window.bring_to_front())
        ]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
    ])
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])



