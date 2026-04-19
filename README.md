# Fryktløs (GenAI) koding

Slides for min talk på [Offentlig Fagdag](https://offentligfagdag.no/program).

## Bygg

```bash
nix build .#lysark    # hermetisk bygg til ./result (symlink til PDF)
nix run .#presenter   # bygg + åpne i pdfpc (presentasjonsmodus)
nix run .#bygg        # live re-kompilering mens du redigerer
nix run .#utkast      # åpne slides.pdf i zathura (auto-reload ved endring)
```

Eller gå inn i devShell manuelt:

```bash
nix develop          # typst, tinymist (LSP), typstyle, pdfpc, okular
typst watch slides.typ
```

Har du [direnv](https://direnv.net/), aktiveres shell-en automatisk:

```bash
direnv allow
```

## Struktur

- `slides.typ` — presentasjonens kildekode (Typst + Touying, stargazer-tema).
- `flake.nix` — Nix-flake med hermetisk bygg via `pkgs.typst.withPackages`.
- `NOTES.md` — arbeidsnotater for innhold og tone.

## Lisens

[Apache License 2.0](./LICENSE) — gjenbruk tillatt, attribution kreves.
Se [NOTICE](./NOTICE) for attribution-tekst.
