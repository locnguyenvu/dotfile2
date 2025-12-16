{ config, lib, pkgs, ... }:
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
  home.enableNixpkgsReleaseCheck = true;

  home.packages = [
    pkgs._7zz
    pkgs.ast-grep
    pkgs.duckdb
    pkgs.eza
    pkgs.fd
    pkgs.fx
    pkgs.httpie
    pkgs.hurl
    pkgs.nerd-fonts.inconsolata
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.daddy-time-mono
    pkgs.iosevka
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
      gcof = ''git checkout $(git branch --list | rg -v $(git branch --show-current) | sk)'';
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
      tmuxPlugins.tmux-thumbs
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
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor 'macchiato'
          set -g @catppuccin_window_status_style "rounded"
          set -g status-left ""
          set -g @catppuccin_window_text " #W"
          set -g @catppuccin_window_current_text " #W"
          set -g @catppuccin_pane_default_text "##{b:pane_current_command}"
          set -g @catppuccin_window_flags "icon"
          set -g status-right "#{E:@catppuccin_status_directory}#{E:@catppuccin_status_session}"
        '';
      }
      {
        plugin = tmuxPlugins.tmux-floax;
        extraConfig = ''
          set -g @floax-bind 'f'
          set -g @floax-text-color 'white'
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
      amp-nvim
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
      toggleterm-nvim
      vim-commentary
      vim-dadbod-ui
      vim-dadbod-completion
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
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    enableJujutsuIntegration = true;
    options = {
      features = "decorations side-by-side line-number";
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
