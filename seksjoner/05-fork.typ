#import "common.typ": *

= Forke 14 år gammelt C-bibliotek? Pft, barnemat!

// Tittel: ironisk overkonfidens — retorisk grep der bolken viser
// at det faktisk BLE nesten-enkelt, fordi verktøykjeden bar meg.

== Hva jeg gikk inn i

#align(horizon)[
  *#gh("confluentinc/librdkafka", code: true)* — ~150 000 linjer C/C++, 251 C-filer, 14 år gammelt

  - 572 åpne issues, 258 åpne PRs
  - 15 bundlede tredjeparts-avhengigheter
  - Manuell memory management, ingen borrow checker, segfaults overalt

  #v(0.5em)

  For en gjengs utvikler: *skremmende territorium*.
]

== Feb 23–25: én uke FFI-helvete

#badge("🔒", "👁")

#set text(size: 0.9em)

#table(
  columns: (auto, 1fr),
  stroke: 0.5pt + gray,
  inset: 0.6em,
  align: (left, left),
  table.header([*Dato*], [*Hva*]),
  [23. feb 14:32], [Fix `librdkafka` double-free ved shutdown],
  [23. feb 15:08], [`jemalloc` + pool metadata-refresh: -1],
  [24. feb 10:52], [`block_in_place` rundt blocking FFI],
  [24. feb 12:59], [Install `SIGSEGV` handler],
  [24. feb 14:49], [Revert — signals blocked i `librdkafka`],
  [24. feb 14:58], [Bound concurrent batches (100, 5-round chunks)],
  [25. feb 10:19], [Reduce timeout-thundering-herd],
)

== Hva dette egentlig betyr

- Jeg *forket* et 14 år gammelt C-bibliotek
  - Jeg *patchet* det
  - Jeg *reverterte* en feil-installert signal handler
  - Jeg *begrenset parallelitet* mot C-laget basert på faktisk SIGSEGV-logging

#v(0.8em)

#align(center)[
  #text(size: 1.4em, weight: "bold", fill: nav-red)[
    Jeg turte dette på grunn av verktøykjeden.
  ]

  #v(0.5em)

  #text(size: 0.9em)[Rust + Nix + tester + CI + git = fryktløshet _per default_.]
]


== Agent sikringsteknikker

#teknikk-tabell()

== Effektiv arkeolog

#align(horizon)[
  #set text(size: 0.95em)

  #grid(
    columns: (auto, 1fr),
    column-gutter: 1em,
    row-gutter: 0.9em,
    text(weight: "bold", fill: nav-red)[Navigering i 150k linjer C —],
    [`sigfillset`-kallet som blokkerer alle signaler på \
    `librdkafkas` broker-tråder. Uten agenten: timer med \
    `grep` og callgraph-tracing. Med: minutter til riktig fil.],
    text(weight: "bold", fill: nav-red)[Oppdagelse av fork —],
    [Admin API manglet i upstream rust-rdkafka. \
    Agenten fant #gh("j-santander/rust-rdkafka", code: true) \
    som hadde bindings-ene — rebased på master i vår fork.],
    text(weight: "bold", fill: nav-red)[Hypoteser som kunne fires raskt —],
    [Concurrency-grense mot C (5 batches × 10 ms pause). \
    Agenten foreslo basert på `librdkafka-internals`-forståelse. \
    Fungerte på første forsøk.],
  )

  #v(1em)

  #align(center)[
    #text(size: 1.05em, style: "italic")[
      14 år gammel C, ingen tidligere erfaring — likevel framover.
    ]
  ]
]

#speaker-note[
  TODO: revider etter formatbeslutning. "Oppdagelse av fork" kan være
  bedre plassert i Bolk 1 siden det var der Admin API faktisk kom i
  bruk — men agenten fant den da, og det er en bolk 3-demonstrasjon
  av arkæologi-egenskapen. Brukerens avgjørelse.
]
