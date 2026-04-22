#import "common.typ": *

= Avslutning

== Hva GenAI gav meg

#sticker("1f4aa", anchor: top + right, dx: -1em, dy: 0.8em, angle: 14deg, size: 3em)
#sticker("1f916", anchor: bottom + left, dx: 1em, dy: -1em, angle: -12deg, size: 2.4em)

#align(horizon)[
  #set text(size: 0.95em)

  #grid(
    columns: (auto, 1fr),
    column-gutter: 1em,
    row-gutter: 0.9em,
    text(weight: "bold", fill: nav-red)[Store refaktoreringer —],
    [`BaseConsumer` → `AdminClient`, streaming pipeline, \
    `jemalloc` som allocator. _Uten_ agenten: sannsynligvis *ikke* påbegynt.],
    text(weight: "bold", fill: nav-red)[Arkeologi i ukjent terreng —],
    [`sigfillset()` *innimellom* 150k linjer `librdkafka`.
    *Utvikle* Admin API i `j-santander`-forken. *Forstå* `glibc`-fragmenterings-mekanikken. \
    _Veiviser, ikke ekspert_ — men det *holdt*.],
    text(weight: "bold", fill: nav-red)[Rotårsaks-analyse fra data —],
    [*93%* av tidsbruk i timestamp-henting. Minne × consumer \
    groups som dominerende allokering. `Offset::End`-sentinel \
    som maskerte reell lag. Hypoteser jeg kunne utforske raskt.],
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
  *[\~55s → 24:00]*

  - Tre kategorier: store refaktoreringer, arkeologi i ukjent terreng, rotårsak fra data

  - Payoff: sikringsteknikk gjorde agent trygg, agent gjorde arbeidet mulig
]

== Det vi har vært gjennom

#sticker("1f44d", anchor: top + right, dx: -1em, dy: 0.8em, angle: 12deg, size: 2.8em)
#sticker("1f4dd", anchor: bottom + left, dx: 1em, dy: -4.5em, angle: -10deg, size: 2.4em)

#align(horizon)[
  #grid(
    columns: (auto, 1fr),
    column-gutter: 1em,
    row-gutter: 0.8em,
    text(weight: "bold", fill: nav-red)[Bolk 1 —],
    [Rusts kompilator + typesystem *fanger* mye av det LLM-en roter med. Tester & logging fanger resten.],
    text(weight: "bold", fill: nav-red)[Bolk 2 —],
    [Nix gjør reproduserbart bygg til *default*. `JEMALLOC_OVERRIDE` og patched `rust-rdkafka` blir én linje hver.],
    text(weight: "bold", fill: nav-red)[Bolk 3 —],
    [Med feedback loops som holder, *tør* man å gå inn i _14 år gammel C-kode_ — og *revertere* når det ikke virker.],
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

#speaker-note[
  *[\~30s → 24:30]*

  - 30 sek. Stikkord, ikke detaljer.

  - Payoff-linjen: pust før/etter.
]

== Takk

#sticker("1f389", anchor: top + left, dx: 0.8em, dy: 0.8em, angle: -18deg, size: 3.6em)
#sticker("1f389", anchor: top + right, dx: -1em, dy: 0.8em, angle: 18deg, size: 3.6em)
#sticker("1f44f", anchor: bottom + left, dx: 1em, dy: -1em, angle: -10deg, size: 2.8em)
#sticker("1f44f", anchor: bottom + right, dx: -1em, dy: -1em, angle: 10deg, size: 2.8em)

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




