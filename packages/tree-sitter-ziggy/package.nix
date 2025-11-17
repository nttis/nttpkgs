{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "tree-sitter-ziggy";
  version = "0.0.1-unstable-2025-11-16";

  src = fetchFromGitHub {
    owner = "kristoff-it";
    repo = "ziggy";
    rev = "6eeb092b41b75dc91a821eded15f536869f7eb78";
    hash = "sha256-pNqwRKVmk5WncpBV+6Lgqmy5Ff/HyYYUGobDUrSzh5Y=";
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
