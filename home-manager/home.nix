{ config, pkgs, ... }:

with builtins;

{
  home.username = "#username";
  home.homeDirectory = "#homedir";

  home.stateVersion = "24.05"; # Please read the comment before changing.
  home.enableNixpkgsReleaseCheck = false;

  home.packages = [
    pkgs._7zz
    pkgs.delta
    pkgs.eza
    pkgs.fd
    pkgs.httpie
    pkgs.inconsolata-nerdfont
    pkgs.pueue
    pkgs.ripgrep
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
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
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
        "python"
      ];
      prompt = {
        theme = "nicoulaj";
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
  };
  programs.tmux = {
    baseIndex = 1;
    enable = true;
    keyMode = "vi";
    mouse = true;
    prefix = "C-b";
    tmuxinator = {
      enable = true;
    };
    extraConfig = 
      ''
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection
      bind-key -T copy-mode-vi 'y' send-keys -X copy-pipe-and-cancel “reattach-to-user-namespace pbcopy”
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R
      bind-key c new-window -c "#{pane_current_path}"
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      '';
    plugins = with pkgs; [
      tmuxPlugins.cpu
      tmuxPlugins.tmux-fzf
      tmuxPlugins.open
      tmuxPlugins.better-mouse-mode
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
        '';
      }
      {
        plugin = tmuxPlugins.dracula;
        extraConfig = ''
          set -g @dracula-show-left-icon session
          set -g @dracula-show-fahrenheit false
        '';
      }
    ];
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.bat = {
    enable = true;
  };
  programs.neovim = {
    defaultEditor = true;
    enable = true;
    withPython3 = true;
    withNodeJs = true;
    extraConfig = builtins.readFile nvim/vimrc;
    extraLuaConfig = builtins.readFile nvim/init.lua;
    plugins = with pkgs.vimPlugins; [
      bufferline-nvim
      cmp-nvim-lsp
      cmp-nvim-lua
      flash-nvim
      gruvbox
      indent-blankline-nvim
      lspsaga-nvim
      lualine-nvim
      nvim-cmp
      nvim-cursorline
      nvim-lspconfig
      nvim-tree-lua
      nvim-treesitter.withAllGrammars
      nvim-web-devicons
      telescope-nvim
      vim-repeat
    ];
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.git = {
    enable = true;
    delta = {
      enable = true;
      options = {
        features = "decorations side-by-side line-number";
      };
    };
  };
  programs.eza = {
      enable = true;
      enableZshIntegration = true;
  };
  programs.jujutsu = {
      enable = true;
  };
}
