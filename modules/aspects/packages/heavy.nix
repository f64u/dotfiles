# Large, occasionally-used tooling. NOT included by any host or user aspect --
# reach for these ad hoc instead:
#
#   nix shell nixpkgs#qemu
#   , gcloud
#
# To have them permanently on one machine, add `den.aspects.packages-heavy` to
# that host's `includes` rather than to the shared user aspect.
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
