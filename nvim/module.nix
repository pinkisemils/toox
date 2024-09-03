{ environment, pkgs, ... }:
let nvim = (import ./pkg.nix);
in {
  environment.systemPackages = [ nvim pkgs.git ];
  environment.shellInit = ''
    EDITOR=nvim;
  '';
}
