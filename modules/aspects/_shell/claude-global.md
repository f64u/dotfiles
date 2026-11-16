# Shell on this machine

- `ls`, `ll`, `la`, `lla` and `lt` are aliased to `eza`. Use `command ls` when the output format matters.
- GNU coreutils from `~/.nix-profile/bin` come before the BSD ones in `PATH`: `stat`, `cat`, `ls`, `cp`, `date` and the other coreutils take GNU flags. For BSD behaviour call the full path (`/usr/bin/stat`, `/bin/ls`).
- `sed`, `grep`, `find` and `awk` are still the macOS BSD versions (so `sed -i ''`).
- Check with `whence -p <tool>` when unsure.
