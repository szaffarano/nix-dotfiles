#!/usr/bin/env python

import os
import re
import subprocess
import sys


class WofiEntry:
    def __init__(self, idx: int, title: str, is_image: bool = False):
        self.idx = idx
        self.title = title
        self.is_image = is_image


def init_thumb_dir() -> str:
    cache = os.environ.get(
        "XDG_CACHE_HOME", os.path.join(os.environ.get("HOME", "."), ".cache")
    )
    thumbs = os.path.join(cache, "cliphist", "thumbs")

    if not os.path.exists(thumbs):
        os.makedirs(thumbs)

    return thumbs


def cliphist_list() -> list[str]:
    result = subprocess.run(["cliphist", "list"], stdout=subprocess.PIPE)

    if result.returncode != 0:
        return []

    return result.stdout.decode("utf-8").splitlines()


def ensure_thumb(idx: int, path: str) -> None:
    img = subprocess.run(
        ["cliphist", "decode"],
        input=str.encode(f"{idx}\t\n"),
        check=True,
        capture_output=True,
    ).stdout

    _ = subprocess.run(
        ["magick", "-", "-resize", "256x256>", path],
        input=img,
    )


def show_menu(entries: list[str]) -> int:
    input = "\n".join(entries)
    result = subprocess.run(
        [
            "wofi",
            "--dmenu",
            "-I",
            "-Ddmenu-print_line_num=true",
            "-Dimage_size=100",
            "-Dynamic_lines=true",
        ],
        input=str.encode(input),
        capture_output=True,
    )
    selection = result.stdout.decode("utf-8").replace("\n", "")
    return int(selection) if selection != "" else 0


def decode_selection(entry: WofiEntry) -> bytes:
    result = subprocess.run(
        ["cliphist", "decode"],
        input=str.encode(f"{entry.idx}\t"),
        check=True,
        capture_output=True,
    )

    return result.stdout


def cli():
    thumbs = init_thumb_dir()

    meta_re = re.compile(r"^[0-9]+\s<meta http-equiv=")
    line_re = re.compile(r"^(?P<idx>[0-9]+)\t(?P<value>.*)$")
    img_type_re = re.compile(r"^(\[\[\s)?binary.*(?P<ext>jpg|jpeg|png|bmp)")

    history = cliphist_list()

    input = list(filter(lambda line: not meta_re.match(line), history))

    def convert_line(line: str) -> WofiEntry:
        parsed = line_re.match(line)
        if parsed:
            idx = int(parsed.group("idx"))
            value = parsed.group("value")

            binary = img_type_re.match(value)
            if binary:
                ext = binary.group("ext")
                image = os.path.join(thumbs, f"{idx}.{ext}")
                if not os.path.exists(image):
                    ensure_thumb(idx, image)
                return WofiEntry(idx, f"img:{image}", True)
            else:
                return WofiEntry(idx, f"{value}")
        return WofiEntry(-1, "")

    wofi_input = list(map(convert_line, input))

    selected = show_menu(list(map(lambda we: we.title, wofi_input)))

    sys.stdout.buffer.write(decode_selection(wofi_input[selected]))


if __name__ == "__main__":
    cli()
