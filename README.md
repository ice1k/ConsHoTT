# Constructive HoTT

A note about various constructive interpretations of HoTT,
including the Path type, HITs and the univalence principle
(instead of axiom, because it's no longer an axiom!).

## Build

To build a preprint PDF, you'll need TeXLive,
a python package `Pygments`,
the most recent version of Agda and its cubical library.

Installing Pygments:

```bash
pip install Pygments
```

or:

```bash
pip3 install Pygments
```

Installing TeXLive && Pygments on NixOS:

```bash
nix-env -iA nixos.python37Packages.pygments nixos.texlive.combined.scheme-full
```

Installing Agda requires an extra step if you're on a
non-English version of Windows:

```bash
CHCP 65001
```

then you follow the instructions
[here](https://github.com/agda/cubical/blob/master/INSTALL.md).
Unfortunately, this project cannot be built on Windows.
To build this note on Windows,
you'll need to port [Makefile](./Makefile) to Windows,
and I don't have time to do so.

After all dependencies are installed,
run this to compile the PDF:

```bash
make main
```

Any sort of contribution is welcomed.

# TODOs

+ Univalence
+ xtt
+ The rest of this list

