{ stdenvNoCC, pkgs, python312Packages }:

let
  tikz-uml = stdenvNoCC.mkDerivation {
    pname = "tikz-uml";
    version = "1.0-2016-03-29";
    src = pkgs.fetchurl {
      url = "https://perso.ensta-paris.fr/~kielbasi/tikzuml/var/files/src/tikzuml-v1.0-2016-03-29.tbz";
      hash = "sha256-DLxKIMjtQBYrO5qxQAsXQpPsGtdQjmQMqHnnjEWhBdA=";
    };
    buildInputs = [ pkgs.bzip2 ];
    unpackPhase = "tar -xjf $src";
    installPhase = ''
      mkdir -p $out/share/texmf/tex/latex/tikz-uml
      cp tikzuml-v1.0-2016-03-29/tikz-uml.sty *.tex $out/share/texmf/tex/latex/tikz-uml/
    '';
  };

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
    # extra = [ tikz-uml ];
  };
in
stdenvNoCC.mkDerivation {
  pname = "my-doc";
  version = "0.1.0";
  src = ./src;

  buildInputs = [
    mytex
    python312Packages.pygments
    pkgs.biber
  ];

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
    mv build/00-main.pdf $out/
  '';
}
