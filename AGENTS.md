# AGENTS.md

Regler for agenter (LLM-assistenter, CLI-verktøy, CI-bots) i dette
repoet. Ufravikelige med mindre brukeren eksplisitt sier noe annet i
samtalen.

## Git — de harde reglene

- **ALDRI** modifiser, lag, eller slett commits. Commit-grensen er
  brukerens ansvar (gjelder også `--amend`, `reset`, `rebase`, `merge`,
  `cherry-pick`, `revert`, `stash pop/drop`).
- **ALDRI** flytt på eller modifiser en *dirty* HEAD. Kun reverserbare
  operasjoner (f.eks. `checkout` av en annen branch) er tillatt, og
  *kun* når HEAD er clean.
- **ALDRI** snakk med en remote: ingen `push`, `pull`, `fetch`,
  `clone`, `remote …`.
- **ALDRI** endre `.git/` direkte eller foreslå `git config`-endringer.

## Git — hva som er greit

- Lesende kommandoer: `status`, `diff`, `log`, `show`, `blame`,
  `ls-files`, osv.
- `git add <sti>` for egne endringer — forutsatt at det ikke forkludrer
  noe som allerede er staget eller untracked. Ved tvil: spør.

## Filer med uncommittede endringer

Ikke rediger en fil med endringer git ikke kjenner til (untracked,
unstaged, eller modifisert over siste stage/commit) uten eksplisitt
tillatelse i inneværende samtale. Sjekk `git status` ved tvil.

## Commit-meldinger (kun når brukeren ber om forslag)

Vi bruker [Conventional Commits](https://www.conventionalcommits.org/).
**Forklar *hvorfor*, ikke *hva*** — diff-en viser hva. Vær konsis:
én subject-linje, body kun hvis *hvorfor-et* trenger det. Ikke list
filer, ikke parafraser diffen.

Dårlig: `chore: update LICENSE to Apache 2.0 and add NOTICE file`
Bedre: `chore: switch to OSI-approved license so reuse terms match intent`

## Commit-granularitet

Hver commit skal være **selvstendig og bisectable** — også for
presentasjons-innhold. Sjekkes commiten ut alene, skal repoet være
konsistent (slides bygger, flake evaluerer, innhold refererer ikke til
ting som ikke finnes ennå). Ikke bland urelaterte endringer. Test:
«Hvis `git bisect` lander her, gir denne commiten mening alene?» Nei →
del opp.

## Når agenten er usikker

Spør. Ett spørsmål er billigere enn å rydde opp i en utilsiktet
history-rewrite eller overskrevet lokalt arbeid.

**Verifiser tilstand før påstander.** Ikke stol på egen oppsummering fra
tidligere i samtalen — spesielt ikke for git-tilstand. Kjør `git status`
/ `ls` først, så uttale deg.

## Beslutninger tilhører brukeren — ALLTID

Dette er like ufravikelig som git-reglene:

- **ALDRI** ta designvalg, teknologivalg, navnevalg, farge-/stil-valg,
  API-valg, omfangs-valg, eller andre valg med flere gyldige utfall
  **på brukerens vegne**. Brukeren bestemmer. Agenten utfører.
- **ALDRI** løs tvetydighet ved å «velge det som virker rimelig» og
  gå videre. Tvetydighet = stopp og spør.
- **ALDRI** tolk et delvis svar (f.eks. «X er bra») som godkjenning
  av en hel plan agenten har skissert. Bekreft det som ikke er
  eksplisitt bekreftet.
- **ALDRI** scrolle bufferet videre med nye handlinger før brukeren
  faktisk har sagt seg enig. Et nytt prompt i retur er ikke enighet —
  les det først.

### Når et valg må tas

1. **Undersøk selvstendig først.** Les kodebasen, lese dokumentasjon,
   sjekk eksisterende mønstre. Ikke spør om ting du kan finne ut selv.
2. **Presentér funnene som alternativer**, med tydelige avveininger
   (ikke bare «her er tre forslag» — forklar *hvorfor* hvert alternativ
   kan være riktig eller feil for *denne* situasjonen). **Nummerér
   alltid alternativer** slik at brukeren kan referere med nummer uten
   å kopiere tekst.
3. **Vent på brukerens valg.** Ikke handle på «default-anbefaling»
   med mindre brukeren eksplisitt har sagt «velg for meg» i denne
   samtalen.
4. **Hvis du må handle for å kunne undersøke** (kjøre kommandoer,
   lese filer): gjør kun det som er reversibelt og ikke ødelegger
   arbeid. Selve *beslutningen* venter på brukeren.

### Eksempler på valg som ALLTID krever eksplisitt input

- Navn på attributter, filer, funksjoner, kommandoer.
- Farger, typografi, tema, layout.
- Hvilke verktøy/pakker som skal legges til.
- Omfang: «skal dette også dekke X?» — spør, ikke anta.
- Om flere logiske endringer skal splittes i flere commits.
- Alt der du tenker «bruker mente nok …» — du vet ikke. Spør.

## Tekniske byggelærdommer

Konkrete feller nye agenter har brukt tid på. Ikke regler — bare
tidstyver å hoppe over.

### Touying stargazer-tema (0.5.3)

- Overstyrbart via `config-store` uten fork: `navigation`, `header`,
  `footer`, `progress-bar`.
- **Footer-em-felle:** temaets footer-wrapper setter `text(size: 0.5em)`
  *før* vår footer kalles. Relative størrelser (`em`) blir multiplisert
  ned. Bruk absolutt `pt` for footer-tekst.
- **URL-farge i footer:** temaets `show link: it => { set text(fill: primary); it }`
  slår ytre `set text(fill: ...)`. Løsning: eksplisitt
  `text(fill: ..., ...)` *inne i* `link(...)`-innholdet.

### NAV-logo-assets

- Offisiell kilde: ZIP fra <https://aksel.nav.no/grunnleggende/brand/logo>.
- SVG-ene har viewBox `0 0 841.9 595.3` der wordmarken bare fyller et
  lite midtre område (ca. `x=325-517, y=269-326`). Uten tight viewBox
  blir logoen en prikk midt i mye tomrom.
- `assets/nav_logo_white_tight.svg` har viewBox `320 265 200 66`.

### Farger

- **NAV-rødt:** `#C30000`.
- **Nais-palett** (kilde: `github.com/nais/nais.github.io`): primary
  `#ff3377`; spektrum mint `#6ee5c1` → blå `#5cb2da` → lilla `#6200ff`
  → oransje `#ff9100` → rosa `#f76891`.

### Utkast-loop

- `nix run .#bygg` og `nix run .#utkast` kjøres *parallelt* (to
  terminaler). `bygg` har inotify-watch og re-kompilerer; `utkast`
  er zathura med auto-reload.
- `ctrl+r` i zathura = recolor (dark-mode toggle), **ikke** reload.
  Reload er automatisk.
