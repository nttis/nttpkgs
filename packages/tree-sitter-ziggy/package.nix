{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "tree-sitter-ziggy";
  version = "0.0.1-unstable-2025-11-23";

  src = fetchFromGitHub {
    owner = "kristoff-it";
    repo = "ziggy";
    rev = "9929674554b2c961fffbea86bad4101094b44609";
    hash = "sha256-pY3WyL0UDqGzUKtL++G/16yNrflIPpUerXtzcRTcGF0=";
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
