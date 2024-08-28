# desktop-pc config

note: username and infra directory paths are hardcoded across nix files

contains my own NixOS configuration for my desktop PC and support for single GPU passthrough. Requires changes as it's mostly curated towards my needs.

```sh
sudo cp *.nix /etc/nixos/ && sudo nixos-rebuild switch
```

```sh
glab auth login
gh auth login
```

```sh
/home/s4m1nd/infra/nix/desktop-pc/switch-gpu-mode.sh passthrough
/home/s4m1nd/infra/nix/desktop-pc/switch-gpu-mode.sh normal
```

