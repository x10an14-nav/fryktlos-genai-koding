#import "common.typ": *

= Kompilatoren som trygger

== Første refaktor-bølge

#badge("🧹")
#sticker("1f4aa", anchor: bottom + left, dx: 1em, dy: -1.2em, angle: -12deg, size: 2.8em)

#align(horizon)[
  #grid(
    columns: (1fr, auto, 1fr),
    column-gutter: 2em,
    align: (left + horizon, center + horizon, left + horizon),
    [
      #text(size: 1.15em, weight: "bold")[1. Rydd opp først]

      #v(0.4em)

      #set text(size: 0.9em)
      - `cargo clippy`
      - "Lar meg bli kjent med koden"
      - Null `unwrap()`s før AI slapp til
    ],
    text(size: 2.5em, fill: nav-red, weight: "bold")[→],
    [
      #text(size: 1.15em, weight: "bold")[2. Første store grep]

      #v(0.4em)

      #set text(size: 0.9em)
      - Fra per-gruppe `BaseConsumer` (~15–30 MB per)
        - til *én* delt `AdminClient`
      - Angrepsvinkel lånt fra
        - #gh("seglo/kafka-lag-exporter", code: true)
      - Admin API manglet i `rust-rdkafka`
        - Forket fra \ #gh("j-santander/rust-rdkafka", code: true)
    ],
  )

  #v(1em)

  #align(center)[
    #text(size: 1.4em, weight: "bold", fill: nav-red)[
      220 linjer `unsafe` FFI fjernet. Null `unsafe` blocks igjen.
    ]

    #v(0.3em)

    #text(size: 0.85em, style: "italic")[O(concurrent_groups × 25 MB) → O(1)]
  ]
]

#speaker-note[
  *[\~75s → 08:15]*

  - Clippy pedantic/nursery/unwrap_used før AI slapp til

  - «Lar meg bli kjent med koden» (fra commit-melding)

  - Admin API manglet i rust-rdkafka — forket fra j-santander (annen NAV-er), rebased master

  - Resultat: 220 linjer unsafe borte, null unsafe igjen

  - Tørr å forkaste avhengigheter
]

== Etter denne: fortsatt 943 MiB per pod

#sticker("1f630", anchor: bottom + left, dx: 2em, dy: -2em, angle: -10deg, size: 2.8em)
#sticker("1f9d0", anchor: bottom + right, dx: -2em, dy: -2em, angle: 12deg, size: 2.6em)

#align(center + horizon)[
  #text(size: 1.1em)[
    Admin API endringen utgjorde *stor* forskjell.
    Vårt største cluster vokste fortsatt forbi *900 MiB* per pod.
  ]

  #v(0.8em)

  #image("../assets/grafana/kubectl-top-postfix-feb19.png", width: 82%)

  #v(0.6em)

  #text(size: 0.9em, style: "italic", fill: nav-red)[
    Så hva nå?
  ]
]

#speaker-note[
  *[\~60s → 09:15]*

  - Admin API fjernet dominerende kilde

  - nav-dev-kafka: ca 1400 topics, ca 4600 ACL-er, pod over 900 MiB og fortsatt voksende

  - Setting: torsdag kveld 19 februar, Claude + file-watcher, dag brukt på Admin API
]

== Dagen det snudde

#badge("👁", "🔍")
#sticker("1f4a1", anchor: top + left, dx: 0.8em, dy: 0.8em, angle: -15deg, size: 3.4em)

#align(center + horizon)[
  #image("../assets/grafana/minnebruk-24t-overgang.png", height: 77%)

  #v(0.5em)

  #grid(
    columns: (auto, auto, auto),
    column-gutter: 1em,
    row-gutter: 0.4em,
    align: (center + horizon, center + horizon, center + horizon),
    text(size: 1.6em, fill: nav-red, weight: "bold")[32+ GiB],
    text(size: 1.6em, fill: nav-red, weight: "bold")[→],
    text(size: 1.6em, fill: nav-red, weight: "bold")[\<1 GiB],
    text(size: 0.75em, style: "italic")[før d99f656],
    [],
    text(size: 0.75em, style: "italic")[etter],
  )
]

#speaker-note[
  *[\~90s → 10:45]*

  - 24t graf. Tidlig: eskalering til ca 32 GiB, OOM, restart

  - d99f656 deploys. Hakket natt, utflating 500–900 MiB

  - d99f656 = 3 ting samtidig:

    - streaming pipeline, maks N in-flight

    - describe_consumer_groups chunked (default 500)

    - målrettet watermark-henting (kun overvåkede partisjoner)

  - Prompt-teknikk: kompilator + tester = agentens feedback loop

  - Regler: ingen commit, ingen git, stopp og vent. `git add -p` på alt.
]

== Tuning-dagen etterpå

#badge("👁")

