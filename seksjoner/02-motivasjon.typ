#import "common.typ": *

= Motivasjon

== Hva er "lag" metrikken?

#align(center + horizon)[
  #text(size: 1.2em)[
    Vi trenger metrikker som informerer hvor langt *etterslep* \
    tjenester som bruker *køer* _henger_.
  ]

  #v(0.4em)

  #text(size: 0.9em, style: "italic")[
    → trenger en pålitelig "lag-exporter"
  ]

  #v(0.6em)

  #image("../assets/kafka-lag.svg", width: 82%)

  #v(0.8em)

  #text(size: 1.1em, weight: "bold")[Hva kan vi bruke lag-metrikker til?]

  #v(0.4em)

  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 1.5em,
    align: (center + horizon, center + horizon, center + horizon),
    [
      #text(weight: "bold", fill: nav-red)[HPA-skalering] \
      #text(size: 0.85em)[automatisk lastskalering]
    ],
    [
      #text(weight: "bold", fill: nav-red)[Feilkøer] \
      #text(size: 0.85em)[avslører meldinger tjenesten feilet på]
    ],
    [
      #text(weight: "bold", fill: nav-red)[Varsling] \
      #text(size: 0.85em)[team kan pinges før SLA brister]
    ],
  )
]

#speaker-note[
  Rammesett kort: dynamisk skalering + varsling forutsetter at vi
  faktisk vet hvor mye etterslep det er på Kafka-topics-ene.
  Tre konkrete bruk: HPA (pod-count som funksjon av lag),
  feilkø-overvåkning (henger meldinger fast?), og varsling til
  team-et før SLA brister. Alt står og faller på en pålitelig
  lag-exporter.
]

== klag-exporter

#align(center + horizon)[
  #grid(
    columns: (1fr, auto, 1fr),
    column-gutter: 1.5em,
    align: (center + horizon, center + horizon, center + horizon),
    [
      #text(size: 1.15em, weight: "bold", fill: gray)[
        #gh("seglo/kafka-lag-exporter")
      ]

      #v(0.3em)

      #set text(size: 0.85em, fill: gray)
      #align(left)[
        #block(width: 17em)[
          - Scala (JVM)
            - arkivert jan. 2024
          - Andre JVM? (#gh("lightbend/kafka-lag-exporter", code: true) — forløperen)
            - like forlatt
          - Go? (#gh("danielqsj/kafka_exporter", code: true), #gh("linkedin/Burrow", code: true))
            - krevde metrikknavn-re-labeling — drop-in var _viktigst_
            - slet med ytelse gitt vårt topic-/CG-volum
        ]
      ]
    ],
    text(size: 2.5em, fill: nav-red, weight: "bold")[→],
    [
      #text(size: 1.25em, weight: "bold", fill: nav-red)[
        #gh("softwaremill/klag-exporter")
      ]

      #v(0.3em)

      #set text(size: 0.85em)
      #align(left)[
        #block(width: 17em)[
          - Rust -> godt skussmål på ytelse, virket lovende
            - mer nylig vedlikeholdt enn mye annet
          - #gh("confluentinc/librdkafka", code: true)
            - vedlikeholdt av Kafka's utviklere
            - lang og lovende fartstid (\~14 år)
            - aktiv utvikling
        ]
      ]
    ],
  )
]

#speaker-note[
  seglo/kafka-lag-exporter var det vi hadde — men den hadde nettopp
  blitt arkivert (jan. 2024), og var knapt vedlikeholdt før det
  heller. Vi så på andre JVM-alternativer først — nærmest instinktivt,
  siden det var der den forrige løsningen lå. De var enten like
  forlatte, eller for nye til at vi turte å satse på dem. Golang hadde noen
  alternativer, men de brukte et Kafka-klient-bibliotek med
  minne/ressurs-ineffektiv consumer-group-håndtering — noe vi
  senere selv skulle merke. softwaremill sin Rust-implementasjon
  bygget på `librdkafka` (C, battletested) og hadde lovende
  ytelsesskussmål. Det var den jeg valgte å adoptere. Derfra
  starter case-studien.
]

== Hvorfor GenAI, da?

#align(center + horizon)[
  #set text(size: 1.2em)

  #align(left)[
    #block(width: 28em)[
      - *klag-exporter*
        - installert/testet på nais med liten kafkaklynge
          - \~5 topics
      - nais har derimot kafkaklynger med *rundt omkring*
        -  1 429 topics
        - benytttet av over 772 apper
          - *klag-exporter* (rust) -> taklet dette dårlig
    ]
  ]

  #v(1.2em)

  #grid(
    columns: (auto, auto, auto),
    column-gutter: 1em,
    row-gutter: 0.4em,
    align: (center + horizon, center + horizon, center + horizon),
    text(size: 1.6em, fill: nav-red, weight: "bold")[32+ GiB],
    text(size: 1.6em, fill: nav-red, weight: "bold")[→],
    text(size: 1.6em, fill: nav-red, weight: "bold")[\<1 GiB],
    text(size: 0.8em, style: "italic")[første forsøk],
    [],
    text(size: 0.8em, style: "italic")[etter (GenAI) refaktorering],
  )
]

#speaker-note[
  Retorisk oppfølging: «Og dette var problematisk fordi…?» La
  tallene henge et øyeblikk. Poenget er ikke at publikum skal
  regne — de skal *føle* gapet mellom dev-miljøet og produksjons-
  skalaen. Det er her "derfor måtte jeg inn i koden" blir
  selvforklarende. Leder rett inn i Bolk 1.
]

