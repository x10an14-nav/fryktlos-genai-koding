// Fryktløs (GenAI) koding — Offentlig Fagdag 2026

#import "@preview/touying:0.5.3": *
#import themes.stargazer: *

#let nav-red = rgb("#C30000")

// Nais-paletten (kilde: github.com/nais/nais.github.io). Brukes som en
// diskret nikk til nais i progress-baren; NAV-rødt forblir dominant.
#let nais-primary = rgb("#ff3377")
#let nais-spectrum = (
  mint: rgb("#6ee5c1"),
  blue: rgb("#5cb2da"),
  purple: rgb("#6200ff"),
  orange: rgb("#ff9100"),
  pink: rgb("#f76891"),
)

#let gradient-progress-bar(height: 3pt) = utils.touying-progress(ratio => {
  grid(
    columns: (ratio * 100%, 1fr),
    rows: height,
    rect(
      width: 100%,
      height: 100%,
      stroke: none,
      fill: gradient.linear(
        (nais-spectrum.mint, 0%),
        (nais-spectrum.blue, 20%),
        (nais-spectrum.purple, 40%),
        (nais-spectrum.orange, 60%),
        (nais-spectrum.pink, 80%),
        (nais-primary, 92%),
        (nais-primary.transparentize(100%), 100%),
      ),
    ),
    none,
  )
})

// Repo-URL i footer.
#let repo-url = "github.com/x10an14/fryktlos-genai-koding"

// --- Kumulativ seksjons-slide (R4) --------------------------------
// Viser agenda mellom bolker med kumulativ progresjon:
//   - tidligere bolker:   normal farge
//   - nåværende bolk:     normal farge + bold
//   - kommende bolker:    grået ut
// Hookes inn via `config-common(new-section-slide-fn: ...)` i
// stargazer-theme-kallet under.
#let cumulative-section-slide(
  title: utils.i18n-outline-title,
  body,
) = touying-slide-wrapper(self => {
  self.store.title = title
  self = utils.merge-dicts(
    self,
    config-page(fill: self.colors.neutral-lightest),
  )
  let primary = self.colors.primary
  let muted = self.colors.neutral-dark.lighten(50%)
  touying-slide(
    self: self,
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
          // kommende
          text(fill: muted, it)
        } else if p >= cur-page {
          // nåværende
          text(fill: primary, weight: "bold", it)
        } else {
          // tidligere
          text(fill: primary, it)
        }
      }

      components.adaptive-columns(
        outline(title: none, indent: 1em, depth: 1),
      )
    }) + body,
  )
})

#show: stargazer-theme.with(
  aspect-ratio: "16-9",
  config-common(
    new-section-slide-fn: cumulative-section-slide,
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
    institution: [NAV],
  ),
  config-store(
    navigation: none,
    progress-bar: false,
    header: self => if self.store.title != none {
      place(
        right + top,
        dx: -0.5em,
        dy: 0.3em,
        text(
          fill: self.colors.primary,
          weight: "bold",
          size: 0.7em,
          utils.call-or-display(self, self.store.title),
        ),
      )
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
            text(fill: self.colors.neutral-darkest)[Christian C. / NAV],
            context utils.slide-counter.display() + " / " + utils.last-slide-number,
          ),
        ),
        gradient-progress-bar(height: 3pt),
      )
    },
  ),
)

#set text(lang: "no")

// Egen tittel-slide: tittelen som ren NAV-rød fet tekst (ikke i blokk),
// og institusjon (NAV) i den røde blokken i stedet.
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



== Agenda <touying:hidden>

#components.adaptive-columns(outline(title: none, indent: 1em))

