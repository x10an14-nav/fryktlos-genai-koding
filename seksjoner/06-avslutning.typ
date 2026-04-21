#import "common.typ": *

= Avslutning

== Hva GenAI gav meg

#align(horizon)[
  #set text(size: 0.95em)

  #grid(
    columns: (auto, 1fr),
    column-gutter: 1em,
    row-gutter: 0.9em,
    text(weight: "bold", fill: nav-red)[Store refaktoreringer —],
    [`BaseConsumer` → `AdminClient`, streaming pipeline, \
    jemalloc som allocator. Hver enkelt var én kveld med \
    agenten; uten: sannsynligvis ikke påbegynt.],
    text(weight: "bold", fill: nav-red)[Arkeologi i ukjent terreng —],
    [`sigfillset` i 150k linjer `librdkafka`. Admin API i \
    j-santander-forken. glibc-fragmenterings-mekanikken. \
    Veiviser, ikke ekspert — men veiviseren var nok.],
    text(weight: "bold", fill: nav-red)[Rotårsaks-analyse fra data —],
    [93 % av cycle i timestamp-henting. Minne × consumer \
    groups som dominerende allokering. `Offset::End`-sentinel \
    som maskerte reell lag. Hypoteser jeg kunne teste raskt.],
  )

  #v(1em)

  #align(center)[
    #text(size: 1.1em, weight: "bold")[
      Sikringsteknikkene gjorde agenten trygg å bruke. \
      Agenten gjorde arbeidet mulig å fullføre.
    ]
  ]
]

#speaker-note[
  TODO: revider etter formatbeslutning. Payoff-linjen er forsøk på å
  knytte de to trådene sammen (sikringsteknikk → gevinst) før vi går
  inn i "Det vi har vært gjennom". Vurder om den skal flyttes dit
  i stedet.
]

== Det vi har vært gjennom

#align(horizon)[
  #grid(
    columns: (auto, 1fr),
    column-gutter: 1em,
    row-gutter: 0.8em,
    text(weight: "bold", fill: nav-red)[Bolk 1 —],
    [Rust-kompilator + typesystem (sumtyper, exhaustive matching)
    fanger mye av det LLM-en roter med. Tester & logging fanger resten.],
    text(weight: "bold", fill: nav-red)[Bolk 2 —],
    [Nix gjør reproducerbart bygg til _default_. `JEMALLOC_OVERRIDE`
    og patched `librdkafka` blir én linje hver.],
    text(weight: "bold", fill: nav-red)[Bolk 3 —],
    [Med feedback loops som holder, tør man å forke 14 år gammel
    C-kode — og revertere når det ikke virker.],
  )

  #v(1.5em)

  #align(center)[
    #text(size: 1.3em, weight: "bold", fill: nav-red)[
      Fryktløshet er en effekt av verktøykjeden.
    ]

    #v(0.5em)

    #text(size: 0.95em)[
      GenAI blir ikke tryggere av seg selv med det første —
      det blir tryggere når noe fanger feilene den gjør.
    ]
  ]
]

== Takk

#align(center + horizon)[
  #text(size: 2.5em, weight: "bold", fill: nav-red)[Takk!]

  #v(1em)

  Christian Chavez — NAV IT / nais

  #v(0.5em)

  Slides + notater: #link("https://" + repo-url)[#underline(repo-url)]

  #v(0.8em)

  Case study: \
  #gh("nais/klag-exporter", path: "tree/deploy_our_own_helmchart", label: raw("nais/klag-exporter @ deploy_our_own_helmchart"))

  #v(1.5em)

  #text(size: 1.1em)[Spørsmål?]
]




