# Large, occasional tooling, in no host or user aspect. Use ad hoc
# (`nix shell nixpkgs#qemu`, `, gcloud`), or add `den.aspects.packages-heavy`
# to one host's `includes`.
{
  den.aspects.packages-heavy.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        android-tools # 1.4 GiB
        google-cloud-sdk # 1.9 GiB
        ollama
        qemu # 2.3 GiB
      ];
    };
}
