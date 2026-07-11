{ pkgs }:
{
  cpp = import ./cpp.nix { inherit pkgs; };
  go = import ./go.nix { inherit pkgs; };
}
