{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (final: {
  pname = "tree-sitter-asciidoc";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "cathaysia";
    repo = "tree-sitter-asciidoc";
    rev = "v${final.version}";
    hash = "sha256-FPb39h4Tp/s4UiBtFAaN1hmK/ZRqVedg6coDYbgj4UE=";
  };

  buildPhase = ''
    runHook preBuild
    $CC -shared -o parser tree-sitter-asciidoc/src/*.c
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out

    mv parser $out/parser
    mv tree-sitter-asciidoc/queries $out/

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/cathaysia/tree-sitter-asciidoc";
    license = lib.licenses.asl20;
  };
})
