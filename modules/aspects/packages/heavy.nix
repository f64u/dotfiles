# Large, occasionally-used tooling.
#
# NOT included by any host or user aspect. These are multi-gigabyte closures
# that were previously in packages-development, where they were rebuilt and
# kept alive in every generation despite being reached for a few times a year.
#
# Get one ad hoc instead:
#
#   nix shell nixpkgs#qemu          # a shell with it on PATH
#   , gcloud                        # comma: run it once, don't install it
#
# Or, to have them permanently on a particular machine, add
# `den.aspects.packages-heavy` to that host's `includes` (see
# modules/aspects/hosts/) rather than to the shared user aspect.
{
  den.aspects.packages-heavy.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        android-tools # 1.4 GiB
        google-cloud-sdk # 1.9 GiB
        ollama
        postman
        qemu # 2.3 GiB
      ];
    };
}
