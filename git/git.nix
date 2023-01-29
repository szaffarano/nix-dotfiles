{pkgs}:
{
  enable = true;

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
    };
  };

  extraConfig = {
    user = {
      name  = "Sebastián Zaffarano";
      email = "sebas@zaffarano.com.ar";
      signingKey = "0x14F35C58A2191587";
    };
    log = {
      date = "iso";
      abrevCommit = true;
    };
    pull = {
      ff = "only";
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
    credential.helper = "keepassxc --unlock 0";
    commit.gpgsign = true;
    init.defaultBranch = "master";
  };

  includes = [
   	{ path = ./delta.conf; }
  ];
}
