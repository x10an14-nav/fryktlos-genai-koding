// Delte imports og definisjoner for alle seksjon-filer.
// Importeres via `#import "common.typ": *` øverst i hver seksjon.
// Dette gir tilgang til touying-makroer (`speaker-note`, `components`,
// `utils`) samt vår egen palett.

#import "@preview/touying:0.5.3": *
#import themes.stargazer: *

#let nav-red = rgb("#C30000")
#let repo-url = "github.com/x10an14/fryktlos-genai-koding"

// Hjelper for GitHub-repo-lenker i slide-innhold. Bevarer arvet
// tekstfarge (via eksplisitt `text(fill: ...)` rundt `it` — temaets
// `show link` setter ellers fill: primary og ville overstyrt grå/
// NAV-rødt kontekst). Bruk:
//   #gh("seglo/kafka-lag-exporter")          → lenke med repo-sti
//   #gh("seglo/kafka-lag-exporter", code: true) → samme med monospace
//   #gh("confluentinc/librdkafka", path: "issues/4571", label: [...]) → egendefinert etikett + sti
#let gh(repo, path: none, label: none, code: false) = context {
  let url = "https://github.com/" + repo + if path != none { "/" + path } else { "" }
  let shown = if label != none {
    label
  } else if code {
    raw(repo)
  } else {
    repo
  }
  let fill = text.fill
  link(url, text(fill: fill, underline(shown)))
}

// Emoji-badge plassert vertikalt midsentrert på høyre kant av sliden.
// Brukes som visuelt refreng for prompt-teknikker. Se NOTES.md
// §"Kurert teknikk-liste" for mapping mellom emoji og teknikk.
// Bruk:
//   #badge(🧹)           → én emoji
//   #badge(👁, 🔍)        → vertikal stack
#let badge(..emojis) = place(
  right + bottom,
  dx: 0.4em,
  dy: -0.5em,
  stack(
    dir: ltr,
    spacing: 0.5em,
    ..emojis.pos().map(e => text(size: 24pt, e)),
  ),
)

// Felles definisjon av teknikker (emoji, navn, forklaring). Brukes
// av #teknikk-tabell. Rekkefølge = visuell rekkefølge i tabellen.
#let teknikker = (
  ("🧹", [Rydd opp først],       [clippy pedantic før AI slapp til]),
  ("🔒", [Begrenset handlingsrom], [agenten får ikke committe, venter på klarsignal]),
  ("👁", [Fil-watch],             [kontinuerlig kompilering + tester i egen terminal]),
  ("🔍", raw("git add -p"),       [manuelt syn på hver hunk før staging]),
  ("🚨", [Anti-juks-sjekk],       [agenten skal ikke fjerne tester for å få bygg grønt]),
)

// Teknikk-tabell i format A. `introdusert` er en array av emoji-
// strenger som skal vises med full farge; resten vises grått som
// "hint om at det er mer som kommer". `introdusert: none` = alle.
// `tittel` er valgfri overskrift over tabellen.
#let teknikk-tabell(introdusert: none, tittel: none) = {
  let kjent(emoji) = introdusert == none or introdusert.contains(emoji)
  let grå = rgb("#bfbfbf")

  if tittel != none {
    align(center, text(size: 1.3em, weight: "bold")[#tittel])
    v(0.8em)
  }

  let celler = teknikker.map(t => {
    let emoji = t.at(0)
    let navn = t.at(1)
    let desc = t.at(2)
    let vis = kjent(emoji)
    let f = if vis { black } else { grå }
    (
      text(size: 1.8em, fill: f, emoji),
      text(size: 1em, fill: f, weight: "bold", if vis { navn } else [···]),
      text(size: 0.9em, fill: f, if vis { desc } else [···]),
    )
  }).flatten()

  align(horizon, grid(
    columns: (auto, auto, auto),
    column-gutter: 1.2em,
    row-gutter: 0.7em,
    align: (center + horizon, left + horizon, left + horizon),
    ..celler,
  ))
}