// =============================================================
// SKJELETT — bygges ut gjennom intervju. Stikkord/ordlyder fra
// Christian er bevart ordrett der det er nyttig for senere
// utfylling. `TODO:`-markører flagger ting som må hentes/måles.
//
// GLOBALE REGLER (satt av Christian, gjelder hele talken):
//
//   R1. Hver bolk må ÅPNE med "hvor kom behovet fra?" — altså
//       motivasjonen/problemet — før løsningen vises. Publikum
//       skal være med på *hvorfor* endringen var nødvendig, ikke
//       bare *hva* som ble gjort. Dette gjelder alle tre
//       midtbolkene og eventuelle under-avsnitt.
//
//   R2. Humor hører primært hjemme i presenter notes (pdfpc-
//       notater / #speaker-note), IKKE i slide-TITLER. Titler
//       holdes saklige og rene. Selvironi, vitser, sidebemerkninger
//       leveres muntlig.
//
//       MEN: visuell humor PÅ slidene er tillatt og ønsket —
//       små gifs, tegninger, reaksjonsbilder som understreker
//       følelsen i øyeblikket (overraskelse, glede, frykt, tårer).
//       Dette er bedre enn at publikum skal le av slide-titler.
//       Regel: tittelen er saklig, bildet bærer følelsen.
//       Unntak for humor i tittel kan gjøres sparsomt der ett
//       anker faktisk hjelper retorisk (f.eks. SIGSEGV-handleren
//       som ble reverted) — standarden er fortsatt: saklige
//       titler, visuell/muntlig humor.
//
//       TODO imorra: samle 4-6 kandidat-bilder/gifs (én per
//       følelsesbeat: overraskelse ved payoff, frykt ved FFI-
//       helvete, glede ved grønn CI, tårer ved double-free,
//       osv.). Vurder lisens/attribusjon.
//
//   R3. Læringspunkt/gevinst fremheves UNDERVEIS i hver bolk
//       (ikke som egen oppsummerings-slide etter hver). Se
//       struktur-valg 2+4 lengre ned.
//
//   R4. Progresjons-/seksjons-slider (de mellom bolkene som viser
//       hvor vi er i agendaen) skal vise KUMULATIV progresjon:
//       alle tidligere OG nåværende bolker i normal shading, kun
//       kommende bolker grået ut. Nåværende bolk fet/bold for å
//       skille seg ut.
//
//       IMPLEMENTERT: se `cumulative-section-slide` nedenfor,
//       hooked inn via `config-common(new-section-slide-fn: ...)`.
//       Verifiseres visuelt i morgen ved å åpne slides.pdf og
//       sjekke at seksjons-overgangene ser riktige ut.
// =============================================================

= Kort om meg <touying:skip>

// REKKEFØLGE (Christian, bekreftet): tittel → Kort om meg →
// Oversikt (auto-generert via R4) → Motivasjon (hook + payoff) →
// tre bolker → Avslutning.
//
// `<touying:skip>` på denne headingen SKAL hoppe over den auto-
// genererte section-sliden som ellers ville dukket opp FØR Kort
// om meg. Første oversikts-slide skal dukke opp når `= Motivasjon`
// starter, og viser da Kort om meg som utført.
//
// TODO IMORRA (ÅPENT VALG — må avgjøres):
//   `<touying:skip>` fungerer IKKE som forventet i touying 0.5.3
//   med `receive-body-for-new-section-slide-fn=true` (default).
//   Oversikten dukker fortsatt opp som slide 2 (FØR Kort om meg)
//   selv om kildekoden i touying/src/core.typ linje 79 OG 271
//   eksplisitt sjekker for labelen. Mulig bug eller subtil inter-
//   aksjon jeg ikke har funnet.
//
//   Tre veier å velge mellom:
//     1) Bytte til `<touying:hidden>` — fjerner section-sliden,
//        MEN fjerner også Kort om meg fra oversikten som vises
//        mellom Kort om meg og Motivasjon. (Kort om meg vil ikke
//        være listet i noen oversikt = utført-effekten mistes.)
//     2) Droppe auto-section-slider helt, bruke MANUELL oversikt-
//        slide mellom Kort om meg og Motivasjon, og mellom hver
//        bolk. R4-logikken (kumulativ farging) beholdes i den
//        manuelle sliden. Mer kode, men full kontroll og fungerer
//        garantert.
//     3) Akseptere at oversikt også vises FØR Kort om meg (med
//        Kort om meg bold som nåværende, resten grået ut). Ingen
//        kode-endring. «Her er hva som kommer» FØR man starter.
//
//   Anbefaling fra agent: #2. Men valget er Christians.
//
// Valg: A2 (kort men varmt, ~45 sek).
// Innhold (stikkord, ikke fulltekst):
//   - Christian Chavez, NAV
//   - Første gang på flere år med GenAI aktivt i koding
//   - Fingerbetennelse nevnes i én bisetning (ikke utbrodert) —
//     som forklaring på hvorfor jeg trengte en "akselerator"
// Humor (Nix-selvironi "ja, jeg er blitt sånn én") hører til
// presenter notes (R2), ikke på sliden.
// TODO: velg ÉN vits/bilde som holder hele selvironi-motivet
//   (leveres muntlig), slik at resten av talken ikke trenger å
//   lene på det igjen.

