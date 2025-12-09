{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "tree-sitter-luau";
  version = "0-unstable-2025-12-08";

  src = fetchFromGitHub {
    owner = "polychromatist";
    repo = "tree-sitter-luau";
    rev = "71b03e66b2c8dd04e0133c9b998a54a58f239ca4";
    hash = "sha256-aXoq9NvJDzQLSuyanFL8dQepxTyK/k5y0APAJn1DZKI=";
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
