#import "common.typ": *

= Kompilatoren som trygger

== Første refaktor-bølge

#badge("🧹")

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
      - Approach lånt fra #gh("seglo/kafka-lag-exporter", code: true)
      - Admin API manglet i `librdkafka`
        - Forket fra #gh("fede1024/rust-rdkafka", code: true)
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
  Før noe GenAI fikk lov til å gjøre noe stort, brukte jeg en
  kveld på å få koden til å tilfredsstille clippy med pedantic,
  nursery og unwrap_used. Sitatet "lar meg bli kjent med koden"
  er direkte fra commit-meldingen — før GenAI fikk gjøre noe.
  Det høres trivielt ut, men to ting:
  (a) det lar meg bli kjent med koden, (b) det etablerer et sterkt
  utgangspunkt — når kompilatoren og linters er fornøyd, blir
  hver senere endring tydeligere. AI-en kan ikke gjemme slurv i
  støy.

  Så kom første store grep: per-gruppe BaseConsumer var den
  dominerende minne-kilden. Jeg visste fra `seglo/kafka-lag-exporter`
  (Scala, arkivert) at det fantes en bedre approach via Admin API.
  Problemet: den rdkafka-forken alle brukte hadde ikke Admin API.
  En fork av rdkafka hadde bindings-ene — fra j-santander, en
  annen NAV-er. Jeg rebased den på master og tok den i bruk.
  Resultat: 220 linjer unsafe FFI borte, null unsafe blocks igjen
  i vår kode.

  Tør tørre å forkaste avhengigheter — ellers sitter du fast.
]

== Etter denne: fortsatt 943 MiB per pod

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
  Admin API-grepet fjernet den dominerende minne-kilden — men på
  vår største Kafka-klynge (nav-dev-kafka, ~1 400 topics,
  ~4 600 topic-ACL-er) klatret pod-en fortsatt over 900 MiB og
  fortsatte å vokse. Ikke "O(concurrent_groups × 25 MB)" lenger,
  men fortsatt noe som vokste med volumet.

  Her begynner timingen å bli interessant: det er lørdag kveld,
  19. februar, rundt 21:30. Jeg har Claude ved siden av meg og
  en file-watcher i en terminal som re-kompilerer og kjører tester
  hver gang jeg lagrer. Jeg har allerede brukt dagen på Admin
  API-refaktoren. Neste skritt trenger et nytt grep.
]

== Dagen det snudde