Placeholder — kort "om meg" her.

= Motivasjon

// Motivasjon = anekdote-hooken før vi dykker ned i de tre bolkene.
// Når denne seksjonen starter, fires R4-auto-section-slide som
// fungerer som OVERSIKTEN: Kort om meg vises som utført, Motivasjon
// som nåværende, bolkene og Avslutning grået ut.

== Kjenner du deg igjen? <touying:hidden>

// Ledende spørsmål til salen (håndsopprekking valgfritt, men
// retorisk effekt uansett). Ordlyd fra Christian:
//
//   "Noen andre her som synes det virker nytt, spennende, og
//    kanskje noe skummelt med GenAI? Kanskje pga.
//    sikkerhetsproblemer? Kode som blir mindre vedlikeholdsbar
//    eller mister kvalitet? Mye ukjent rundt beste praksis for
//    å utvikle med GenAI og fortsatt beholde eierskap til
//    koden?"
//
// Slide-innhold: 3-4 stikkord store på skjerm (ikke full tekst).
// Forslag: "Sikkerhet?" / "Vedlikeholdbarhet?" / "Eierskap til
// koden?" / "Best practice?"

Placeholder — stikkord her.

== Hva om jeg fortalte dere ... <touying:hidden>

// Surprise-payoff. Ordlyd fra Christian:
//
//   "Hva om jeg fortalte dere at på mitt første forsøk fikk
//    jeg til å helt omskrive en evig-varende timet batch-jobb
//    til å utføre jobben streaming, og dermed øke ytelse Y,
//    senke ressursforbruk X, osv."
//
// Tall fra hukommelsen (Christian, bør verifiseres mot Grafana/Loki
// imorra — har opptil 90 dagers Loki-retention, kan gi bilder/grafer):
//   - minnebruk:    32+ GiB   →   50-200 MiB
//   - prosessering: minutter  →   ~20 sekunder
// TODO imorra:
//   - verifiser tallene ovenfor mot faktiske målinger
//   - hent skjermbilder av Grafana-dashboards (før/etter)
//   - evt. throughput (meldinger/s), pod-restarts, OOM-kills
//   - PR/commit-SHA for batch→streaming-endringen
//     (nais/klag-exporter, branch: deploy_our_own_helmchart)
//
// FUNNET: d99f656 (2026-02-19)
//   "refactor: streaming pipeline to eliminate memory exhaustion
//    on large clusters"
//   https://github.com/nais/klag-exporter/commit/d99f656
//
// Andre gullkorn fra samme branch (reserve for case-study-seksjon):
//   - d68bb0c  fix: avoid librdkafka double-free upon shutdown
//   - 85df581  feat: install SIGSEGV signal handler for backtraces
//   - af00152  Revert "feat: install SIGSEGV ..." (selv-ironi!)
//   - 5d3c0ed  test: replace several tests w/property-based tests
//   - a30f0d9  fix: bound concurrent describe_consumer_groups batches
//     to prevent SIGSEGV
//   - e09a57d  fix: prevent readiness-probe timeouts from blocking
//     FFI on async runtime
//   - d03f788  fix: reduce memory growth from pool consumers,
//     allocator fragmentation, and Vec reallocation
//
// Hvis tall ikke er målt presist: fall tilbake på kvalitativ
// formulering ("fra timed batch som holdt på å kneble
// clusteret, til streaming som bare går"). Ikke overselg.

Placeholder — tall/grafikk her.


