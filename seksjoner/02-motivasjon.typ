#import "common.typ": *

= Motivasjon

== Hva er "lag" metrikken?

#sticker("1f914", anchor: top + right, dx: -1em, dy: 0.8em, angle: 14deg, size: 2.8em)

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
  *[\~80s → 05:05]*

  - HPA, feilkø, varsling

  - Alt står og faller på pålitelig lag-exporter
]

== klag-exporter

#sticker("2620", anchor: top + left, dx: 2em, dy: 2.8em, angle: -18deg, size: 2.4em)
#sticker("1f525", anchor: top + right, dx: -2.2em, dy: 2.5em, angle: 12deg, size: 2.6em)

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
            - siste commit jan. 2023, nå arkivert
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
          - Rust
            - godt skussmål ref ytelse
            - mer nylig vedlikeholdt enn mye annet
            - Bruker #gh("confluentinc/librdkafka", code: true)
              - vedlikeholdt av Kafka's utviklere
              - lang og lovende fartstid (\~14 år)
              - fortsatt under utvikling
        ]
      ]
    ],
  )
]

#speaker-note[
  *[\~60s → 06:05]*

  - seglo: arkivert jan 2024, knapt vedlikeholdt før

  - JVM-alternativer: forlatte eller for nye

  - Go: ineffektiv CG-håndtering

  - softwaremill (Rust + librdkafka): valgt
]

== Hvorfor GenAI, da?

#sticker("1f631", anchor: bottom + left, dx: 13em, dy: -2em, angle: 8deg, size: 2.8em, mirror: true)
#sticker("1f389", anchor: bottom + right, dx: -1.5em, dy: -1em, angle: 18deg, size: 3em)
#sticker("1f4a5", anchor: bottom + left, dx: 1em, dy: -1.2em, angle: -22deg, size: 2.6em)

#align(center + horizon)[
  #set text(size: 1.2em)

  #align(left)[
    #block(width: 28em)[
      - *klag-exporter*
        - installert/testet på nais med liten kafkaklynge
          - \~5 topics
      - nais har derimot kafkaklynger med *rundt omkring*
        -  1 429 topics
        - benyttet av over 772 apper
          - selv *klag-exporter* (rust) -> taklet dette dårlig
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
    text(size: 0.8em, style: "italic")[tidlig forsøk],
    [],
    text(size: 0.8em, style: "italic")[etter (GenAI) refaktorering],
  )
]

#speaker-note[
  *[\~55s → 07:00]*

  - La tallene henge et øyeblikk

  - Publikum skal føle gapet dev vs prod

  - Leder inn i bolk 1
]

