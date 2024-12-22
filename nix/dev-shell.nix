{ mkShell, pkgs, ... }:

mkShell {
  nativeBuildInputs = with pkgs; [
    nim
    nimble
    nim_lk
    nim_builder
    bashInteractive
  ];
}
