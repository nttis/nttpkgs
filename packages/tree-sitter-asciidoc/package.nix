{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (final: {
  pname = "tree-sitter-asciidoc";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "cathaysia";
    repo = "tree-sitter-asciidoc";
    rev = "v${final.version}";
    hash = "sha256-zpb3WS2RjVbVzGdExRoUFgYtzjmsV9pu/C913JEzmFo=";
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

  meta = {
    homepage = "https://github.com/cathaysia/tree-sitter-asciidoc";
    license = lib.licenses.asl20;
  };
})
