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
    if not os.path.exists(path):
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


def show_menu(title: str, entries: list[str]) -> int:
    input = "\n".join(entries)
    result = subprocess.run(
        [
            "wofi",
            "-p",
            title,
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


def purge_thumbs(thumbs_path: str, wofi_input: list[WofiEntry]) -> None:
    all_thumbs = set(os.listdir(thumbs_path))
    active_thumbs = set(
        map(
            lambda entry: os.path.split(entry.title)[-1],
            filter(lambda entry: entry.is_image, wofi_input),
        )
    )

    to_delete = all_thumbs.difference(active_thumbs)
    for thumb in to_delete:
        os.remove(os.path.join(thumbs_path, thumb))


def cli():
    title = sys.argv[1] if len(sys.argv) == 2 else "Select clip"
    thumbs = init_thumb_dir()

    meta_re = re.compile(r"^[0-9]+\s<meta http-equiv=")
    parse_line_re = re.compile(r"^(?P<idx>[0-9]+)\t(?P<value>.*)$")
    binary_image_re = re.compile(r"^(\[\[\s)?binary.*(?P<ext>jpg|jpeg|png|bmp)")

    history = list(filter(lambda line: not meta_re.match(line), cliphist_list()))

    def convert_line(line: str) -> WofiEntry:
        parsed = parse_line_re.match(line)
        if parsed:
            idx = int(parsed.group("idx"))
            value = parsed.group("value")

            binary = binary_image_re.match(value)
            if binary:
                ext = binary.group("ext")
                image_path = os.path.join(thumbs, f"{idx}.{ext}")
                ensure_thumb(idx, image_path)
                return WofiEntry(idx, f"img:{image_path}", True)
            else:
                return WofiEntry(idx, f"{value}")
        return WofiEntry(-1, "")

    wofi_input = list(map(convert_line, history))

    purge_thumbs(thumbs, wofi_input)

    selected = show_menu(title, list(map(lambda we: we.title, wofi_input)))

    if len(wofi_input) > 0:
        print(f"{wofi_input[selected].idx}\t")


if __name__ == "__main__":
    cli()
