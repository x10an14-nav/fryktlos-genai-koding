#import "common.typ": *

= FFI i fremmed land? Nix!

// Tittel: ordspill — "Nix" som både tysk "ingenting" (på norsk:
// "slapp av, det er pytt-småtteri") og som verktøy-navnet. Sier
// implisitt: "FFI-trøbbel? Nix-verktøykjeden løser det."

== Fra Rust ned i C

*Tre problemer Rust ikke kunne fange*

- `librdkafka` double-free ved shutdown
- Blocking FFI kvelte tokio — readiness-probe feilet
- SIGSEGV fra describe-call på 13 400+ consumer groups

#v(0.6em)

#align(center)[
  #text(fill: nav-red, weight: "bold")[
    Crashen skjer på C-bibliotekets egne tråder — usynlig for Rust.
  ]
]

#speaker-note[
  Detaljer (muntlig): crashen skjer på `librdkafka` sine *interne
  broker-tråder*. Disse maskerer alle signaler via `sigfillset` →
  umulig å fange fra en signal handler. Dette blir poenget på neste
  slide.
]

== JEMALLOC_OVERRIDE — én linje Nix

- Minnet fragmenterte. Måtte bytte allocator.
- Rust-økosystemets vanlige vei bygget ikke hos oss.

#v(0.8em)

#align(center)[
  ```
  JEMALLOC_OVERRIDE = "${pkgs.jemalloc}/lib/libjemalloc.a";
  ```
]

#v(0.6em)

#align(center)[
  #text(fill: nav-red, weight: "bold")[
    Samme hack i en vanlig Dockerfile = kaos.
  ]
]

#speaker-note[
  Detaljer (muntlig): `glibc malloc` fragmenterte stygt på
  per-cycle-mønsteret (~15 000 `MetricPoint` allokert + droppet).
  `tikv-jemalloc-sys` bundler jemalloc 5.3.0, som feiler å bygge med
  GCC 15 (`cannot determine return type of strerror_r`). Nix lot oss
  peke på systemets `pkgs.jemalloc` i stedet — reproduserbart, uten
  fork.
]

== Jeg turte å prøve

#badge("🔒")

#align(horizon)[
  #grid(
    columns: (1fr, auto, 1fr),
    column-gutter: 1em,
    align: (right + horizon, center + horizon, left + horizon),
    [
      *12:59* \
      _install SIGSEGV handler_
    ],
    text(size: 2em, fill: nav-red)[→],
    [
      *14:49* \
      _Revert "install SIGSEGV handler"_
    ],
  )

  #v(1em)

  #text(size: 1.4em, weight: "bold", fill: nav-red)[1 time 50 minutter]

  #v(0.5em)

  #text(size: 0.9em)[
    "The signals are blocked in the C-level `librdkafka` library,
    rev #gh("confluentinc/librdkafka", path: "issues/4571", label: raw("confluentinc/librdkafka#4571"))"
  ]

  #v(0.5em)

  Reproducerbart bygg + git = _turte å prøve_, _turte å revertere_.
]


== Agent sikringsteknikker

#teknikk-tabell()

== Fryktløs patching

#align(horizon)[
  #set text(size: 0.95em)

  #grid(
    columns: (auto, 1fr),
    column-gutter: 1em,
    row-gutter: 0.9em,
    text(weight: "bold", fill: nav-red)[Minnefragmentering —],
    [Agenten forklarte situasjonen basert på bibliotek kildekode, foreslo ny minnehåndtering (`jemalloc`)
    som stabiliserte minneforbruket og fristillelsen.],
    text(weight: "bold", fill: nav-red)[Nix-overstyring —],
    [GCC bug i bundled `jemalloc` configure script.
    Agenten fant én linjes fiks vha. Nix.],
    text(weight: "bold", fill: nav-red)[Fryktløs utforskning —],
    [Programmet kræsjet uten fornuftig feilkode/feilmelding.
    SIGSEGV-handler med `libc::backtrace` ble installert, deretter fjernet \
    \~2t senere, når det viste seg at `librdkafka` blokkerer \
    signaler via `sigfillset`. Agenten fant allerede eksisterende
    #gh("confluentinc/librdkafka", path: "issues/4571", label: [issue \#4571]).],
  )

  #v(1em)

  #align(center)[
    #text(size: 1.05em, style: "italic")[
      Uten Nix + git: ville aldri turt å prøve.
    ]
  ]
]

#speaker-note[
  TODO: revider etter formatbeslutning. Tredje kategorien (revert-drevet)
  overlapper med "Jeg turte å prøve" tidligere i bolken — vurder om det
  skal kuttes eller omformuleres for å unngå gjentagelse. Payoff-linjen
  er utkast.
]
