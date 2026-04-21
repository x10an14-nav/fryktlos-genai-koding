#import "common.typ": *

// Backup-slides. Ikke egen ToC-seksjon (tidligere `= Appendix` ga
// en auto-generert ToC-slide etter "Takk!" som virket rar). Disse
// lever nå under Avslutning-seksjonen i headeren, men brukes kun
// som referanse under Q&A eller muntlig digresjon.

== Hvorfor så mange topics?

// Kontekst om NAVs hendelsesdrevne plattform. Flyttet hit fra
// Motivasjon fordi Fred George / R&R / Leesah er kreditt/kontekst
// som brøt dramaturgien mellom klag-exporter-valget og skala-smellen.
// Muntlig digresjon i hovedløpet; sliden ligger her for publikum
// som spør.

#align(center + horizon)[
  #set text(size: 1.1em)
  #align(left)[
    #block(width: 28em)[
      - NAVs plattform er *hendelsesdrevet*
        - #link("https://leesah.io")[#underline[Livet Er En Strøm Av Hendelser]] (Leesah) filosofien
      - Basert på #link("https://www.youtube.com/watch?v=yPf5MfOZPY0")[#underline[Fred George]]s
        #link("https://github.com/navikt/rapids-and-rivers")[#underline["Rapids & Rivers"]] tankegang
        - Se også #link("https://github.com/navikt/leesah-game")[#underline[`navikt/leesah-game`]]
          - hendelsesdrevet applikasjonsutviklingsspill
    ]
  ]

  #v(1em)

  #text(size: 1.0em, style: "italic", fill: nav-red)[
    Konsekvens: *alt* blir Kafka-topics. Mange av dem.
  ]
]