#badge("👁", "🔍")

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
  Grafen viser 24 timer fra klag-exporter på nav-dev-kafka. Tidlig
  på døgnet: eskalering, eskalering, eskalering — hver pod vokser
  til ~32 GiB før den dør og restartes. Rundt 22:00 (merk: y-aksen
  her er relativ, x-aksen er 24t) kommer deploy-en av d99f656.
  Hakkete konvergens gjennom natten, så flater ut på rundt 500–900 MiB.

  Hva skjedde i d99f656? Tre ting samtidig, alle foreslått av LLM-en
  og verifisert av kompilatoren + tester:

  (1) Streaming pipeline: hver cycle hadde tidligere materialisert
      ALLE gruppe-data i minnet før noe ble prosessert. Nå: per-gruppe
      pipeline, maks N in-flight.

  (2) `describe_consumer_groups` chunked (default 500) — brokeren
      ble DDOS-et av ett enkelt RPC med 10k+ gruppe-ID-er.

  (3) Målrettet watermark-henting: før hentet vi watermarks for hver
      partition som eksisterte i clusteret (100k+). Nå bare for
      partisjoner vi faktisk overvåker.

  Prompt-teknikk: kompilatoren + testene i file-watch-terminalen var
  agentens feedback loop. Jeg la opp reglene før vi begynte: agenten
  får ikke committe, får ikke kjøre git, må stoppe og vente på meg
  før neste steg. Jeg leste hvert forslag. `git add -p` på alt.
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
  Timen etter d99f656. Hver røde stiplede linje er en ny deploy —
  altså en ny hypotese test-run. Orange pod lever 5 minutter, vokser
  til 160 %, dør. Grønn kommer opp, klatrer jevnt. Blå overtar,
  klatrer kontinuerlig med støy. Så yellow tar over og viser helt
  annet mønster: rask sprett til ~140 %, plateau i 8 minutter, ett
  steg opp, plateau igjen.

  Poenget: prosessering må rekke ferdig innenfor 20–30 sekunder per
  cycle (neste vindu). Ikke bare minne — CPU-spikes viser hvor nær
  kanten vi var. Fire deploys på under en time for å lande det.

  Prompt-teknikk: flotte kompilator-feilmeldinger. Rust forteller
  deg _eksakt_ hva som er galt, hvor, og ofte hvordan du fikser det.
  Når AI foreslår en endring som bryter typene, ser jeg det i loopen
  før jeg i det hele tatt trenger å lese forslaget nøye. Det er
  billig iterasjon — og det skalerer langt forbi det Python eller
  TypeScript ville gitt meg med samme tempo.

  Foreshadowing: dette bilde viser _memory + CPU_ — begge i prosent
  av requested. Minne var den store gevinsten. CPU-spikes er neste
  bolk's problem.
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
    [*panic + stacktrace* i test-loop],
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
  Tre etterslep-commits, tre forskjellige fangstmekanismer:

  (1) Double-free: AI foreslo en endring i rust-rdkafka-forken vår
      som frigjorde det samme C-objektet to ganger. Rust-kompilatoren
      aksepterte koden fordi alt var pakket inn i `unsafe extern "C"` —
      ingenting å verifisere eierskap på. Det som fanget det var
      en segfault i test-loopen. Læringspunkt: når du krysser FFI-grensen,
      mister du kompilatorens garantier.

  (2) Silent data loss: en dag senere oppdager jeg at
      `kafka_consumergroup_group_lag` viser 0 trass i reell lag.
      Grunnen: `Offset::from_raw(-1)` produserer `Offset::End`,
      ikke `Offset::Offset(-1)`. Match-en var syntaktisk perfekt,
      og kompilatoren hadde null å klage på. Det som fanget det var
      logging på ekte cluster. Feedback loop ≠ kun kompilator.

      Nyanse for de teknisk interesserte: Rust arver sumtyper og
      exhaustive pattern matching fra Hindley-Milner-familien
      (OCaml, Haskell). En full `match` ville tvunget håndtering
      av `Offset::End`-varianten — men `if let` opt-er eksplisitt
      ut av exhaustivity. Garantien fantes; konstruksjonen omgikk
      den. Typesystemet beskytter mer enn bare minne.

  (3) Neg cache + cross-group dedup: logger viste at 93 % av cycle
      gikk til timestamp-henting. 255 fetches, 82 unike. AI foreslo
      to cache-lag; kompilatoren og testene godkjente, produksjonsdata
      bekreftet. Dette er normalfallet der hele verktøykjeden
      jobber sammen.

  Overgangen til bolk 2: kompilatorens grenser er der Rust møter
  `librdkafka`. Neste bolk går dypere inn i FFI-kanten.
]

== Agent sikringsteknikker

#teknikk-tabell(introdusert: ("🧹", "👁", "🔍", "🚨"))

== Detektivrydderen

#align(horizon)[
  #set text(size: 0.95em)

  #grid(
    columns: (auto, 1fr),
    column-gutter: 1em,
    row-gutter: 0.9em,
    text(weight: "bold", fill: nav-red)[Stor refaktor —],
    [Per-gruppe `BaseConsumer` → delt `AdminClient`. \
    220 linjer `unsafe` FFI borte på én kveld. \
    Streaming pipeline vs batch jobbing \ → per-gruppe, maks N in-flight.],
    text(weight: "bold", fill: nav-red)[Agent implementerte cache —],
    [Logger viste `stream_metrics_ms` = 93 % av tidsforbruket. \
    Cross-group dedup + negativ cache foreslått av agenten.],
    text(weight: "bold", fill: nav-red)[Sentinel-jakt —],
    [Metrikken viste 0 trass i reell lag. \
    Agenten sporet opp "off by 1" feil i `librdkafka`-forken.],
  )

  #v(1em)

  #align(center)[
    #text(size: 1.05em, style: "italic")[
      Arbeidet hadde blitt gjort uansett — men ikke på én helg.
    ]
  ]
]

#speaker-note[
  TODO: stram innhold etter formatbeslutning. Tre kategori-eksempler
  her er direkte fra klag-commits.txt; kan trimmes til to hvis det
  blir for tett. "Arbeidet hadde vært gjort uansett — men ikke på én
  helg" er utkast til payoff-linje — bytt ut hvis bedre formulering
  finnes.
]
