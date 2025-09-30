{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "tree-sitter-luau";
  version = "0-unstable-2025-03-15";

  src = fetchFromGitHub {
    owner = "polychromatist";
    repo = "tree-sitter-luau";
    rev = "ec187cafba510cddac265329ca7831ec6f3b9955";
    hash = "sha256-a+TJFLt77G4UyvcLz5Nsc6gvsgCTwmpZDNyfN8YUJDc=";
  };

  buildPhase = ''
    runHook preBuild
    $CC -shared -o parser src/*.c
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out

    mv parser $out/parser
    mv helix-queries $out/queries

    runHook postInstall
  '';

  passthru = {
    nixUpdateArgs = [ "--version=branch" ];
  };

  meta = {
    homepage = "https://github.com/polychromatist/tree-sitter-luau";
    license = lib.licenses.mit;
  };
}
