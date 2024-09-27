# user.nix
{ config, pkgs, lib, ... }:
let
  looking-glass-client-b6 = pkgs.callPackage ./looking-glass-client.nix {};
in
{
  users.users.s4m1nd = {
    isNormalUser = true;
    description = "s4m1nd";
    extraGroups = [ "networkmanager" "wheel" "input" "libvirtd" "kvm" "usb" "disk" ];
    shell = pkgs.fish;
  };

  nixpkgs.config.packageOverrides = pkgs: {
    looking-glass-client = pkgs.runCommand "dummy" {} "mkdir $out";
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" "Hack" ]; })
  ];

  environment.systemPackages = with pkgs; [
    vim wget ansible asdf-vm bun python3 curl eza fd fish fzf git
    htop jq neovim ripgrep stow tmux _1password-gui gh glab kubectl k9s
    doctl terraform terraform-providers.vault discord slack zed-editor
    neofetch usbutils fishPlugins.foreign-env xclip wl-clipboard rustup nodejs_22
    unzip tmux xorg.xmodmap gnome.gnome-tweaks pciutils virt-manager
    qemu OVMF nvme-cli numactl unigine-valley ungoogled-chromium remmina
    cmake binutils gcc gnumake fontconfig looking-glass-client-b6
    pkg-config dmidecode vmfs-tools dnsmasq
    neovim-unwrapped  # This includes GUI support
    (pkgs.writeShellScriptBin "clipboard-provider" ''
      #!${pkgs.bash}/bin/bash
      if [ -n "$WAYLAND_DISPLAY" ]; then
        if [ "$1" = "copy" ]; then
          ${pkgs.wl-clipboard}/bin/wl-copy
        else
          ${pkgs.wl-clipboard}/bin/wl-paste
        fi
      else
        if [ "$1" = "copy" ]; then
          ${pkgs.xclip}/bin/xclip -in -selection clipboard
        else
          ${pkgs.xclip}/bin/xclip -out -selection clipboard
        fi
      fi
    '')
  ];

  environment.shellAliases = {
    pbcopy = "clipboard-provider copy";
    pbpaste = "clipboard-provider paste";
  };

  environment.etc."unaccounted-for-looking-glass-b7-rc1".source = pkgs.runCommand "remove-looking-glass-b7-rc1" {} ''
    mkdir -p $out
    rm -rf /nix/store/s28jyrz64yc3k64lix1bnb5vgv7561r3-looking-glass-client-B7-rc1
  '';

  systemd.services.looking-glass-permissions = {
    description = "Set permissions for Looking Glass shared memory";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-udev-settle.service" ];
    script = ''
      ${pkgs.coreutils}/bin/chown s4m1nd:qemu-libvirtd /dev/shm/looking-glass
      ${pkgs.coreutils}/bin/chmod 660 /dev/shm/looking-glass
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Disable the welcome message
      function fish_greeting
      end
      # Initialize asdf
      set -l asdf_path (dirname (dirname (readlink -f (which asdf))))
      if test -f $asdf_path/share/asdf-vm/asdf.fish
        source $asdf_path/share/asdf-vm/asdf.fish
      else if test -f /run/current-system/sw/share/asdf-vm/asdf.fish
        source /run/current-system/sw/share/asdf-vm/asdf.fish
      end

      if status is-interactive
        fish_vi_key_bindings
      end

      set -gx PATH $PATH
      alias vim="nvim"
      alias cat='cat -v'

      function fish_mode_prompt
        switch $fish_bind_mode
          case default
            set_color --bold green
            echo '[N] '
          case insert
            set_color blue --bold
            echo '[I] '
          case replace_one
            set_color --bold green
            echo '[R] '
          case visual
            set_color --bold brmagenta
            echo '[V] '
          case '*'
            set_color --bold red
            echo '[?]'
        end
        set_color normal
      end

      bind -M insert '  ' accept-autosuggestion execute
      set -x TERM xterm-256color

      function pbcopy
        clipboard-provider copy
      end

      function pbpaste
        clipboard-provider paste
      end
    '';
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g escape-time 0
      set -g history-limit 1000000
      set -g renumber-windows on
      set -g @plugin 'tmux-plugins/tpm'
      set -g @plugin 'tmux-plugins/tmux-sensible'
      set -g @plugin 'fcsonline/tmux-thumbs'
      run-shell ~/.tmux/plugins/tmux-thumbs/tmux-thumbs.tmux
      run '~/.tmux/plugins/tpm/tpm'
      set-window-option -g mode-keys vi
      set -s set-clipboard on
      set -g mouse on
      
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "clipboard-provider copy"
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "clipboard-provider copy"
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "clipboard-provider copy"
      
      # Paste using prefix + p
      bind p run "clipboard-provider paste | tmux load-buffer - ; tmux paste-buffer"
      
      set -s escape-time 0
      set -g status-right "#{?pane_synchronized,#[bg=green] synced ,}#{?window_zoomed_flag,#[fg=red] zoomed ,}#{?window_list,#{window_list}}#{?pane_current_command,, #[fg=white]#[bg=red] #H #[fg=white]#[bg=default]}"
      set -g status-style fg=yellow,bg=default
      set -g prefix C-a
      set -g @thumbs-alphabet azerty
      set -g @thumbs-command 'echo -n {} | clipboard-provider copy'
      bind-key y select-layout even-horizontal 
      bind-key u select-layout even-vertical 
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R
    '';
  };

  system.activationScripts = {
    tmuxPluginInstall = {
      text = ''
        if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
          ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
        fi
        if [ ! -d "$HOME/.tmux/plugins/tmux-thumbs" ]; then
          ${pkgs.git}/bin/git clone https://github.com/fcsonline/tmux-thumbs "$HOME/.tmux/plugins/tmux-thumbs"
        fi
      '';
      deps = [];
    };
  };

  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "us";
      options = "ctrl:nocaps";
    };
  };

  # Enable GNOME extensions
  services.gnome.core-utilities.enable = true;
  services.gnome.gnome-settings-daemon.enable = true;

  # Set up clipboard synchronization
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xclip}/bin/xclip -selection clipboard -i /dev/null
  '';
}
