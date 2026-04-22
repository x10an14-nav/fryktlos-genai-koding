#import "common.typ": *

= Gå inn i 14 år gammelt C-bibliotek? Pft, barnemat!

// Tittel: ironisk overkonfidens — retorisk grep der bolken viser
// at det faktisk BLE nesten-enkelt, fordi verktøykjeden bar meg.

== Hva jeg gikk inn i

#sticker("1f47b", anchor: top + left, dx: 0.8em, dy: 0.8em, angle: -16deg, size: 3em)
#sticker("1f480", anchor: bottom + right, dx: -1em, dy: -1em, angle: 12deg, size: 2.6em)

#align(horizon)[
  *#gh("confluentinc/librdkafka", code: true)* — ~150 000 linjer C/C++, 251 C-filer, 14 år gammelt

  - 10-talls commits bare siste 3 mnd pt. i dag
  - Manuell memory management, ingen borrow checker, segfaults overalt

  #v(0.5em)

  For en gjengs utvikler: *skremmende territorium*.
]

#speaker-note[
  *[\~50s → 20:15]*

  - 150k linjer, 14 år, fortsatt aktivt

  - 10-talls commits siste 3 mnd
]

== Feb 23–25: 72 timer FFI-helvete

#badge("🔒", "👁")
#sticker("2615", anchor: top + left, dx: 11em, dy: 0.1em, angle: -10deg, size: 2.6em)
#sticker("1f525", anchor: bottom + right, dx: -1.2em, dy: -1em, angle: -10deg, size: 2.6em)

#set text(size: 0.9em)

#table(
  columns: (auto, 1fr),
  stroke: 0.5pt + gray,
  inset: 0.6em,
  align: (left, left),
  table.header([*Dato*], [*Hva*]),
  [23. feb 14:32], [Fix double-free trigget av `librdkafka` ved shutdown],
  [23. feb 15:08], [`jemalloc` + pool metadata-refresh: -1],
  [24. feb 10:52], [`block_in_place` rundt blocking FFI],
  [24. feb 12:59], [Install `SIGSEGV` handler],
  [24. feb 14:49], [Revert — signals blocked i `librdkafka`],
  [24. feb 14:58], [Bound concurrent batches (100, 5-round chunks)],
  [25. feb 10:19], [Reduce timeout-thundering-herd],
)

#speaker-note[
  *[\~60s → 21:15]*

  - 7 commits, 3 døgn. Ikke les tabellen

  - Rytme: fix → hypotese → revert → ny hypotese

  - 14:49-reverten = SIGSEGV-handler fra bolk 2
]

== Hva dette egentlig betyr

#sticker("1f3c6", anchor: top + right, dx: -1em, dy: 0.8em, angle: 14deg, size: 3em)
#sticker("1f4aa", anchor: bottom + left, dx: 1em, dy: -1em, angle: -12deg, size: 2.6em)

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

#speaker-note[
  *[\~45s → 22:00]*

  - Saktere. La hvert verb lande.

  - Payoff: tesen. Pust.
]


== Agent sikringsteknikker

#teknikk-tabell()

#speaker-note[
  *[\~20s → 22:20]*

  - Alle symboler nå på plass

  - Hele verktøykassa sammen
]

== Effektiv arkeolog

#sticker("1f4a1", anchor: top + right, dx: -1em, dy: 0.8em, angle: 16deg, size: 3em)
#sticker("1f916", anchor: bottom + left, dx: 1em, dy: -1em, angle: -10deg, size: 2.6em)

#align(horizon)[
  #set text(size: 0.95em)

  #grid(
    columns: (auto, 1fr),
    column-gutter: 1em,
    row-gutter: 0.9em,
    text(weight: "bold", fill: nav-red)[Navigering i 150k linjer C —],
    [`sigfillset()` blokkerer alle signaler på `librdkafkas` broker-tråder. *Uten* agenten: _timer_ med `grep` og callgraph-tracing. \ *Med*: _minutter_ til riktig fil.],
    text(weight: "bold", fill: nav-red)[Oppdagelse av fork —],
    [Admin API manglet i `rust-rdkafka`. Agenten fant #gh("j-santander/rust-rdkafka", code: true) som hadde C-bindings — rebased på master i vår fork.],
    text(weight: "bold", fill: nav-red)[Hypoteser som kunne fires raskt —],
    [
      Concurrency-grense mot C bibliotek: `5`batches × `10`ms pause. 
      Agenten kommer med fiks basert på `librdkafka-internals`-forståelse. 
      Fungerte på _første_ forsøk.
    ],
  )

  #v(1em)

  #align(center)[
    #text(size: 1.05em, style: "italic")[
      14 år gammel C, ingen tidligere erfaring — likevel framover.
    ]
  ]
]

#speaker-note[
  *[\~45s → 23:05]*

  - Tre kategorier bolk 3: navigering (`sigfillset()` i 150k linjer C), fork-funn (j-santander rust-rdkafka Admin API), raske hypoteser (concurrency-grense mot C)

  - Siste: fungerte på første forsøk
]
