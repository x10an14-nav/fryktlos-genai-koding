{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };
  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;
      # Small tool to iterate over each systems
      eachSystem =
        f: lib.genAttrs [ "x86_64-linux" ] (system: f (import inputs.nixpkgs { inherit system; }));
      repoRoot = ./.;

      # Typst with packages pinned from nixpkgs' typstPackages mirror of
      # Typst Universe. Add new packages here as your slides start using them.
      typstWithPkgsFor = pkgs: pkgs.typst.withPackages (tp: [ tp.touying_0_5_3 ]);

      # Python med pikepdf, brukt av tools/inject-notes.py for å
      # injisere speaker-notes som PDF text-annotations. Lar pdfpc lese
      # notatene uten sidecar-fil.
      pythonWithPdfToolsFor = pkgs: pkgs.python3.withPackages (ps: [ ps.pikepdf ]);
    in
    {
      devShells = eachSystem (pkgs: {
        default = pkgs.mkShell {
          packages = [
            (typstWithPkgsFor pkgs)
            pkgs.tinymist # LSP for Typst (editor integration)
            pkgs.typstyle # formatter for Typst
            pkgs.kdePackages.okular
            pkgs.pdfpc
          ];
        };
      });

      apps = eachSystem (pkgs: rec {
        default = presenter;
        presenter = {
          type = "app";
          # Wrap in a script: `program` must be a single executable path,
          # not a command line. Passing "pdfpc <pdf>" directly makes nix run
          # try to execve the whole string as one filename.
          program = toString (
            pkgs.writeShellScript "presenter-lysark" ''
              exec ${lib.getExe pkgs.pdfpc} ${inputs.self.packages.${pkgs.system}.lysark}
            ''
          );
        };
        bygg = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "bygg-lysark" ''
              # Use $PWD so typst writes slides.pdf next to the source; the
              # flake's repoRoot would resolve to a read-only /nix/store path.
              exec ${lib.getExe (typstWithPkgsFor pkgs)} watch \
                --root "$PWD" \
                "$PWD/slides.typ"
            ''
          );
        };
        bygg-notater = {
          type = "app";
          # Watch-modus som `bygg`, men med --input notes=true slik at
          # speaker-notes rendres ved siden av hver slide. Skriver til
          # slides-med-notater.pdf for å ikke kollidere med presentasjons-
          # PDF-en (slides.pdf) som `utkast` viser.
          program = toString (
            pkgs.writeShellScript "bygg-lysark-notater" ''
              exec ${lib.getExe (typstWithPkgsFor pkgs)} watch \
                --root "$PWD" \
                --input notes=true \
                "$PWD/slides.typ" \
                "$PWD/slides-med-notater.pdf"
            ''
          );
        };
        utkast = {
          type = "app";
          # Opens $PWD/slides.pdf in zathura, which auto-reloads on file
          # change. Run alongside `bygg` in a separate terminal.
          program = toString (
            pkgs.writeShellScript "utkast-lysark" ''
              exec ${lib.getExe pkgs.zathura} "$PWD/slides.pdf"
            ''
          );
        };
      });

      packages = eachSystem (pkgs: rec {
        default = lysark;
        # `lysark` har speaker-notes innebygd som PDF text-annotations:
        # touying emitter `<pdfpc-file>`-metadata via `typst query`, og
        # tools/inject-notes.py (pikepdf) legger notatene inn i PDF-en.
        # pdfpc leser dem som "native" notater uten sidecar-fil.
        lysark =
          pkgs.runCommand "slides.pdf"
            {
              nativeBuildInputs = [
                (typstWithPkgsFor pkgs)
                (pythonWithPdfToolsFor pkgs)
              ];
            }
            # Bash
            ''
              typst compile \
                --format pdf \
                --root ${repoRoot} \
                ${repoRoot}/slides.typ \
                slides-raw.pdf
              typst query \
                --root ${repoRoot} \
                --field value --one \
                ${repoRoot}/slides.typ '<pdfpc-file>' \
                > slides.pdfpc.json
              python3 ${repoRoot}/tools/inject-notes.py \
                slides-raw.pdf slides.pdfpc.json $out
            '';
        lysark-med-notater =
          pkgs.runCommand "slides-med-notater.pdf"
            {
              nativeBuildInputs = [ (typstWithPkgsFor pkgs) ];
            }
            # Bash
            ''
              typst compile \
                --format pdf \
                --root ${repoRoot} \
                --input notes=true \
                ${repoRoot}/slides.typ \
                $out
            '';
      });

      formatter = eachSystem (
        pkgs:
        (inputs.treefmt-nix.lib.evalModule pkgs {
          projectRootFile = "flake.nix";
          programs.nixfmt.enable = true;
          programs.typstyle.enable = true;
        }).config.build.wrapper
      );
    };
}
