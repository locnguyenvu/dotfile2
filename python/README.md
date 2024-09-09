# Setup python env for each project

## Prerequisite

1. `direnv` is available
2. `nix` is available

## Setup

1. Copy `shell.nix` file to the project directory

2. Trigger the nix shell with direnv

```
echo "use nix shell.nix" | tee -a .envrc
```

3. Activate `nix-shell` with direnv

```
direnv allow
```

## Features

1. Auto activate `venv` when change location to project directory

2. Pre-install development tool
