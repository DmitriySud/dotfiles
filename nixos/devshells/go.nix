{ pkgs }:
pkgs.mkShell {
  name = "go-dev";

  packages = with pkgs; [
    go
    gopls
    gotools # goimports, godoc, ...
    go-tools # staticcheck
    delve # dlv debugger
    golangci-lint
  ];

  shellHook = ''
    echo "go dev :: $(go version)"
  '';
}
