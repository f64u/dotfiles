# Shell on this machine

- `ls`, `ll`, `la`, `lla` and `lt` are aliased to `eza`. Use `command ls` when the output format matters.
- `stat`, `cat`, `ls`, `cp`, `date` and the other coreutils are uutils (the Rust rewrite) from `~/.nix-profile/bin`, ahead of the BSD ones in `PATH`. They take GNU-style flags. For BSD behaviour call the full path (`/usr/bin/stat`, `/bin/ls`).
- `sed`, `grep`, `find` and `awk` are still the macOS BSD versions (so `sed -i ''`).
- Check with `whence -p <tool>` when unsure.

# Version control

- Prefer `jj` (Jujutsu) over `git`. In a repo with a `.jj` directory, use jj for status, diffs, history and commits (`jj st`, `jj diff`, `jj log`, `jj commit`, `jj bookmark move`), not the git equivalents.
- Such repos are colocated: git `HEAD` is detached and the working copy is always a jj change, so `git commit` there does not move the branch.
- In a plain git repo, use git, and don't convert it to jj without asking.
