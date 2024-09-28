with import <nixpkgs> { };

pkgs.mkShellNoCC rec {
  name = "py312";
  venvDir = "./.venv";
  buildInputs = [
    # A Python interpreter including the 'venv' module is required to bootstrap
    # the environment.
    python312Packages.python

    # This executes some shell code to initialize a venv in $venvDir before
    # dropping into the shell
    python312Packages.venvShellHook

    # Those are dependencies that we would like to use from nixpkgs, which will
    # add them to PYTHONPATH and thus make them accessible from within the venv.
    python312Packages.rich
    python312Packages.python-lsp-server
    python312Packages.python-lsp-ruff
    python312Packages.pylsp-rope
    python312Packages.yapf
    python312Packages.isort
    python312Packages.pynvim
    python312Packages.icecream
  ];
  packages = with pkgs; [
    uv
    poetry
    meson
  ];
}

