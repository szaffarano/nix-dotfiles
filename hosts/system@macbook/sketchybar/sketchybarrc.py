#!/usr/bin/env python3

import subprocess


SKETCHY_CMD = "sketchybar"
YABAI_CMD = "yabai"


def sketchy(*argv):
    subprocess.call([SKETCHY_CMD] + list(argv))


def main():
    sketchy(
        "--bar",
        "height=28",
        "blur_radius=50",
        "position=bottom",
        "corner_radius=8",
        "sticky=off",
        "padding_left=5",
        "padding_right=5",
        "color=0x15ffffff",
    )

    sketchy(
        "--default",
        "updates=when_shown",
        "drawing=on",
        "icon.font=Hack Nerd Font:Bold:15.0",
        "icon.color=0xffffffff",
        "label.font=Hack Nerd Font:Bold:13.0",
        "label.color=0xffffffff",
        "label.padding_left=4",
        "label.padding_right=4",
        "icon.padding_left=4",
        "icon.padding_right=4",
    )

    spaces = ["1.  ", "2. ", "3.  ", "4.  ", "5.  ", "6. ", "7.  "]
    for idx, space_text in enumerate(spaces):
        space_id = idx+1
        sketchy(
            "--add",
            "space",
            f"space.{space_id}",
            "left",
            "--set",
            f"space.{space_id}",
            f"associated_space={space_id}",
            f"icon={space_text}",
            "icon.padding_left=8",
            "icon.padding_right=8",
            "background.padding_left=5",
            "background.padding_right=5",
            "background.color=0x44ffffff",
            "background.corner_radius=5",
            "background.height=22",
            "background.drawing=off",
            "label.drawing=off",
            f"script=space.sh",
            f"click_script={YABAI_CMD} -m space --focus {space_id}",
        )

    sketchy(
        "-m",

        "--add", "item", "spaces_separator", "left",
        "--set", "spaces_separator", "label=",

        "--add", "item", "yabai_mode", "left",
        "--set", "yabai_mode", "update_freq=3",
        "--set", "yabai_mode", f"script=yabai_mode.sh",
        "--set", "yabai_mode", f"click_script=yabai_mode_click.sh",
        "--subscribe", "yabai_mode", "space_change",

        "--add", "item", "space_separator", "left",
        "--set", "space_separator", "icon=", "background.padding_left=15", "background.padding_right=15", "label.drawing=off",
        "--add", "item", "front_app", "left",
        "--set", "front_app", f"script=front_app.sh", "icon.drawing=off",
        "--subscribe", "front_app", "front_app_switched",
    )

    sketchy(
        "--add", "item", "clock", "right",
        "--set", "clock", "update_freq=10", f"script=clock.sh",
        "--add", "item", "separator", "right",
        "--set", "separator", "label=",
        "--add", "item", "battery", "right",
        "--set", "battery", f"script=battery.sh", "update_freq=10",
        "--subscribe", "battery", "system_woke",
    )

    sketchy("--update")


if __name__ == "__main__":
    main()
