{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation (final: {
  pname = "tree-sitter-ziggy";
  version = "fe3bf9389e7ff213cf3548caaf9c6f3d4bb38647";

  src = fetchFromGitHub {
    owner = "kristoff-it";
    repo = "ziggy";
    rev = final.version;
    hash = "sha256-w2WO2N3+XJWhWnt9swOux2ynKxmePbB4VojXM8K5GAo=";
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
})
