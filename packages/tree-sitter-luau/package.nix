{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation (final: {
  pname = "tree-sitter-luau";
  version = "ec187cafba510cddac265329ca7831ec6f3b9955";

  src = fetchFromGitHub {
    owner = "polychromatist";
    repo = "tree-sitter-luau";
    rev = final.version;
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
})
