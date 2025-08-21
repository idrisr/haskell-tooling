{ stdenvNoCC, pkgs, python312Packages }:

let
  mytex = pkgs.texlive.combine {
    inherit (pkgs.texlive)
      scheme-medium
      latex-bin
      glossaries
      latexmk
      enumitem
      tcolorbox
      minted
      upquote
      biblatex
      titlesec
      pdfcol
      tikzfill
      xcolor
      ;
  };
in
stdenvNoCC.mkDerivation {
  name = "my-doc";
  pname = "my-doc";
  version = "0.1.0";
  src = ./src;

  nativeBuildInputs = [
    mytex
    pkgs.biber
    python312Packages.pygments
  ];

  buildPhase = ''
    latexmk -pdf -interaction=nonstopmode 00-main.tex
  '';

  installPhase = ''
    mkdir -p $out
    mv build/00-main.pdf $out/haskell-tooling.pdf
  '';
}
