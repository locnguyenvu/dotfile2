{ config, pkgs, ... }:
let
  exVimPlugin = { user, repo, rev ? "main" }: pkgs.vimUtils.buildVimPlugin {
    pname = "${repo}";
    version = rev;
    src = builtins.fetchGit { url = "https://github.com/${user}/${repo}.git"; ref = rev; };
  };
in
with builtins;
{
  home.username = "#username";
  home.homeDirectory = "#homedir";

  home.stateVersion = "unstable"; # Please read the comment before changing.
  home.enableNixpkgsReleaseCheck = false;

  home.packages = [
    pkgs._7zz
    pkgs.ast-grep
    pkgs.delta
    pkgs.duckdb
    pkgs.eza
    pkgs.fd
    pkgs.fx
    pkgs.httpie
    pkgs.hurl
    pkgs.mitmproxy
    pkgs.nerd-fonts.inconsolata
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.daddy-time-mono
    pkgs.cascadia-code
    pkgs.procs
    pkgs.process-compose
    pkgs.ripgrep
    pkgs.skim
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
      gcof = ''git checkout $(git branch --list | rg -v $(git branch --show-current) | fzf)'';
      pc = "process-compose";
      kb = "kubectl";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    profileExtra = ''
    path=(
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
      set -g default-command $SHELL
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
    extraWrapperArgs = [
        "--set" "BUNDLE_DISABLE_SHARED_GEMS" "true"
        "--unset" "GEM_HOME"
    ];
    plugins = with pkgs.vimPlugins; [
      bufferline-nvim
      cmp-nvim-lsp
      cmp-nvim-lua
      flash-nvim
      gruvbox
      hologram-nvim
      indent-blankline-nvim
      lspsaga-nvim
      lualine-nvim
      go-nvim
      nvim-dap
      nvim-dap-ui
      nvim-cmp
      nvim-cursorline
      nvim-navbuddy
      nvim-lspconfig
      nvim-tree-lua
      nvim-treesitter.withAllGrammars
      nvim-web-devicons
      telescope-nvim
      tender-vim
      vim-commentary
      vim-fugitive
      vim-repeat
      kitty-scrollback-nvim
      yazi-nvim
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
    ignores = [
      ".env*"
      ".rgignore"
      ".venv"
      "_"
      "__debug_bin*"
    ];
  };
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.jujutsu = {
    enable = true;
  };
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      default_layout = "compact";
    };
  };
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = ["--disable-ctrl-r"];
    settings = {
      filter_mode_shell_up_key_binding = "session";
      keymap_mode = "vim-normal";
      enter_accept = true;
      invert = false;
      inline_height = 10;
      ctrl_n_shortcuts = true;
    };
  };
  services.skhd = {
    enable = true;
  };
}
