{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "tree-sitter-ziggy";
  version = "0.0.1-unstable-2025-08-19";

  src = fetchFromGitHub {
    owner = "kristoff-it";
    repo = "ziggy";
    rev = "4353b20ef2ac750e35c6d68e4eb2a07c2d7cf901";
    hash = "sha256-7XZNKUrOkpPMge6nDSiEBlUAf7dZLDcVcJ7fHT8fPh4=";
  };

  buildPhase = ''
    runHook preBuild
    $CC -shared -o parser tree-sitter-ziggy/src/*.c
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out

    mv parser $out/parser
    mv tree-sitter-ziggy/queries $out/

    runHook postInstall
  '';

  passthru = {
    nixUpdateArgs = [ "--version=branch" ];
  };

  meta = {
    homepage = "https://github.com/kristoff-it/ziggy";
    license = lib.licenses.mit;
  };
}
