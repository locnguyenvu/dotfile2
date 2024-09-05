# dotfile2
Package manager with nix

## Installation

1. Install Nix: https://nix.dev/install-nix.html

2. Install home-manager: https://nix-community.github.io/home-manager/index.xhtml#ch-installation

3. Clone this repo and create a symbol link to location `/home/${USER}/.config/home-manager`. Replace following config with your info

```
home.user
home.homeDirectory

programs.git.userEmail
programs.git.userName
```

## Build
```
home-manager switch
```
