{
  lib,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
  versionCheckHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "codex";
  version = "0.153.4";

  src = fetchurl {
    urls = [
      "https://releases.openai.com/codex/releases/${finalAttrs.version}/codex-package-x86_64-unknown-linux-musl.tar.gz"
      "https://github.com/openai/codex/releases/download/rust-v${finalAttrs.version}/codex-package-x86_64-unknown-linux-musl.tar.gz"
    ];
    hash = "sha256-qCIYfhokIMYcWSZyG/vYeHAe2VVHybsNTeRJiha6GCE=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ installShellFiles ];

  dontBuild = true;
  dontPatchELF = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -R bin codex-package.json codex-path codex-resources "$out/"
    chmod 0755 \
      "$out/bin/codex" \
      "$out/bin/codex-code-mode-host" \
      "$out/codex-path/rg" \
      "$out/codex-resources/bwrap"

    installShellCompletion --cmd codex \
      --bash <("$out/bin/codex" completion bash) \
      --fish <("$out/bin/codex" completion fish) \
      --zsh <("$out/bin/codex" completion zsh)

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Lightweight coding agent that runs in your terminal";
    homepage = "https://github.com/openai/codex";
    changelog = "https://github.com/openai/codex/releases/tag/rust-v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "codex";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