// =============================================================
// MIDTDEL — hybrid struktur (valg: 2+4).
// Case-studien fra klag-exporter fortelles kronologisk, men hver
// bolk er navngitt etter *mekanismen* den demonstrerer. Læringen
// fremheves UNDERVEIS (ikke som egen oppsummerings-slide etter
// hver bolk) — hver bolk peaker i ett konkret "dette er gevinsten"-
// øyeblikk som peker tilbake til kjernebudskapet.
//
// Tidsbudsjett (30 min totalt):
//   Åpning + intro + agenda:   ~4 min
//   Bolk 1:                    ~6-7 min
//   Bolk 2:                    ~6-7 min
//   Bolk 3:                    ~6-7 min
//   Avslutning (tell them what you told them): ~3-4 min
//   Spørsmål/buffer:           rest
//
// TODO: ordlyden på bolk-titlene avhenger av ordlyds-dialogen om
// læringspunktene (kommer i neste intervju-runde). Forslagene
// under er foreløpige og skal revideres.
//
// Terminologi avklart så langt:
//   - "tilbakekobling" → "feedback loop" (Christian: det opprinnelige
//     ordet var forvirrende; feedback loop er det vi faktisk mener).
// Utsatt til vi fyller inn bolkene:
//   - NOTES.md læringspunkt #5 (FOSS-adopsjon = tørre å modifisere) —
//     Christian ønsker dialog om ordlyd, men tar det senere.
//   - NOTES.md læringspunkt #6 (fryktløshet som "funksjon av"
//     verktøykjeden) — Christian foreslår mykere framing:
//     "effekt/utfall/konsekvens av". Endelig ordlyd senere.
// =============================================================

= Er Rust-kompilatoren oppskrytt?

// Narrativ: batch→streaming-refaktoren (d99f656).
// Tittel som retorisk spørsmål — bolken svarer ut spørsmålet
// ved å vise konkrete eksempler på hva kompilatoren fanget av
// LLM-forslag. (Mild overstyring av R2: tittelen er provokativt-
// retorisk, ikke en vits — akseptabelt unntak.)
//
// Åpne med motivasjon (R1): hvor kom behovet fra?
//   - Klag-exporter tålte ikke størrelsen på Kafka-clusterne
//   - 32+ GiB minnebruk, prosessering tok minutter
//   - Noe måtte gjøres; batch-modellen var dødfødt
//
// Mekanisme som demonstreres: kompilatoren som samarbeidspartner
// (Rust-typesystem fanger LLM-feil).
// Læringspunkt som skal fremheves underveis: NOTES.md #2
// (kompilatorer som samarbeidspartnere) + hintet om #1
// (feedback loop som ramme) som bolken gir konkret kjøtt til.
//
// TODO: konkret "da-øyeblikk" — finn den spesifikke commiten
// eller det spesifikke PR-kommentar-øyeblikket der LLM foreslo
// noe kompilatoren avviste. d99f656 er det store omrisset, men
// vi trenger ett "zoom-in"-eksempel: en type-signatur, en borrow-
// check-feil, eller lignende som er lett å vise i ett kodeeksempel.
//
// TODO: før/etter-minnebruk-grafen hører hjemme her (32 GiB →
// 50-200 MiB), ikke i åpningen — åpningen bare teaser tallene.
// Eller: teaser i åpning, full graf her. Avklar.

Placeholder — innhold bolk 1.

= FFI i fremmed land? Nix!

