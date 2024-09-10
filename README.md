# dotfile2
Package manager with nix

## Installation

1. Install Nix: https://nix.dev/install-nix.html

2. Install home-manager: https://nix-community.github.io/home-manager/index.xhtml#ch-installation

3. Update `home.nix`

Option 1:

Clone this repo and copy the `home-manager` directory to location `/home/${USER}/.config/home-manager`. Replace following config with your info

```
home.user
home.homeDirectory

```

Option 2:

Run the setup scrip

```
bash makehome.sh
```

## Build
```
home-manager switch
```
