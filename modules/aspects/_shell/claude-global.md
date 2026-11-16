# Shell on this machine

- `ls`, `ll`, `la`, `lla` and `lt` are aliased to `eza`. Use `command ls` when the output format matters.
- `stat`, `cat`, `ls`, `cp`, `date` and the other coreutils are uutils (the Rust rewrite) from `~/.nix-profile/bin`, ahead of the BSD ones in `PATH`. They take GNU-style flags. For BSD behaviour call the full path (`/usr/bin/stat`, `/bin/ls`).
- `sed`, `grep`, `find` and `awk` are still the macOS BSD versions (so `sed -i ''`).
- Check with `whence -p <tool>` when unsure.
