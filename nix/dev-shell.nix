{ mkShell, pkgs, ... }:

mkShell {
  nativeBuildInputs = with pkgs; [
    nim
    nimble
    nim_lk
    bashInteractive
  ];
}
