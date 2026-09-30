{
  lib,
  stdenv,
  makeWrapper,
  wrapGAppsHook4,
  gobject-introspection,
  gtk4,
  hyprland,
  python3,
  mermaid-cli,
  wl-clipboard,
  xvfb-run,
  xauth,
}:

let
  pythonEnv = python3.withPackages (ps: [ ps.pygobject3 ]);
in
stdenv.mkDerivation {
  pname = "mermaid-viewer";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [
    gobject-introspection
    makeWrapper
    wrapGAppsHook4
  ];
  nativeCheckInputs = [
    pythonEnv
    xauth
    xvfb-run
  ];

  buildInputs = [
    gtk4
    pythonEnv
  ];

  dontBuild = true;

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    patchShebangs tests/fixtures
    chmod +x tests/fixtures/fake_renderer.py tests/fixtures/fake_clipboard.py
    xvfb-run -a env GDK_BACKEND=x11 \
      ${lib.getExe pythonEnv} -m unittest discover -s tests -v
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 app.py $out/share/mermaid-viewer/app.py
    install -Dm644 core.py $out/share/mermaid-viewer/core.py
    install -Dm644 hyprland.py $out/share/mermaid-viewer/hyprland.py
    install -Dm644 puppeteer-config.json \
      $out/share/mermaid-viewer/puppeteer-config.json
    install -Dm644 mermaid-config.json \
      $out/share/mermaid-viewer/mermaid-config.json

    makeWrapper ${lib.getExe pythonEnv} $out/bin/mermaid-viewer \
      --add-flags $out/share/mermaid-viewer/app.py \
      --set MERMAID_VIEWER_CONFIG $out/share/mermaid-viewer/mermaid-config.json \
      --set MERMAID_VIEWER_PUPPETEER_CONFIG $out/share/mermaid-viewer/puppeteer-config.json \
      --prefix PATH : ${lib.makeBinPath [ hyprland mermaid-cli wl-clipboard ]}

    runHook postInstall
  '';

  meta = {
    description = "Small GTK editor and viewer for Mermaid diagrams";
    license = lib.licenses.mit;
    mainProgram = "mermaid-viewer";
    platforms = lib.platforms.linux;
  };
}
