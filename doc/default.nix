{ stdenvNoCC, texliveFull, python312Packages }:
stdenvNoCC.mkDerivation {
  name = "haskell tooling";
  pname = "haskell tooling";
  src = ./src;
  nativeBuildInputs = [ texliveFull python312Packages.pygments ];
  buildPhase = ''
    latexmk 00-main.tex
  '';
  installPhase = ''
    mkdir -p $out
    mv build/00-main.pdf $out/
  '';
}