// Tittel: ordspill — "Nix" som både tysk "ingenting" (på norsk:
// "slapp av, det er pytt-småtteri") og som verktøy-navnet. Sier
// implisitt: "FFI-trøbbel? Nix-verktøykjeden løser det."
//
// Åpne med motivasjon (R1): hvor kom behovet fra?
//   - Streaming-refaktoren avdekket råttenskap i librdkafka-FFI
//   - Crashes i produksjon (SIGSEGV), double-free, blocking FFI
//     på async runtime — ting som ikke kan fikses med mer Rust
//   - Måtte inn i C-biblioteket selv; scary territorium
//
// Relevante commits:
//   - d68bb0c  librdkafka double-free
//   - a30f0d9  bound concurrent describe_consumer_groups (SIGSEGV)
//   - e09a57d  blocking FFI på async runtime
//   - 85df581 + af00152  SIGSEGV handler installert og så
//     reverted — selv-ironisk øyeblikk, egnet for humor (muntlig).
//
// Mekanisme som demonstreres: reproduserbart bygg + SBOM.
// Nix gjør at "fork av underliggende C-bibliotek og patch"
// ikke er skummelt — fordi bygget er hermetisk og lett å rulle
// tilbake.
// Læringspunkter som skal fremheves underveis: NOTES.md #3
// (reproduserbarhet) + #4 (SBOM).
//
// TODO: konkret "da-øyeblikk" — en liten demo av hvordan
// flake.nix-overlayet ser ut for patched librdkafka? Eller et
// diff-utsnitt? Kort — publikum skal ikke lære å skrive flakes.
//
// Humor-ankerpunkt: SIGSEGV-handler installert og reverted samme
// dag. Leveres MUNTLIG (R2). Slide kan ha reaksjons-bilde (frykt/
// tårer) som illustrerer øyeblikket.

Placeholder — innhold bolk 2.

= Forke 14 år gammelt C-bibliotek? Pft, barnemat!

// Tittel: ironisk overkonfidens — retorisk grep der bolken viser
// at det faktisk BLE nesten-enkelt, fordi verktøykjeden bar meg.
// Tall for å selge skrekken i åpningen av bolken (hvis det
// passer inn i R1-motivasjonen):
//   - librdkafka: ~150 000 linjer C/C++, 251 C-filer, 14 år gammelt
//   - 572 åpne issues, 258 åpne PRs (per april 2026)
//   - 15 bundlede tredjeparts-avhengigheter (snappy, lz4, zstd,
//     hdrhistogram, regexp, cjson, nanopb, opentelemetry, crc32c,
//     fnv1a, murmur2, pycrc, queue, tinycthread, wingetopt)
//   - for en gjengs Java/.NET-utvikler: manuell memory management,
//     ingen borrow checker, segfault-risiko overalt
//
// Punchline-bolken. Etter bolk 1 + 2 har publikum sett mekanismene.
// Nå viser vi hva de gjør MULIG: at du faktisk våger å gå inn i
// en underliggende FOSS-avhengighet og modifisere den — fordi
// resten av verktøykjeden holder deg trygg.
//
// Åpne med motivasjon (R1): hvor kom behovet fra?
//   - Etter Nix-bolken: patchene våre var på toppen av
//     librdkafka; men noen feil satt DYPT i C-koden
//   - Tradisjonelt: "fork et C-bibliotek" = månedsvis med
//     vedlikehold, redsel for å miste kontroll, låst inne i
//     egen versjon for alltid
//   - Vårt behov: fikse bug i librdkafka uten at det føles
//     som et livslangt ekteskap
//
// Mekanisme som demonstreres: FOSS-adopsjon som handling, ikke
// bare som "vi bruker biblioteket".
// Læringspunkter som skal fremheves underveis: NOTES.md #5
// (FOSS-adopsjon = tørre å modifisere) + setter opp #6 (punchline
// i avslutningen).
//
// TODO: ordlyden her avhenger av ordlyds-dialogen om
// NOTES.md #5 ("???") og #6 (effekt/utfall/konsekvens).
//
// TODO: konkret moment — hva var det som gjorde at du faktisk
// turte? Var det ett spesifikt øyeblikk? En samtale? En grønn
// CI-build? Finn "det før jeg turte / det etter jeg turte"-
// kontrasten.

Placeholder — innhold bolk 3.

= Avslutning

== Det vi har vært gjennom <touying:hidden>

// "Tell them what you told them." Rekapitulerer de tre bolkene
// kort, deretter kjernebudskap.
// TODO: ordlyd avhenger av læringspunkt-dialogen.

Placeholder — rekap + kjernebudskap.

== Takk <touying:hidden>

// Kontaktinfo, repo-URL (samme som footer), evt. QR-kode.
// TODO: spørsmål/buffer-håndtering — ta spørsmål her, eller
// henvise til pause etter?

Placeholder — takk + kontakt.




