{
  lib,
  writeShellApplication,
  coreutils,
}:
(writeShellApplication {
  name = "live-nvim";
  runtimeInputs = [coreutils];
  text = builtins.readFile ./live-nvim.sh;
})
// {
  meta = with lib; {
    description = "Toggle between live and managed Neovim configuration";
    licenses = licenses.mit;
    platforms = platforms.all;
    mainProgram = "live-nvim";
  };
}
