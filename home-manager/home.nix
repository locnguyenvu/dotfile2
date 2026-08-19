{ config, lib, pkgs, ... }:
{
  home.username = "#username";
  home.homeDirectory = "#homedir";

  home.stateVersion = "unstable"; # Please read the comment before changing.
  home.enableNixpkgsReleaseCheck = true;

  home.packages = [
    pkgs._7zz
    pkgs.eza
    pkgs.fd
    pkgs.fx
    pkgs.httpie
    pkgs.jq
    pkgs.neovim
    pkgs.nerd-fonts.daddy-time-mono
    pkgs.process-compose
    pkgs.procs
    pkgs.ripgrep
    pkgs.skim
    pkgs.tree-sitter
    pkgs.tmux
    pkgs.yazi
    pkgs.yq-go
    pkgs.zoxide
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    GIT_PAGER = "delta";
    NIXPKGS_ALLOW_UNFREE = 1;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting = {
      enable = true;
    };
    shellAliases = {
      ll = "eza -l --icons";
      gfmc = ''git pull origin $(git branch --show-current)'';
      gcof = ''git checkout $(git branch --list | rg -v $(git branch --show-current) | sk)'';
      pc = "process-compose";
      kb = "kubectl";
      jjl = "jj log --no-pager --limit 10";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    profileExtra = ''
    path=(
      $HOME/.nix-profile/bin
      $HOME/.local/bin
      $path
    )
    '';
    prezto = {
      enable = true;
      editor = {
        keymap = "vi";
        promptContext = true;
      };
      pmodules = [
        "environment"
        "terminal"
        "editor"
        "history"
        "directory"
        "spectrum"
        "utility"
        "completion"
        "history-substring-search"
        "prompt"
        "git"
        "tmux"
      ];
      prompt = {
        theme = "nicoulaj";
      };
      syntaxHighlighting = {
        highlighters = [
          "main"
          "brackets"
          "pattern"
          "line"
          "cursor"
          "root"
        ];
      };
    };
  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    historyWidget.command = "";
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      aws = {
        disabled = true;
      };
    };
  };
  programs.bat = {
    enable = true;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    enableJujutsuIntegration = true;
    options = {
      features = "decorations line-number";
    };
  };
  programs.git = {
    enable = true;
    ignores = [
      ".env*"
      ".rgignore"
      ".venv"
    ];
  };
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.jujutsu = {
    enable = true;
  };
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      filter_mode_shell_up_key_binding = "session";
      keymap_mode = "vim-insert";
      enter_accept = true;
      invert = false;
      inline_height = 10;
      ctrl_n_shortcuts = true;
    };
  };
}
