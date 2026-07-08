{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  pname = "incy";
  version = "3.3.0";

  src = pkgs.fetchzip {
    url = "https://github.com/INCY-DEV/incy-platforms/releases/download/desktop-v${version}/incy-linux-x64-portable.zip";
    # nix will print the correct hash on first build — paste it back here
    hash = "sha256-iET6G5Pjx7p3wx9rId0lsAflyqHF4iMpsY6bidmiHns=";
    stripRoot = true;  # set to false if the zip has no single top-level dir
  };

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    # X11 / GUI libs the bundled JRE + Compose need:
    libx11
    libxext
    libxrender
    libxtst
    libxi
    libxrandr
    libxcursor
    libxxf86vm
    wayland
    libxkbcommon
    libGL
    mesa
    freetype
    fontconfig
    alsa-lib
    gtk3
    glib
    cairo
    pango
    gdk-pixbuf
  ];

  # JVM is interpreted; don't strip or it breaks signatures/jars
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/incy
    cp -r . $out/opt/incy
    chmod +x $out/opt/incy/bin/incy

    mkdir -p $out/bin
    makeWrapper $out/opt/incy/bin/incy $out/bin/incy \
      --prefix PATH : ${pkgs.lib.makeBinPath (with pkgs; [
        iproute2 iptables openresolv coreutils
      ])} \
      --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath buildInputs}

    runHook postInstall
  '';
}