#align(center + horizon)[
  #image("../assets/grafana/ressursbruk-feb19-stylisert.svg", height: 70%)

  #v(0.3em)

  #text(size: 0.75em, style: "italic")[
    Hver rød linje = ny deploy, ny hypotese.
    Kompilatoren fanger *syntaksen*; Grafana fanger *virkeligheten*.
  ]

  #v(0.2em)

  #text(size: 0.7em, fill: gray)[
    Y-aksen: % av requested ressurs (ikke absolutt verdi).
  ]
]

#speaker-note[
  *[\~75s → 12:00]*

  - Timen etter d99f656. Røde linjer = deploys = hypoteser

  - Mønstre: orange 5 min til 160%, grønn jevnt, blå støy, yellow plateau

  - Må rekke prosessering i 20–30 sek per cycle

  - 4 deploys under en time

  - Prompt-teknikk: Rust-typefeedback raskt, billig iterasjon

  - Foreshadowing: CPU-spikes = neste bolks problem
]

== Etterslep: kompilatoren hjalp, og der den IKKE gjorde det

#badge("🚨")

#align(horizon)[
  #set text(size: 0.95em)

  #table(
    columns: (auto, 1fr, 1fr),
    stroke: 0.5pt + gray,
    inset: 0.7em,
    align: (left + horizon, left + horizon, left + horizon),
    table.header(
      [*Bug*],
      [*Hva kompilatoren sa*],
      [*Hva som fanget det*],
    ),
    [
      *Double-free* \
      #text(size: 0.75em, style: "italic")[`b2477a7` · 17:25]
    ],
    [OK — blindt over FFI-grensen],
    [*panic + stacktrace* i testmiljø],
    [
      *Silent data loss* \
      #text(size: 0.75em, style: "italic")[`4e2d9e3` · neste dag 15:41]
    ],
    [OK — syntaks riktig, semantikk feil],
    [*logging* på ekte cluster],
    [
      *Neg cache + dedup* \
      #text(size: 0.75em, style: "italic")[`5760504` · 17:03]
    ],
    [OK (+ tester OK)],
    [*produksjonsdata* bekreftet],
  )

  #v(1em)

  #align(center)[
    #text(size: 1.1em, weight: "bold")[
      Kompilatoren + typesystemet fanger mye. Feedback loop fanger resten.
    ]
  ]
]

#speaker-note[
  *[\~90s → 13:30]*

  - Double-free: unsafe extern "C", kompilator fanget ikke, segfault i test

    - FFI-grense = mister garantier

  - Silent data loss: `Offset::from_raw(-1)` = `Offset::End`, `if let` opt-et ut av exhaustivity

    - Fanget av prod-logging. Feedback loop ≠ kun kompilator

    - Nyanse: full `match` ville tvunget håndtering

  - Neg cache + dedup: 93% i timestamp, 255 fetches, 82 unike

    - AI foreslo, kompilator/tester/prod bekreftet

  - Overgang bolk 2: kompilatorens grense = FFI-kanten
]

== Agent sikringsteknikker

#teknikk-tabell(introdusert: ("🧹", "👁", "🔍", "🚨"))

#speaker-note[
  *[\~30s → 14:00]*

  - 🧹 opprydding · 👁 overvåk · 🔍 mål · 🚨 alarm

  - Peke tilbake, ikke forklare på nytt
]

== Detektivrydderen

#sticker("1f3c6", anchor: top + right, dx: -1em, dy: 0.8em, angle: 15deg, size: 3.4em)
#sticker("1f9f9", anchor: bottom + left, dx: 0.8em, dy: -1em, angle: -10deg, size: 2.4em)

#align(horizon)[
  #set text(size: 0.95em)

  #grid(
    columns: (auto, 1fr),
    column-gutter: 1em,
    row-gutter: 0.9em,
    text(weight: "bold", fill: nav-red)[Stor refaktor —],
    [Per-gruppe `BaseConsumer` → delt `AdminClient`. \
    220 linjer `unsafe` FFI borte på én kveld. \
    Streaming pipeline vs batch jobbing → per-gruppe, maks N in-flight.],
    text(weight: "bold", fill: nav-red)[Stor optimalisering —],
    [Logger viste `stream_metrics_ms()` = 93 % av tidsforbruket. \
    Cross-group dedup + negativ cache foreslått og implementert av AI.],
    text(weight: "bold", fill: nav-red)[Sentinel-jakt —],
    [Metrikken viste 0 trass i reell lag. \
    Agenten sporet opp sentinel-verdi-tolkning i `rust-rdkafka`-forken.],
  )

  #v(1em)

  #align(center)[
    #text(size: 1.05em, style: "italic")[
      Arbeidet hadde blitt gjort uansett — men ikke på ~helg.
    ]
  ]
]

#speaker-note[
  *[\~60s → 15:00]*

  - Tre kategorier fra klag-commits: stor refaktor, stor optimalisering, sentinel-jakt

  - Payoff: «hadde blitt gjort uansett, men ikke på en helg»
]
