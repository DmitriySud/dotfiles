{ pkgs }:
pkgs.mkShell {
  name = "cpp-dev";

  # Both toolchains available; pick per project via CC/CXX or cmake flags.
  packages = with pkgs; [
    clang
    clang-tools # clangd, clang-format, clang-tidy
    gcc
    gdb
    lldb

    cmake
    ninja
    gnumake
    pkg-config

    ccache
    valgrind
  ];

  shellHook = ''
    echo "cpp dev :: gcc $(gcc -dumpversion) | $(clang --version | head -n1)"
  '';
}
