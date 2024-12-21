{
  description = "A very low memory-footprint, self hosted API-only torrent search engine. Sonarr + Radarr Compatible";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
      };
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://pre-commit-hooks.cachix.org"
    ];
    extra-trusted-public-keys = [
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
    ];
    sandbox = false;
  };

  outputs =
    {
      nixpkgs,
      git-hooks,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pre-commit = pkgs.callPackage ./nix/pre-commit.nix {
          inherit git-hooks system;
          src = ./.;
        };
      in
      {
        checks = {
          inherit (pre-commit) check;
        };

        apps = {
          inherit (pre-commit) install-hooks;
        };

        formatter = pkgs.nixfmt-rfc-style;

        devShells.default = pkgs.callPackage ./nix/dev-shell.nix { };
      }
    );
}
