{ config
, lib
, pkgs
, ...
}:
let
  userOptions =
    with lib;
    types.submodule {
      options = {
        name = mkOption {
          type = types.str;
          default = "";
        };
        email = mkOption {
          type = types.str;
          default = "";
        };
        signingKey = mkOption {
          type = types.str;
          default = "";
        };
      };
    };
in
{
  options.git = {
    enable = lib.mkEnableOption "git";
    user = lib.mkOption { type = userOptions; };
  };

  config =
    let
      delta.themes = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/dandavison/delta/0.15.1/themes.gitconfig";
        sha256 = "sha256-J/6+8kkxzSFPfYzAPAFd/vZrT6hXjd+N2+cWdb+/b8M=";
      };
    in
    lib.mkIf config.git.enable {
      programs.git = {
        enable = true;
        package = pkgs.gitAndTools.gitFull;

        aliases = {
          st = "status";
          ci = "commit";
          br = "branch";
          co = "checkout";
          df = "diff";
          dc = "diff --cached";
          sho = "show --name-only";
          shf = "show --name-only --format=''";
          cpx = "cherry-pick -x";
          cpa = "cherry-pick --abort";
          cpc = "cherry-pick --continue";
        };

        delta = {
          enable = true;
          options = {
            features = "chameleon";
            side-by-side = false;
          };
        };

        extraConfig = {
          user = {
            name = lib.mkIf (config.git.user.name != "") config.git.user.name;
            email = lib.mkIf (config.git.user.email != "") config.git.user.email;
            signingKey = lib.mkIf (config.git.user.signingKey != "") config.git.user.signingKey;
          };

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
          { path = delta.themes; }
          { path = "~/.config/git/config.local"; }
        ];
      };

      home = {
        packages =
          with pkgs;
          (lib.optionals config.desktop.tools.keepassxc.enable [
            (git-credential-keepassxc.override {
              withNotification = true;
              withYubikey = true;
            })
          ]);
      };

      programs.gh = {
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
