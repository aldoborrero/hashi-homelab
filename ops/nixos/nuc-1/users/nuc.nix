{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  users.enforceIdUniqueness = true;

  users.users.nuc = {
    isNormalUser = true;
    uid = 1026;
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keyFiles = [ ./keys/nuc-1.pub ];
    shell = pkgs.zsh;
  };

  home-manager.users.nuc = {
    home = {
      packages = with pkgs; [
        bind
        curl
        docker-compose
        ffmpeg-full
        git-absorb
        git-crypt
        handbrake
        httpie
        qrencode
        unzip
        wget
      ];
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.git = {
      enable = true;
      userName = "nuc";
      aliases = {
        a = "add";
        alias = "config --get-regexp ^alias\. | sed -e s/^alias\.// -e s/\ /\ =\ /";
        b = "branch";
        br = "b";
        co = "checkout";
        c = "co";
        cb = "checkout -b";
        cma = "commit --amend";
        cm = "commit";
        del-branch = "branch -D";
        db = "del-branch";
        f = "fetch -vp";
        l = "log --graph --pretty='%Cred%h%Creset - %C(bold blue)<%an>%Creset %s%C(yellow)%d%Creset %Cgreen(%cr)' --abbrev-commit --date=relative";
        p = "push";
        pl = "pull";
        pf = "pull -f";
        prune-branches = "!git remote prune origin && git branch -vv | grep ': gone]' | awk '{print $1}' | xargs -r git branch -d";
        pb = "prune-branches";
        pp = "!git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)";
        s = "status";
        st = "s";
        unstage = "reset HEAD --";
      };
      extraConfig = {
        branch.autosetuprebase = "always";
        fetch.parallel = 10;
        init.defaultBranch = "main";
        merge.conflictstyle = "diff3";
        push.default = "tracking";
        rebase.autoSquash = true;
        rebase.autoStash = true;
        submodule.recurse = true;
        # url."ssh://git@github.com/".insteadOf = "https://github.com/";
      };
    };

    programs.htop.enable = true;

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = with pkgs.vimPlugins; [
        ctrlp
        vim-airline
        vim-airline-themes
        vim-eunuch
        vim-gitgutter
        vim-markdown
        vim-nix
        typescript-vim
      ];
    };

    programs.zsh = {
      enable = true;
      autocd = true;
      enableAutosuggestions = true;
      history.extended = true;
      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        k = "kubectl";
        dc = "docker-compose";
        g = "git";
      };
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "direnv"
          "git"
          "git-extras"
          "gitfast"
          "history"
          "kubectl"
        ];
      };
    };
  }
    }
