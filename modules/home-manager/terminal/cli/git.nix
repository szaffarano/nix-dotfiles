{
  config,
  lib,
  pkgs,
  ...
}: let
  gh_feature = "gh";

  gh_enabled = builtins.elem gh_feature config.home.custom.features.enable;
in {
  config = let
    delta.themes = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/dandavison/delta/0.15.1/themes.gitconfig";
      sha256 = "sha256-J/6+8kkxzSFPfYzAPAFd/vZrT6hXjd+N2+cWdb+/b8M=";
    };
  in {
    programs.git = lib.mkIf config.programs.git.enable {
      package = pkgs.gitAndTools.gitFull;

      aliases = {
        br = "branch";
        ci = "commit";
        co = "checkout";
        cpa = "cherry-pick --abort";
        cpc = "cherry-pick --continue";
        cpx = "cherry-pick -x";
        dc = "diff --cached";
        df = "diff";
        shf = "show --name-only --format=''";
        sho = "show --name-only";
        st = "status";
        wa = "worktree add";
        wl = "worktree list";
        wr = "worktree remove";
      };

      delta = {
        enable = true;
        options = {
          features = "chameleon";
          side-by-side = false;
        };
      };

      extraConfig = {
        column.ui = "auto";

        rerere.enable = true;

        branch.sort = "-committerdate";

        core.fsmonitor = true;
        core.untrackedCache = true;

        log = {
          date = "iso";
          abbrevCommit = true;
        };
        color = {
          branch = {
            current = "yellow reverse";
            local = "yellow";
            remote = "green";
          };
          status = {
            added = "yellow";
            changed = "red";
            untracked = "cyan";
          };
          diff = {
            meta = "yellow bold";
            frag = "magenta bold";
            old = "red bold";
            new = "green bold";
          };
        };
        credential.helper = lib.optionals config.desktop.tools.keepassxc.enable "keepassxc --unlock 0";
        commit.gpgsign = true;
        init.defaultBranch = "master";
        fetch.prune = true;
        pull.ff = "only";
      };

      includes = [
        {path = delta.themes;}
        {path = "~/.config/git/config.local";}
      ];
    };

    home = {
      custom.features.register = "gh";
      packages = with pkgs; (lib.optionals config.desktop.tools.keepassxc.enable [
        (git-credential-keepassxc.override {
          withNotification = true;
          withYubikey = true;
        })
      ]);
    };

    programs.gh = lib.mkIf gh_enabled {
      enable = true;
      extensions = with pkgs; [
        gh-dash
        gh-markdown-preview
      ];
      settings = {
        git_protocol = "https";
        prompt = "enabled";
        editor = "nvim";
        aliases = {
          co = "pr checkout";
          pv = "pr view";
        };
      };
    };
  };
}
