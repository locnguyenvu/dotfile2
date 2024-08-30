with import <nixpkgs> { };

let
  pythonPackages = python312Packages;
in pkgs.mkShell rec {
  name = "python-3.12";
  venvDir = "./.venv";
  buildInputs = [
    # A Python interpreter including the 'venv' module is required to bootstrap
    # the environment.
    pythonPackages.python

    # This executes some shell code to initialize a venv in $venvDir before
    # dropping into the shell
    pythonPackages.venvShellHook

    # Those are dependencies that we would like to use from nixpkgs, which will
    # add them to PYTHONPATH and thus make them accessible from within the venv.
    pythonPackages.rich
    pythonPackages.python-lsp-server
    pythonPackages.yapf
    pythonPackages.isort
    pythonPackages.pynvim
  ];
}

