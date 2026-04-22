#import "common.typ": *

= FFI i fremmed land? Nix!

// Tittel: ordspill — "Nix" som både tysk "ingenting" (på norsk:
// "slapp av, det er pytt-småtteri") og som verktøy-navnet. Sier
// implisitt: "FFI-trøbbel? Nix-verktøykjeden løser det."

== Fra Rust ned i C

#sticker("1f47b", anchor: top + right, dx: -1em, dy: 0.6em, angle: 14deg, size: 3em)
#sticker("1f480", anchor: bottom + right, dx: -1.2em, dy: -1em, angle: -10deg, size: 2.6em)

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
  *[\~65s → 16:05]*

  - Crash på librdkafkas interne broker-tråder

  - `sigfillset()` maskerer alle signaler, umulig å fange fra handler

  - Setter opp neste slide
]

== JEMALLOC_OVERRIDE — én linje Nix

#sticker("1fae1", anchor: top + right, dx: -1em, dy: 0.8em, angle: 10deg, size: 2.8em)
#sticker("1f60e", anchor: bottom + left, dx: 1em, dy: -1em, angle: -12deg, size: 2.6em)

- Minnet fragmenterte -> måtte bytte minneallokeringsverktøy.
- Rust-økosystemets vanlige vei bygget ikke for oss.

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
  *[\~60s → 17:05]*

  - glibc malloc fragmenterte på per-cycle (ca 15 000 MetricPoint allokert og droppet)

  - tikv-jemalloc-sys bundler 5.3.0, feiler å bygge med GCC 15 (`strerror_r`)

  - Nix: pek på pkgs.jemalloc, reproduserbart, uten fork
]

== Jeg turte å prøve

#badge("🔒")
#sticker("1f9d9", anchor: top + left, dx: 0.8em, dy: 0.8em, angle: -14deg, size: 3em)

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

  #text(size: 1.4em, weight: "bold", fill: nav-red)[\~2 timer]

  #v(0.5em)

  #text(size: 0.9em)[
    "The signals are blocked in the C-level `librdkafka` library,
    rev #gh("confluentinc/librdkafka", path: "issues/4571", label: raw("confluentinc/librdkafka#4571"))"
  ]

  #v(0.5em)

  Reproduserbart bygg + git = _turte å prøve_, _turte å revertere_.
]

#speaker-note[
  *[\~60s → 18:05]*

  - 2t: install → revert SIGSEGV-handler

  - Nix + git = billig å prøve, billig å trekke tilbake

  - librdkafka\#4571: kjent dødfødt, ikke visst da
]


== Agent sikringsteknikker

#teknikk-tabell()

#speaker-note[
  *[\~20s → 18:25]*

  - 🔒 ny: reproduserbart bygg → trygg revert

  - Framhev kun det nye
]

== Fryktløs patching

#sticker("1f4aa", anchor: bottom + right, dx: -1.5em, dy: -1.5em, angle: 12deg, size: 3em)
#sticker("1f9ea", anchor: bottom + left, dx: 1em, dy: -1em, angle: -10deg, size: 2.4em)

#align(horizon)[
  #set text(size: 0.95em)

  #grid(
    columns: (auto, 1fr),
    column-gutter: 1em,
    row-gutter: 0.9em,
    text(weight: "bold", fill: nav-red)[Minnefragmentering —],
    [AI (1) forklarte situasjonen basert på bibliotekets kildekode, (2) foreslo ny minnehåndtering (`jemalloc`)
    som stabiliserte (3) minneforbruket og frigjøring av minne.],
    text(weight: "bold", fill: nav-red)[Nix-overstyring —],
    [GCC bug i bundled `jemalloc` configure script.
    Agenten fant 1x linjes fiks vha. Nix.],
    text(weight: "bold", fill: nav-red)[Fryktløs utforskning —],
    [
      Kræsj uten fornuftig feilkode/feilmelding.
      SIGSEGV-handler med `libc::backtrace` (1) ble installert, deretter (2) fjernet \~2t senere, når (3) det viste seg at `librdkafka` blokkerer signaler via `sigfillset()`.
      Agenten (4) fant allerede eksisterende #gh("confluentinc/librdkafka", path: "issues/4571", label: [issue \#4571]).
    ],
  )

  #v(1em)

  #align(center)[
    #text(size: 1.05em, style: "italic")[
      Uten Nix + git: ville aldri turt å prøve.
    ]
  ]
]

#speaker-note[
  *[\~60s → 19:25]*

  - Tre kategorier bolk 2: minnefragmentering (jemalloc), Nix-overstyring (GCC bug), fryktløs utforskning (SIGSEGV-revert, librdkafka\#4571)
]
