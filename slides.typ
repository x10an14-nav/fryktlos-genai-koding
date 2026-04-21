// Fryktløs (GenAI) koding — Offentlig Fagdag 2026

#import "@preview/touying:0.5.3": *
#import themes.stargazer: *

#let nav-red = rgb("#C30000")

#let nais-primary = rgb("#ff3377")
#let nais-spectrum = (
  mint: rgb("#6ee5c1"),
  blue: rgb("#5cb2da"),
  purple: rgb("#6200ff"),
  orange: rgb("#ff9100"),
  pink: rgb("#f76891"),
)

#let progress-green = rgb("#4caf50")

#let gradient-progress-bar(height: 3pt) = utils.touying-progress(ratio => {
  grid(
    columns: (ratio * 100%, 1fr),
    rows: height,
    rect(
      width: 100%,
      height: 100%,
      stroke: none,
      fill: gradient.linear(
        (progress-green, 0%),
        (progress-green, 10%),
        (nais-spectrum.mint, 22%),
        (nais-spectrum.blue, 38%),
        (nais-spectrum.purple, 54%),
        (nais-spectrum.orange, 70%),
        (nais-spectrum.pink, 85%),
        (nais-primary, 95%),
        (nais-primary.transparentize(100%), 100%),
      ),
    ),
    none,
  )
})

#let repo-url = "github.com/x10an14/fryktlos-genai-koding"

#let cumulative-section-slide(
  title: utils.i18n-outline-title,
  body,
) = touying-slide-wrapper(self => {
  // Touying 0.5.3 kaller alltid slide-fn med body som positional
  // argument (core.typ:110). Vi aksepterer den og kaster den —
  // body rendres som egne slides via touyings normale flyt.
  let _ = body
  // Hent nåværende level-1 heading fra self.headings (touying
  // tracker headings internt men emitter dem IKKE som placed
  // elementer når new-section-slide-fn er overstyrt → query(heading)
  // på senere sider finner ingenting, og header-et vårt blir tomt.
  // Fiks: emit en skjult heading på seksjons-sliden slik at
  // utils.current-heading(level: 1) kan finne den.
  let section-heading = self.headings.filter(h => h.depth == 1).last()
  self.store.title = section-heading.body
  self = utils.merge-dicts(
    self,
    config-page(fill: self.colors.neutral-lightest),
    // ToC-sliden skal ikke ha header (seksjonsnavn vises stort i
    // outline-et under uansett). Overstyrer header-funksjonen lokalt
    // til noe som ikke emitter elementer.
    config-store(header: self => none),
  )
  let primary = self.colors.primary
  let muted = self.colors.neutral-dark.lighten(50%)
  touying-slide(
    self: self,
    {
      // Skjult heading — tar ingen plass (place+hide), men er
      // "placed" slik at query(heading) finner den.
      place(hide(heading(
        level: 1,
        outlined: false,
        bookmarked: false,
        section-heading.body,
      )))
      align(horizon + left, context {
      let cur = utils.current-heading(level: 1)
      let cur-page = if cur != none { cur.location().page() } else { 0 }
      let nexts = if cur != none {
        query(selector(heading.where(level: 1)).after(inclusive: false, cur.location()))
      } else { () }
      let end-page = if nexts != () { nexts.at(0).location().page() } else { calc.inf }

      show outline.entry: it => {
        let p = it.element.location().page()
        if p >= end-page {
          text(fill: muted, it)
        } else if p >= cur-page {
          text(fill: primary, weight: "bold", it)
        } else {
          text(fill: primary, it)
        }
      }

      components.adaptive-columns(
        outline(title: none, indent: 1em, depth: 1),
      )
    })
    },
  )
})

