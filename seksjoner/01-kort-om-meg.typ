#import "common.typ": *

= Kort om meg

#align(center + horizon)[
  #text(size: 1.4em, weight: "bold")[Hvem er jeg?]

  #v(1.5em)

  #set text(size: 0.9em)
  #grid(
    columns: (auto, auto),
    column-gutter: 3em,
    align: (left + horizon, center + horizon),
    [
      - GenAI? Februar 2026!
      - Nevroatypisk? Diagnostisert 2024
      - Fingerbetennelse? Siden 2022
      - Startet hos NAV \& nais 2020!
      - Avhengig av (smakfull) glutenfri mat
      - Glad i:
        - Hiking
        - Sci-Fi
        - Engasjert i datakultur
        - Nix
        - Homelabbing
    ],
    box(
      clip: true,
      radius: 50%,
      width: 6cm,
      height: 6cm,
      image("../assets/team/02.jpg", width: 100%, height: 100%, fit: "cover"),
    ),
  )
]

== Teamet

// Avatars er anonymisert: filnavn er sekvensielle numre, ingen
// identifiserende strenger i kildekoden.
#let team-main = (
  ("01", "jpg"),
  ("02", "jpg"),
  ("03", "jpg"),
  ("04", "jpg"),
  ("05", "jpg"),
  ("06", "png"),
  ("07", "jpg"),
  ("08", "png"),
  ("09", "jpg"),
  ("10", "jpg"),
  ("11", "jpg"),
  ("12", "jpg"),
  ("13", "jpg"),
  ("14", "jpg"),
)
#let team-extra = (
  ("15", "png"),
  ("16", "png"),
)

#let avatar(entry) = {
  let (name, ext) = entry
  box(
    clip: true,
    radius: 50%,
    width: 2.0cm,
    height: 2.0cm,
    image("../assets/team/" + name + "." + ext, width: 100%, height: 100%, fit: "cover"),
  )
}

#align(center + horizon)[
  #text(size: 1.3em, weight: "bold")[Nais]

  #v(0.3em)

  #text(size: 0.85em, style: "italic")[
    «En plattform laget av NAV for å gi fart og flyt til utviklerne av det offentlige Norge»
  ]

  #v(1em)

  #stack(
    dir: ttb,
    spacing: 0.6em,
    grid(
      columns: 7,
      column-gutter: 0.6em,
      row-gutter: 0.6em,
      ..team-main.map(avatar)
    ),
    grid(
      columns: 2,
      column-gutter: 0.6em,
      ..team-extra.map(avatar)
    ),
  )
]

#speaker-note[
  Muntlig: «Her er alle vi i nais-teamet. Kanskje dere kjenner
  noen av oss igjen? Vet at enkelte av oss er mer aktive/profilerte
  enn andre!»
]

== Hva _er_ nais?

#align(center + horizon)[
  #text(size: 1.3em, weight: "bold")[Hva _er_ nais?]

  #v(1em)

  #let col-title(body) = text(size: 1.15em)[*#body*]
  #let bt(body) = text(style: "italic", fill: nav-red)[#body]
  #set text(size: 0.75em)
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 0em,
    align: (center + top, center + top),
    align(left)[
      #col-title[Hva tilbyr nais?]
      #set par(leading: 0.8em)
      - #bt[Utrulling] \ kode til prod uten nedetid
      - #bt[Automatisering] \ infra settes opp for deg
      - #bt[Full oversikt] \ hva kjører, hva det koster
      - #bt[Innsikt] \ verktøy for å forstå systemene
      - #bt[Sikkerhet] \ solide defaults ut av boksen
      - #bt[Fellesskap] \ mange bruker, mange bidrar
    ],
    align(left)[
      #col-title[Brukes av]
      #set par(leading: 0.8em)
      - NAV
      - Statistisk sentralbyrå
      - Landbruksdirektoratet
      - Arbeidstilsynet
    ],
  )
]

#place(bottom + right, dx: -9em, dy: -2em, text(size: 1.7em)[
  #link("https://nais.no")[#text(fill: nav-red, underline[https://nais.no])]
])

#speaker-note[
  Poenget her er ikke å lese opp hele lista — vise at nais er en
  reell plattform med bredt nedslagsfelt i offentlig sektor, ikke
  en intern NAV-ting. Sentral setningen fra nais.io: «lett å gjøre
  rett». Brukerlista er verifisert mot nais.io sin Brukere.svelte-
  komponent (Nav, SSB, LDIR=Landbruksdirektoratet, Atil=
  Arbeidstilsynet). Hvis nais.io legger til flere tenanter, kan
  lista utvides.
]
