#!/usr/bin/env python3
"""Point a formula at a different release of its upstream project.

Rewrites the version and every url/sha256 pair in place. Checksums come from
the release's own checksums.txt rather than being recomputed here, so the
formula can only ever claim what the release actually published.

    update-formula.py Formula/regesto.rb v0.1.2 checksums.txt

Exits 0 and changes nothing when the formula already names that version, so a
scheduled run is a no-op almost every time it fires.
"""

import pathlib
import re
import sys

# "<sha256>  regesto_v0.1.2_darwin_arm64.tar.gz", the shasum output format.
CHECKSUM = re.compile(r"^([0-9a-f]{64})\s+(\S+)$")

# A url line followed by its sha256 line, which is how Homebrew pairs them.
# The architecture is read back out of the existing filename so this works for
# any set of platforms without being told which ones to expect.
PAIR = re.compile(
    r'url "(?P<base>https://\S+?/releases/download)/[^/"]+/'
    r'(?P<prefix>[^"/_]+)_[^"_]+_(?P<os>[a-z0-9]+)_(?P<arch>[a-z0-9]+)\.tar\.gz"'
    r'\n(?P<indent>[ \t]*)sha256 "[0-9a-f]{64}"'
)


def main() -> int:
    if len(sys.argv) != 4:
        print(__doc__, file=sys.stderr)
        return 2
    formula_path, version, checksums_path = (
        pathlib.Path(sys.argv[1]),
        sys.argv[2],
        pathlib.Path(sys.argv[3]),
    )

    sums = {}
    for line in checksums_path.read_text().splitlines():
        m = CHECKSUM.match(line.strip())
        if m:
            sums[m.group(2)] = m.group(1)
    if not sums:
        print(f"no checksums found in {checksums_path}", file=sys.stderr)
        return 1

    text = formula_path.read_text()
    bare = version.lstrip("v")

    current = re.search(r'^\s*version "([^"]+)"', text, re.M)
    if current and current.group(1) == bare:
        print(f"unchanged: already at {bare}")
        return 0

    missing = []

    def repoint(m: re.Match) -> str:
        name = f"{m.group('prefix')}_{version}_{m.group('os')}_{m.group('arch')}.tar.gz"
        if name not in sums:
            missing.append(name)
            return m.group(0)
        url = f"{m.group('base')}/{version}/{name}"
        return f'url "{url}"\n{m.group("indent")}sha256 "{sums[name]}"'

    text, pairs = PAIR.subn(repoint, text)
    if pairs == 0:
        print("no url/sha256 pairs matched — has the formula's shape changed?", file=sys.stderr)
        return 1
    if missing:
        # Better to leave the formula untouched than to publish one that mixes
        # versions across platforms.
        print("release is missing: " + ", ".join(missing), file=sys.stderr)
        return 1

    text = re.sub(r'^(\s*)version "[^"]+"', rf'\1version "{bare}"', text, count=1, flags=re.M)

    formula_path.write_text(text)
    print(f"updated {formula_path} to {bare} ({pairs} platforms)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
