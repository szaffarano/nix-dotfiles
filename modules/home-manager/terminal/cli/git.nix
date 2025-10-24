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
      url = "https://raw.githubusercontent.com/dandavison/delta/0.18.2/themes.gitconfig";
      sha256 = "sha256-7G/Dz7LPmY+DUO/YTWJ7hOWp/e6fx+08x22AeZxnx5U=";
    };
  in {
    programs = {
      fish = lib.mkIf (config.programs.fish.enable
        && config.programs.git.enable) {
        shellAliases = {
          gc = "git commit";
          gps = "git push";
          gs = "git status";
        };
      };
      delta = lib.mkIf config.programs.git.enable {
        enable = true;
        options = {
          features = "chameleon";
          side-by-side = false;
        };
      };
      gh = lib.mkIf gh_enabled {
        enable = true;
        extensions = with pkgs; [
          gh-dash
          gh-copilot
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
      git = lib.mkIf config.programs.git.enable {
        package = pkgs.gitFull;

        lfs.enable = true;

        settings = {
          branch.sort = "-committerdate";

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
            wl = "worktree list";
            wa = "!f() { b=$1; git worktree add ../$b -b szaffarano/$b; }; f";
            wr = "!f() { b=$1; git worktree remove ../$b && git branch -D szaffarano/$b; }; f";
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
          column.ui = "auto";
          commit.gpgsign = true;
          tag.gpgsign = true;
          core = {
            editor = "nvim";
            fsmonitor = true;
            untrackedCache = true;
          };
          credential.helper = lib.optionals config.desktop.tools.keepassxc.enable "keepassxc --unlock 0";
          diff.tool = "vimdiff";
          fetch.prune = true;
          init.defaultBranch = "master";
          log = {
            date = "iso";
            abbrevCommit = true;
          };
          merge.conflictstyle = "zdiff3";
          merge.tool = "vimdiff";
          mergetool.vimdiff.path = "nv";
          pull.ff = "only";
          push = {
            autoSetupRemote = true;
            default = "simple";
            followTags = true;
          };
          rebase = {
            autoSquash = true;
            autoStash = true;
          };
          rerere = {
            enabled = true;
            autoUpdate = true;
          };
        };

        includes = [
          {path = delta.themes;}
          {path = "~/.config/git/config.local";}
        ];
      };
    };
    home = lib.mkIf config.programs.git.enable {
      custom = {
        allowed-unfree-packages = with pkgs; [gh-copilot];
        features.register = "gh";
      };
      packages = with pkgs;
        lib.optionals config.desktop.tools.keepassxc.enable [
          (git-credential-keepassxc.override {
            withAll = true;
          })
        ]
        ++ [lazygit];
    };
  };
}
