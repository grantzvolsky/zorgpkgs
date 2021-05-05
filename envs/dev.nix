{ pkgs ? <nixpkgs> }:

with pkgs;

let
  essential = [
    bashInteractive
    coreutils
    curl
    docker
    git
    gnumake
    gnupg
    jq
    less
    libxml2 # xmllint
    openapi-generator-cli
    pass
    skopeo # push docker images without docker daemon
    tmux
  ];
in essential
