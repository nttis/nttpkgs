{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "tree-sitter-ziggy";
  version = "0.0.1-unstable-2025-11-14";

  src = fetchFromGitHub {
    owner = "kristoff-it";
    repo = "ziggy";
    rev = "a246334e7a1d3f43f9f76a4af6c6d179d37b188f";
    hash = "sha256-1uUgd1d+UHWsAxPTaCDyJZmPSg2PPPialCNBIgu79ck=";
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
