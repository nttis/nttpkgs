{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "tree-sitter-ziggy";
  version = "0.0.1-unstable-2025-11-25";

  src = fetchFromGitHub {
    owner = "kristoff-it";
    repo = "ziggy";
    rev = "852053b09a5f8f5b79ca880f86ea77fc7da3dd6c";
    hash = "sha256-0CD49vWVALbGaEkUDLGDHPUaEXadSZIc4J80UvwmyfY=";
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