#show: stargazer-theme.with(
  aspect-ratio: "16-9",
  config-common(
    new-section-slide-fn: cumulative-section-slide,
    // Uten denne blir body (innholdet etter `= Heading`) konsumert
    // av section-slide-fn og rendret på samme side som ToC. Vi vil
    // ha ToC som egen slide og body som egen slide.
    receive-body-for-new-section-slide-fn: false,
  ),
  config-colors(
    primary: nav-red,
    primary-dark: nav-red.darken(25%),
    secondary: nav-red,
    tertiary: nav-red,
  ),
  config-info(
    title: [Fryktløs (GenAI) koding],
    author: [Christian Chavez],
    date: [Offentlig Fagdag — 23. april 2026],
    institution: [NAV IT / nais],
  ),
  config-store(
    navigation: none,
    progress-bar: false,
    header: self => context {
      // Header plassert i høyre hjørne, stablet:
      //   - Øverst: slide-tittel (level-2) via self.store.title
      //     — stargazer rendrer dette normalt, gjenreises fordi vi
      //     overstyrer header-funksjonen.
      //   - Under: seksjons-tittel (level-1) i mindre skrift.
      // `block(width: 100%)` gir place() en bredde-kontekst å
      // plassere mot; uten denne kollapser headeren til smal default
      // og teksten blir skjult eller wrapper vertikalt (se
      // stargazer.typ:440 for referanse-mønster).
      block(width: 100%, height: 2.4em, {
        if self.store.title != none {
          place(
            right + top,
            dx: -0.5em,
            dy: 0.3em,
            text(
              fill: self.colors.primary,
              weight: "bold",
              size: 1.1em,
              utils.call-or-display(self, self.store.title),
            ),
          )
        }
        let cur = utils.current-heading(level: 1)
        if cur != none {
          place(
            right + top,
            dx: -0.5em,
            dy: 1.7em,
            text(
              fill: self.colors.primary,
              weight: "bold",
              size: 0.7em,
              cur.body,
            ),
          )
        }
      })
    },
    footer: self => {
      // Stargazer wrapper setter allerede text-size til 0.5em før vår
      // footer kalles. Bruk absolutt 10pt (≈ halvparten av base 20pt).
      set text(size: 10pt, fill: self.colors.neutral-darkest)
      // Temaets `show link` gjør `set text(fill: primary); it` — en
      // eksplisitt `text(fill: …, …)` inne i link-innholdet vinner over
      // det set-et, så URL-en forblir svart.
      let footer-link = link(
        "https://" + repo-url,
        underline(text(fill: self.colors.neutral-darkest, repo-url)),
      )
      grid(
        rows: (auto, auto),
        row-gutter: 0.4em,
        pad(
          x: 2.5em,
          grid(
            columns: (1fr, auto, 1fr),
            align: (left + horizon, center + horizon, right + horizon),
            footer-link,
            text(fill: self.colors.neutral-darkest)[NAV IT / nais / Christian C.],
            context utils.slide-counter.display() + " / " + utils.last-slide-number,
          ),
        ),
        gradient-progress-bar(height: 3pt),
      )
    },
  ),
)

#set text(lang: "no")

#let title-slide() = touying-slide-wrapper(self => {
  let info = self.info
  let body = {
    show: align.with(center + horizon)
    text(
      size: 2em,
      fill: self.colors.primary,
      weight: "bold",
      info.title,
    )
    if info.subtitle != none {
      parbreak()
      text(size: 1.4em, fill: self.colors.primary, weight: "bold", info.subtitle)
    }
    v(1em)
    text(fill: self.colors.neutral-darkest, info.author)
    v(0.8em)
    if info.institution != none {
      block(
        fill: self.colors.primary,
        inset: (x: 1.2em, y: 0.8em),
        radius: 0.4em,
        breakable: false,
        image("assets/nav_logo_white_tight.svg", height: 1.8em),
      )
    }
    if info.date != none {
      v(0.8em)
      text(size: 0.9em, utils.display-info-date(self))
    }
  }
  let self = utils.merge-dicts(
    self,
    config-page(fill: self.colors.neutral-lightest),
  )
  touying-slide(self: self, body)
})

#title-slide()

#speaker-note[
  Muntlig åpning før du blar videre til ToC:

  «Noen andre her som synes det virker nytt, spennende, og kanskje
   noe skummelt med GenAI? Sikkerhet? Vedlikeholdbarhet? Eierskap
   til koden? Best practice?»

  Håndsopprekking valgfritt — uansett retorisk effekt. Så:

  «Hva om jeg fortalte dere at på mitt første forsøk fikk jeg til
   å omskrive en evig-varende timet batch-jobb til streaming — og
   dermed kraftig økt ytelse og kraftig senket ressursforbruk?»

  (Detaljer/tall kommer i Motivasjon-bolken; ikke spoil her.)
]

#include "seksjoner/01-kort-om-meg.typ"
#include "seksjoner/02-motivasjon.typ"
#include "seksjoner/03-rust.typ"
#include "seksjoner/04-ffi.typ"
#include "seksjoner/05-fork.typ"
#include "seksjoner/06-avslutning.typ"
#include "seksjoner/99-appendix.typ"
