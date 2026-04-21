# Notater — utgangspunkt for talken

Disse notatene fanger *rammen* for hva talken skal være, slik at slides
kan bygges uten å miste tråden. Ikke en offisiell NAV-posisjon — et
personlig fagbidrag.

## Konferanse / kontekst

- **Arrangement:** Offentlig Fagdag — <https://offentligfagdag.no/program>
- 30 min slot, første etter åpningstalen.
- **NAAS** = «Nais (nais.no / applikasjonsplattformen) As A Service»,
  alt. «Nais for Norge». Et konsept/slagord fra Nais-verdenen som nevnes
  kort i introduksjonen som kontekst for hvorfor temaet er relevant for
  publikum — ikke navnet på arrangementet, og ikke tema for talken.

## Blurb (slik den ble sendt inn)

**Arbeidstittel (ny):** Fryktløs (GenAI) koding

**Opprinnelig tittel (fra blurb):** Hvordan Nix & Rust forenkler (F)OSS adopsjon!

**Beskrivelse:**

> Jeg vil fortelle om hvilke fordeler jeg opplevde når jeg forsøkte å
> adoptere opensource prosjekter vha. styrkene til Rust kombinert med Nix!
>
> Rust gir feks:
> - kompilatorgarantier (kompilerer det er businesslogikkimplementasjon
>   garantert å fungere)
> - ytelse
>
> Nix gir feks:
> - reproduserbar utviklings-miljø
> - SBOM kontroll på tvers av software-økosystemer
>
> Sammen gir disse to meg ganske stor trygghet mtp:
> - bruk av LLM til koding — kompilerer det/passerer det tester, funker det
> - stålkontroll på hva som dras inn i bygg, og hva som spyttes ut i andre enden
> - portabelt mellom andre x86-64_linux systemer! (lokal laptop, github
>   actions CI/CD, k8s containers)

## Hva talken *er*

En praktisk, lettfordøyelig fortelling om hvordan Rust + Nix + GenAI,
brukt sammen, gjør det mindre skummelt å ta i bruk — og *modifisere* —
FOSS man er avhengig av.

Målet er at tilhørerne går ut med **konkret læring de kan ta med seg
tilbake til egen hverdag** om hvordan GenAI kan brukes mer fryktløst når
verktøykjeden rundt gir tilbakekobling man kan stole på.

## Hva talken *ikke* er

- Ikke en selvbiografi. Jeg er ikke hovedpersonen — læringspunktene er.
- Ikke en klagesang om mine utfordringer. Fingerbetennelse nevnes kort i
  introduksjonen (ærlig, men ikke som tema), og forsvinner deretter.
- Ikke en religiøs preken om at Rust og Nix er best. Det handler om
  *mekanismer* som gir tilbakekobling, ikke om teknologivalgets hellighet.
- Ikke en tutorial. Publikum skal ikke gå ut og kunne skrive Nix-flakes;
  de skal gå ut med en ny tanke om hvordan man *tør* å bruke GenAI.

## Tone

- Interessant og lett å følge. Konkrete eksempler før abstraksjon.
- Selvbevisst / lett ironisk humor. Lov å flire av entusiasmen rundt Nix
  og egne tidligere feil. Ikke selvpiskende, ikke selvhøytidelig.
- **Heller for lite humor enn for mye.** Spredt krydder, ikke gjennomgående
  vits-motiv. Tas opp igjen når slides skal skrives.
- Ærlig om grensene for hva GenAI-assistert koding faktisk gir — ikke
  overselge.

## Kjernebudskap (én setning)

> Når verktøyene dine gir deg rask og ærlig tilbakekobling på om koden
> holder, kan du bruke GenAI mer fryktløst — og *da* blir det praktisk
> mulig å ta tak i avhengigheter du ellers ville latt være å røre.

## Bevismateriale jeg kan peke på

For å gjøre poenget konkret, ikke abstrakt, refererer jeg til reelle
commits og endringer jeg har gjort:

- Branchen [`deploy_our_own_helmchart` i `nais/klag-exporter`](https://github.com/nais/klag-exporter/tree/deploy_our_own_helmchart).
- Overgang fra batch-prosessering til streaming for å takle størrelsen
  på Kafka-clusterne.
- Fork og fiks av underliggende `librdkafka`.
- Øvrige endringer i helmchart-deploy og tilhørende infrastruktur.

Disse brukes som *case study* — bevismateriale som viser mekanismene i
praksis. Arbeidet skal absolutt frem (det er selve premisset for at jeg
har noe å si om dette), men det er *verktøykjeden* som er subjektet,
ikke prestasjonen.

Flere konkrete eksempler fra `klag-exporter` (spesifikke øyeblikk der
kompilatoren reddet et LLM-forslag, uventede Nix-opplevelser, osv.)
legges inn her når repo/utkast er kommet i gang.

## Om meg selv (kort intro, så videre)

Ærlig, kort, ikke dvele:

- Hvem jeg er og hvor jeg jobber.
- Første gang på flere år jeg tok GenAI aktivt i bruk til koding.
- Fingerbetennelse nevnes som én grunn til at jeg trengte akseleratoren
  — men også som et eksempel på at terskelen for «stort endringsarbeid»
  kan være forskjellig for ulike folk. Nevnt, ikke utbrodert.

Deretter flyttes fokus bort fra meg og over til det talken faktisk
handler om.

## Læringspunkter publikum skal sitte igjen med

Publikum skal sitte igjen med generaliserbare punkter de kan bruke i
egen hverdag. Mitt arbeid fungerer som *eksempler* som viser
mekanismene — ikke som en liste over bragder. Det er *innrammingen* som
er publikumsorientert, ikke at arbeidet skjules.

Disse punktene er utgangspunktet — ikke endelig agenda, men kompasset
når slides skal formes:

1. **Tilbakekobling er alt.** GenAI alene er ikke skummelt eller trygt —
   det avhenger av hva som fanger feilene dens.
2. **Kompilatorer som samarbeidspartnere.** Rusts typesystem fanger en
   stor andel av det LLM-er roter med. Ikke magi, men ingeniørkunst.
3. **Reproduserbarhet flytter risiko ned.** Når Nix garanterer at «det
   som bygger hos meg bygger likt i CI og i container», våger man å
   gjøre større endringer.
4. **SBOM uten ekstra innsats.** Supply-chain-oversikt kommer «gratis»
   som bieffekt, ikke som ekstra prosess.
5. **FOSS-adopsjon = tørre å modifisere.** Ekte adopsjon er ikke bare å
   bruke biblioteker, men å fikse dem når de ikke funker for deg.
6. **Fryktløshet er en funksjon av verktøykjeden.** Hvis dere tar med
   ett inntrykk hjem: det er dette.

## Humor / retorikk — ideer å spille på

- Selv-ironi om Nix-læringskurven («ja, jeg er blitt sånn én»).
- Ærlig om når GenAI leverte ubrukelig vrøvl — og hvorfor det var OK,
  fordi kompilatoren tok det.
- Kontrast «før-meg» og «etter-meg» på en måte som publikum kan le av
  uten å føle det er for personlig.

## Data og funn

Samlet mens VPN var tilgjengelig. Viktige tall å ikke miste.

### Kafka-skala (via `avn` CLI + Aiven-konsoll)

| Cluster             | Topics | Topic-ACLs |
|---------------------|--------|------------|
| dev-nais-dev        | 5      | 8          |
| nav-dev-kafka       | 1429   | 4658       |
| nav-prod-kafka      | 1025   | 3281       |

Størrelsesordener: nav-dev har **286×** flere topics enn dev-nais,
nav-prod har **205×**. dev-nais er der klag-exporter opprinnelig ble
utviklet mot; nav-dev er der den faktisk måtte kjøre.

**Broker-capacity:**
- nav-dev: 4 CPU / 16 GB / 4500 GB, 6-node HA, CPU ~75-80 %, minne 71 %
- nav-prod: 8 CPU / 32 GB / 13500 GB, 9-node HA, CPU ~40-50 %, minne 42 %

Ironi: prod-clusteret er større, men har lavere last for klag-exporter.

### AivenApps med Kafka per Kubernetes-kontekst

`kubectl get aivenapp -A -o json | from json | get items | where spec.kafka? != null | length`

| Kontekst  | Antall |
|-----------|--------|
| nav-dev   | 772    |
| dev-fss   | 267    |
| nav-prod  | 674    |
| prod-fss  | N/A (ikke nåbar via VPN) |

Dev-siden totalt: **1 039 apper** bruker samme Kafka via AivenApp-CRD.
Minimum-tall — apper kan snakke med Kafka uten AivenApp også (fotnote-
verdig).

**Hvorfor dette tallet er bedre enn consumer-groups:** sannferdig
(teller faktiske deployments, ikke scrape-artefakter), forståelig for
publikum, knytter direkte til rapids-and-rivers-arkitekturen.

### Consumer-groups (forkastet som metrikk)

Forsøkt via Mimir/Prometheus:
- `count(count by (group)(kafka_consumergroup_group_lag{cluster_name="nav-dev"}))` → 18 934
- nav-prod → 8 733, men ratio serier/groups = 1.0 (mistenkelig, `kafka-lag-exporter` i prod ser ut til å aggregere annerledes)

**Konklusjon: ikke bruk CG-tall.** For skjørt, krever for mye
kvalifisering. AivenApps-tallet dekker samme poeng tryggere.

### Minnebruk for klag-exporter (verifisert)

- **Peak (pre-fix):** 32+ GiB. Eskalerte 8 → 16 → 32 GiB fordi det var
  satt request men **ingen memory-limit** — så forbruket fikk lov til å
  vokse. Narrativet er "ingen limit → eskalering", ikke "vi doblet
  request for å stabilisere".
- **Post-fix (feb 19):** 943 Mi / 236 m CPU (fra
  `kubectl top pod`). Se `assets/grafana/kubectl-top-postfix-feb19.png`.
- **Historisk "50-200 MiB"-tall var korrekt** — i en periode var
  forbruket så lavt. Tallet bekreftes via commit-historikk heller
  enn graf (vi valgte å ikke bruke tid på Grafana-graf for det
  perioden).
- **Prosesseringstid-vinduet:** målkravet var **20-30 sek per
  collection cycle** (neste prosesseringsvindu begynner). Pre-fix
  tok cycle-en *minutter* og rakk aldri å ferdigstille før neste
  begynte. At fiksen klarte å fullføre innenfor 20-30 sek var like
  viktig som minnegevinsten — CPU-effekten var spesielt tydelig
  her. Ikke bare minne: CPU også, men minne var største effekten.

### Kilder som er forsøkt og forkastet

- **Loki:** `{app_name="klag-exporter"}` i `dev-gcp-loki`/`prod-gcp-loki`
  gir null. Feb-19-data er sannsynligvis ute av retention (30d, ikke 90d
  som docs sier). dev-nais-Loki har logger men feil cluster for
  narrativet.
- **Slack-søk:** droppet (brukerens valg).
- **Prometheus long-term storage:** droppet, ikke nødvendig.

### Alternativer vurdert til klag-exporter

Kandidater som ble vurdert og forkastet før valget falt på
`softwaremill/klag-exporter`:

- **JVM:** `lightbend/kafka-lag-exporter` (forløperen til seglo-forken)
  — også dårlig vedlikeholdt / endte opp som seglo-arkivering.
- **Go:** `danielqsj/kafka_exporter`, `linkedin/Burrow`.

**Viktigste utvelgingskriterium: drop-in metrikknavn-kompatibilitet.**
Flere av Go-/Java-kandidatene ble valgt vekk fordi de mest sannsynlig
ville krevd re-labeling av metrikknavn i Prometheus/Grafana-oppsettet
vårt. Å bevare eksisterende dashboards/alerts var viktigere enn ren
ytelse. Ytelse-ved-NAV-skala (tusenvis av topics/CGs i
rapids & rivers-stil) var sekundær men fortsatt relevant grunn.

TODO: verifisere faktisk metrikknavn-match mellom `seglo/kafka-lag-exporter`
og `softwaremill/klag-exporter` — har antatt drop-in-kompatibilitet i
talken.

## Organisering av assets

`assets/grafana/` inneholder skjermbilder fra 19. februar 2026 med
beskrivende norske filnavn:

| Fil                                    | Innhold                                     |
|----------------------------------------|---------------------------------------------|
| `minnebruk-eskalering-feb19-1t.png`    | 1-times Grafana: pods klatrer til 180 %, flere restarts (rød stiplet = restart-hendelser) |
| `ressursbruk-prosent-feb19-1t.png`     | Samme vindu, "% of requested"-dashboard, 6 pods |
| `kubectl-top-postfix-feb19.png`        | Terminal: 236 m / 943 Mi etter fix          |
| `minnebruk-24t-overgang.png`           | 24t: kaos tidligere samme dag → stabilt resten av dagen ("gull" for før/etter) |
| `minnebruk-2dager-stabilt.png`         | 2 dager: stabiliteten holdt                 |

## Avgjørelser tatt — innramming

- **Valg 1** (`<touying:skip>`-problem for *Kort om meg*): **utsatt** —
  bestemmes senere.
- **Valg 3c** (skala-tall-plassering): **teaser i Motivasjon + detaljer
  i Bolk 1**.

## Avgjørelser tatt — hovedkroppen

Gjelder hovedkroppen (bolk 1-3) med bilder + commit-anekdoter.

- **Scope = 1c:** alle tre bolker dekkes i denne runden (03-rust,
  04-ffi, 05-fork). Grafana-bilder finnes kun for feb 19 (bolk 1);
  bolk 2 og 3 skrives uten graf-dekning.
- **Arbeidsmåte = 2b + 2c:** commit-historien er regjerende "master".
  Behold eksisterende seksjonsstruktur (`==`-titler), men skriv om
  innholdet med utgangspunkt i commits og anekdoter.
- **Bilderolle = 3b + 3c:** pick per bilde — noen bilder er "hero"
  (eget slide, stor, bærer historien), andre er illustrasjoner i
  grid med tekst. Valg per bilde basert på hva som passer.
- **Anekdotekilde = 4:** både commit-meldinger (ordrett / sitert) og
  brukerens egne anekdoter fra hukommelsen.

## Avgjørelser tatt — poleringsrunde

Polerings- og refreng-runde på ferdigskrevne bolker.

### Tekst-omskrivinger

- **`04-ffi.typ` slide `== JEMALLOC_OVERRIDE`:** kraftig forenkling
  (valgt variant 3). To korte prosa-bullets uten inline-kode, sentrert
  code-block, droppet den redundante grå "Nix leverer pkgs.jemalloc
  reproduserbart"-linjen. Tekniske detaljer (`glibc malloc`,
  `MetricPoint`, `tikv-jemalloc-sys`, GCC 15-bug) flyttet til
  `#speaker-note`.
- **`04-ffi.typ` slide `== Fra Rust ned i C`:** valgt variant 2.
  Tre prosa-bullets uten inline-backticks, rød payoff-linje
  "Crashen skjer på C-bibliotekets egne tråder — usynlig for Rust."
  som setter opp revert-historien. `sigfillset`-detaljen til
  speaker-note.
- **`05-fork.typ:87`:** "rev-lagde" (ikke-eksisterende ord) →
  `reverterte`. Konsistent med *forket*/*patchet* på samme linjer.
- **`05-fork.typ` tabell `block_in_place`:** den ene inline-backticken
  i FFI-helvete-tabellen beholdes som den er. Presist API-navn,
  ingen rytmebrudd.

### Refreng-plan (låst)

Se oppdatert §"Gjennomgående prompt-teknikker" for full låst liste:
5 emoji-baserte badges + én oppsummerings-slide etter bolk 3.
Format-avgjørelse: flettet løpende (badges på utvalgte slides)
**+** egen oppsummerings-slide — begge deler, ikke enten-eller.

### Teknisk konvensjon oppdaget / bekreftet

- `#raw()` i `#speaker-note[...]` bryter kompilering (Touying 0.5.3
  + Typst 0.14.2-regresjon). Bruk backticks, ikke `#raw()`, i
  speaker-notes.
- For å hindre line-wrap midt i inline-kode-identifier (f.eks.
  `extern "C"`, `Offset::End`), pakk i `#box[\`...\`]`.

### Klokkeslett-konvensjon (låst)

Klokkeslett beholdes kun i slide-body. I speaker-notes, kommentarer
og NOTES.md brukes relative referanser (tidligere/senere/samme dag);
ikke vage "tidlig/sent". Agenter skal ikke ta opp klokkeslett i
slide-body som problemstilling — de står som de står.

## Åpne avgjørelser — refreng og teknikk-tabell

### Låst i poleringsrunden

- **Format på teknikk-tabeller (overgangs- og full oppsummering):
  Alt. A** — tabell med `emoji | navn | én-linje-forklaring`.
- **Progressive overgangsslides per bolk:** hver bolk avsluttes med
  en liten teknikk-tabell i format A, men kun emojis bolken har
  introdusert så langt får forklaring. Uintroduserte emojis vises
  som grå/antydede rader — publikum kjenner igjen tabellen fra
  forrige bolk og ser den fylles ut.
- **Plassering av full oppsummering:** slått sammen med eksisterende
  `== Det vi har vært gjennom` i `06-avslutning.typ`. Altså: én
  kombinert rekap-+-teknikk-slide, deretter `== Takk`. Ikke egen
  teknikk-slide mellom.

### Konsekvens for progressive tabeller

Emoji-introduksjons-rekkefølge (utledet fra badge-mapping):

| Bolk | Nye emojis introdusert | Akkumulert sum |
|---|---|---|
| Bolk 1 | 🧹 (`Første refaktor`), 👁 🔍 (`Dagen det snudde`), 🚨 (`Etterslep`) | 4 |
| Bolk 2 | 🔒 (`Jeg turte å prøve`) | 5 |
| Bolk 3 | *(ingen nye — 🔒 og 👁 er begge gjenbruk)* | 5 |

**Løst:** bolk 3 beholder overgangsslide med *samme* 5 rader som
bolk 2, men med annen innpakning (f.eks. "alle fem i spill nå" som
overskrift). Markerer bolk 3 som syntesen der alle teknikker brukes
samtidig.

### Gjenstående (implementasjon)

1. **Typst-helper i `common.typ`** for `#badge(..emojis)` som gjør
   `place(right + horizon)` med vertikal stack.
2. **Typst-helper for progressive teknikk-tabell** — tar inn hvilke
   emojis som skal være "levende" vs. "grå/antydet".
3. **Anvend badges** på de 6 slidene per mapping.
4. **Skriv 2-3 overgangsslides** (antall avhenger av bolk-3-avgjørelsen).
5. **Slå sammen full oppsummering** inn i `06-avslutning.typ:== Det vi
   har vært gjennom` — den eksisterende bolk-rekapen beholdes;
   teknikk-tabellen legges til under.

## Avgjørelser tatt — GenAI-gevinst-tråd

Bakgrunn: presentasjonen var tung på defensiv postur
(sikringsteknikker) og lett på hva GenAI faktisk *leverte*. Brukeren
foreslo en parallell tråd som mirrer sikringsteknikk-tråden i
plassering, men ikke i form.

### Låst

- **Plassering per bolk = 1c:** én ny slide rett *etter*
  `== Agent sikringsteknikker` i hver av bolk 1–3.
- **Titler (unike, positivt-rettet):**
  - Bolk 1 (`03-rust.typ`): `== Detektivrydderen`
  - Bolk 2 (`04-ffi.typ`): `== Fryktløs patching`
  - Bolk 3 (`05-fork.typ`): `== Effektiv arkeolog`
- **Oppsummeringsslide:** `== Hva GenAI gav meg` — plassert rett
  *før* `== Det vi har vært gjennom` i `06-avslutning.typ`.
- **Ingen badges, ingen emojis, ingen mirror av 5-element-struktur.**
  Eksplisitt korreksjon fra brukeren. Tråden er prosa + kategorier,
  ikke tabell med ikoner.
- **3 kategorier** (fra brukerens egne eksempler, ikke generert):
  - (a) store refaktoreringer (BaseConsumer → AdminClient, streaming
    pipeline)
  - (b) kode-arkæologi i ukjent terreng (sigfillset i 150k linjer C,
    Admin API i j-santander-fork, jemalloc-mekanisme)
  - (c) rotårsaks-analyse fra metrikker (minne × consumer groups,
    93 % av cycle i timestamp-henting)

### Ikke låst (utsatt)

- **Format på de 4 slidene (valg #5):** provisjonelt innhold lagt
  inn med grid + rød kategori-label + prosa. Markert `// PROVISJONELT
  INNHOLD — format-avgjørelse utsatt` i alle fire filer.
  Brukeren reviderer etterpå.

### Åpne TODO-er i provisjonelt innhold

- `03-rust.typ:Detektivrydderen` — vurder å trimme fra 3 til 2
  kategorier hvis for tett. Payoff-linje ("Arbeidet hadde vært gjort
  uansett — men ikke på én helg") er utkast.
- `04-ffi.typ:Fryktløs patching` — tredje kategori (revert-drevet
  utforskning) overlapper med "Jeg turte å prøve" tidligere i bolken.
- `05-fork.typ:Effektiv arkeolog` — "Oppdagelse av fork" kan passe
  bedre i bolk 1, men det var agent-arkæologi i essens. Brukerens
  avgjørelse.
- `06-avslutning.typ:Hva GenAI gav meg` — payoff-linje ("Sikrings-
  teknikkene gjorde agenten trygg å bruke. Agenten gjorde arbeidet
  mulig å fullføre.") knytter de to trådene. Vurder om den skal
  flyttes til `Det vi har vært gjennom` i stedet.

## Gjennomgående prompt-teknikker (bolk-kryssende tema)

Brukes på tvers av alle bolker som gjennomgående læringspunkt om
*hvordan* agenten ble brukt — ikke bare *hva* den leverte. Dette er
mekanismen bak "fryktløshet" i praksis.

- **Agenten får aldri committe eller kjøre tester selv.** All
  verifisering gjøres av verktøykjeden (se under) og manuell
  gjennomgang. Agenten er forslagsstiller, ikke utfører.
- **Fil-endringswatch i egen terminal** som automatisk fyrer av Rust
  sine kompilatorsjekker + tester ved hvert lagre. Tilbakekoblingen
  blir umiddelbar og uavhengig av hva agenten selv rapporterer.
- **Agenten må alltid vente på mine innspill** før den sier seg
  ferdig med noe eller fortsetter. Eksplisitt krav i prompten —
  hindrer at den "glir videre" på egen hånd.
- **"Rydd opp i koden først"** som første øvelse. Brukes dobbelt:
  (a) gjør koden lettere å jobbe med, (b) lar meg bli kjent med
  kodebasen via agenten før store endringer begynner.
  Kobler til klippet Feb 18→19 (clippy pedantic-commit
  `2c56a2c`): "this lets me get more familiar w/the code".
- **`git add -p` på alle endringer** — hver hunk manuelt gjennomgått
  før den stages. Gir meg siste ord; fanger opp ting agenten ikke
  nødvendigvis har flagget.
- **Anti-juks-sjekk:** agenten skal ikke fjerne/forenkle kode eller
  tester for å få ting til å passere. Manuell `git add -p`-gjennomgang
  er hovedmekanismen som fanger dette — når noe først passerer
  tester/lintere/bygg, må jeg se selv om veien dit var legitim.
- **Rust sitt sterke typesystem som tryggheten bak regimet.**
  Kompilerer det, skal i utgangspunktet kun forretningslogikk kunne
  trigge feil. **Foreshadowing:** dette premisset brister i bolk 2
  når librdkafka kommer inn — kompilatoren slutter brått å kunne
  hjelpe når stacken ikke lenger er Rust hele veien ned.
- **Flotte kompilator-feilmeldinger** gjør tilbakekoblingen fra
  watch-terminalen faktisk handlingsrettet — ikke bare "feil/ikke
  feil", men "her er problemet, her er forslag til fiks".

### Hva dette betyr for slidene

- **Plassering (låst i poleringsrunden):** flettet inn løpende som
  refreng per bolk *og* egen oppsummeringsslide etter bolk 3 (før
  avslutning). Refrenget bruker både emoji-badges på utvalgte slides
  *og* én egen overgangsslide per bolk.
- Flere av disse punktene kobler direkte til eksisterende commits:
  `2c56a2c` (clippy-opprydding), "LLM-basert"-fotnoter i bodyene,
  debug-klippet Feb 18→19 (`21b7ff1` "debug: output some logs to
  differentiate when code hangs" = tilbakekobling når agenten ikke
  forsto hva som skjedde).

### Kurert teknikk-liste (5 stk)

Kuratet ned fra 8 punkter over. Sammenslåinger: "Agenten får ikke
committe" + "må vente på innspill" → én teknikk (*Begrenset
handlingsrom*). "Flotte kompilator-feilmeldinger" subsumeres av
*Fil-watch*. "Rust typesystem" utelatt som meta-ramme (ikke teknikk).

| # | Emoji | Teknikk | Forklaring |
|---|---|---|---|
| 1 | 🧹 | Rydd opp først | clippy pedantic før AI fikk slippe til |
| 2 | 🔒 | Begrenset handlingsrom | agenten får ikke committe/kjøre git, må vente på klarsignal |
| 3 | 👁 | Fil-watch | egen terminal re-kompilerer + kjører tester kontinuerlig |
| 4 | 🔍 | `git add -p` | manuelt syn på hver hunk før staging |
| 5 | 🚨 | Anti-juks-sjekk | agenten skal ikke fjerne tester for å få bygg grønt |

**Emoji-plassering:** `place(right + horizon)` — vertikal stack på
høyre kant når en slide har flere. Ingen tekstreferanse utenom der
teknikken introduseres/forklares (oppsummerings-slide etter bolk 3).

### Badge-mapping (låst)

6 badge-plasseringer, 8 emoji-instanser. Dekning: 🧹 1×, 🔒 2×, 👁 3×,
🔍 1×, 🚨 1×.

| Slide | Badges |
|---|---|
| Bolk 1 `== Første refaktor-bølge` | 🧹 |
| Bolk 1 `== Dagen det snudde` (hero) | 👁 🔍 |
| Bolk 1 `== Tuning-dagen etterpå` | 👁 |
| Bolk 1 `== Etterslep` | 🚨 |
| Bolk 2 `== Jeg turte å prøve` (hero) | 🔒 |
| Bolk 3 `== Feb 23–25` (hero) | 🔒 👁 |

Andre slides (problem-framing, JEMALLOC-Nix-poeng, oppsummeringer)
får *ingen* badge.

## Gjenstående TODO-er

- Bolk 1 zoom-in-eksempel: konkret kompilator-fang av LLM-forslag.
- Bolk 2 flake.nix-diff-utsnitt for patched `librdkafka`.
- Bolk 3 "før/etter jeg turte"-kontrast.
- 4-6 reaksjonsbilder/gifs for følelses-beats (R2, visuell humor).
- Prosesseringstid-verifisering (hvis overhodet).
- CI/build-tider fra GitHub Actions (hentes senere).

## Commit-korrelasjon — `klag-exporter@deploy_our_own_helmchart`

Kilde: `/tmp/klag-commits.txt` (715 linjer, 68 branch-spesifikke commits
hentet med `git log --format='%H %ai%n%B' --no-merges` + merges).
Tidsstempler er `+0100` (CET, lokal).

### Bilde → commit-vindu

Filene i `assets/grafana/` har mtime 2026-04-20 pga senere `mv` —
**mtime er ikke capture-tid**. Korrelasjoner under er basert på hva
bildene viser (akser, pod-tellinger, stabilitet) og sesjons-hukommelse.

| Bilde | Sannsynlig vindu | Narrativ-anker |
|---|---|---|
| `minnebruk-eskalering-feb19-1t.png` | Feb 19, senere samme dag | Etter `d99f656` (streaming-refactor). Pods klatrer fortsatt til 180 %, flere restarts — *tuning-deploys* som fulgte refactoren, ikke pre-refactor-tilstand |
| `ressursbruk-prosent-feb19-1t.png` | Samme vindu | Samme, "% of requested"-view |
| `kubectl-top-postfix-feb19.png` | Feb 19, senere samme dag | Etter at siste tuning-deploy satte seg: 236 m / 943 Mi |
| `minnebruk-24t-overgang.png` | Feb 19 | Kaos tidligere samme dag ≈ pre/under `cb6275f` (per-group BaseConsumer-eliminering). Stabilitet etter at `d99f656` ble deployet |
| `minnebruk-2dager-stabilt.png` | Feb 19-20 eller 20-21 | Stabiliteten holdt gjennom perf-tuning-dagen Feb 20 |

**Viktig nyanse for talen:** `minnebruk-24t-overgang.png` fanger ikke
én fix — den fanger to hendelser samme dag (cb6275f + d99f656) som
sammen flyttet appen fra "DDOS-er seg selv" til "stabil". Det er greit
å presentere som "dagen da det snudde" uten å love at det var ett
grep.

### Fase-gruppert tidslinje med fulle commit-bodies

#### Fase 0: Testing-infra (Feb 6)

Grunnlag for å i det hele tatt kunne teste mot et stort cluster. En
enkelt commit, 13 dager før resten.

```
6ed01b4 2026-02-06
added testing env for large cluster setup
```

#### Fase 1: Admin API-research på fork (Feb 19, tidligere samme dag)

Arbeid gjort mot `softwaremill/klag-exporter` (før NAV-fork). Dette er
*opprinnelsen* til Admin API-tilnærmingen, som klag-exporter senere
får via j-santander/x10an14-nav-fork av rust-rdkafka.

```
457c859 2026-02-19
make base consumer reusable with Arc

2ea717a 2026-02-19
klag-exporter/src/kafka/client.rs
  - Replaced list_consumer_group_offsets() — was using
    committed_offsets() on the shared consumer (which only works for the
    consumer's own group.id). New implementation uses rdkafka-sys FFI
    to call rd_kafka_ListConsumerGroupOffsets through the existing
    AdminClient's native handle. Takes group_id, partitions, and timeout
    as parameters.
  - The FFI method uses an RAII Cleanup guard to ensure all C objects
    (queue, event, options, request, partition list) are freed on any
    exit path.
  - Removed bootstrap_servers() and consumer_properties() accessors — no
    longer needed.

  klag-exporter/src/collector/offset_collector.rs
  - Rewrote fetch_all_group_offsets_parallel() to call
    client.list_consumer_group_offsets() instead of
    fetch_group_offsets_standalone(). Same semaphore-based concurrency,
    same error handling.
  - Removed fetch_group_offsets_standalone() (60-line function creating
    a BaseConsumer per group).
  - Removed fetch_group_offsets() (sequential version, also created
    per-group consumers).
  - Updated the sequential collect() to also use the Admin API.

  klag-exporter/src/error.rs
  - Added KlagError::Admin(String) variant for Admin API FFI errors.

  Impact
  - Zero additional FDs for offset fetching — routes through the
    existing AdminClient connection.
  - No connection churn — eliminates TCP/TLS/SASL handshake per group
    per cycle.
  - Timestamp fetching unaffected — TimestampConsumer is a separate
    component.

0a795fa 2026-02-19
Consumer Pool for Timestamps
  [se /tmp/klag-commits.txt:49-80 for full body — pool-basert
  TimestampConsumer som eliminerer connection-churn]

5c4b237 2026-02-19    copilot review
9a28343 2026-02-19    fix formatting
7a741c8 2026-02-19    fixing copilot review
7e52a60 2026-02-19    Merge PR #45 (testing-large-cluster)
f7932ac 2026-02-19    chore: release v0.1.15
d04a401 2026-02-19   chore(helm): update chart to 0.1.15
cca56c4 2026-02-19    Merge PR #47 release-plz
```

#### Fase 2: CI/helm yak-shaving (Feb 16-18)

Uker *før* den tekniske kjerne-fiksen. Alt dette er "bare å få den
deployet i det hele tatt". Feb 17 er konsentrert "GHA sucks"-dag (13
commits på én dag). Relevant som fallgruve-eksempel (R3): kjedelig,
men nødvendig infrastrukturkostnad før den interessante koden kan
testes på ekte cluster.

```
Feb 16:
8d2b5c5  feat(helm): permit configuration of exporter.performance settings
               (Maybe missed as part of PR #41?)
63b49b4  feat(helm): permit configuration of log level
af1656e  feat(nais): add docker image
ff71a73  feature(helm): deploy helm chart too      (+ sindrerh2)
e1acdd0  ci(nix): add cache
5921761  fix: use correct SA after it's been made  (+ sindrerh2)
               See nais-io-terraform-modules PR #460

Feb 17 — "GHA sucks"-dag:
5d58cc0  fix(helm/docker): set expected tag
8af9a1c  fix(ci): remove incorrectly configured steps (TODO: back later)
71c84bc  fix(ci): remove leftover erroneus config
922d23b  fix(ci/helm): use correct SA name
b7b10f4  fix(ci/helm): GHA sucks                    ← dagens tittel
7c3bf1b  fix(fasit): track fasit-feature
a44161e  fix(fasit): use correct coordinates
bcb0400  fix(fasit): explicitly set versions
df7134a  fix(ci/fasit): add missing fasit-deploy :facepalm:
d0d541c  ci(fasit): use correct runner
b238e34  fix(helm): run w/permissible pod configs
310f026  fix(helm): set correct name for k8s resources
22fb5bc  fix(helm): add missing labels (app=, aiven=enabled for netpols)
b7ec827  fix(helm): add missing k8s secrets
ea84bd1  fix(helm): enable more required k8s stuff
77da028  fix(helm): test more sane defaults

Feb 18:
5275c7c  fix(healthcheck): be less conservative (timeouts happen)
5d31547  fix(helm): tune Feature.yaml templating
0fcd001  fix(helm): templating coordinate error
37ad3ea  fix(fasit): allow us to configure resource requests
5f0a259  feat(helm): add liveness and readiness probe configurations
1355e50  fix(helm): improve handling of cluster and secret name
ff999b8  feat(helm): add group whitelist configuration    (+ x10an14-nav)
b859f4b  test(fasit/helm): can we manually modify a template?
62a93a1  feat(helm): enhance liveness/readiness probe parameters
c188e02  fix(helm): increase startupprobes
04a82e9  cleanup(helm): remove Feature config w/colliding chart coordinates
```

#### Fase 2.5: Debug-loop Feb 18→19

Klippet Feb 18→19, akkurat før den store fiksen. Mønster-eksempel: clippy
+ mer logging + "ready-state"-opprydding + "debug: output logs to
differentiate when code hangs" — dvs. *jeg forstår ikke hvorfor det
henger, la meg se mer*.

```
2c56a2c 2026-02-19
refactor(clippy): (almost) satisfy clippy w/-W clippy::pedantic
                  -W clippy::nursery -W clippy::unwrap_used
- this lets me get more familiar w/the code
- cleans it up a bit

acc9b21 2026-02-19    refactor: remove redundant trace-span fields
e268a77 2026-02-19    upkeep: ensure we set ready-state until we've got reason not to
21b7ff1 2026-02-19    debug: output some logs to differentiate when code hangs
```

#### Fase 3: Første memory-fix (Feb 19) — HERO

Dette er *hvor det snudde*. cb6275f rydder 220 linjer unsafe FFI,
eliminerer per-group BaseConsumer, går fra `O(concurrent_groups × 25MB)`
til `O(1)`. Eksplisitt kreditt til `kafka-lag-exporter` (Scala) for
tilnærmingen og til j-santander/x10an14-nav-forken av rust-rdkafka som
*muliggjorde* den i Rust.

```
cb6275f 2026-02-19
fix: eliminate per-group BaseConsumer allocation to resolve memory/CPU exhaustion

klag-exporter's memory and CPU usage grew proportionally with the number
of monitored consumer groups because rdkafka's Consumer API requires a
dedicated BaseConsumer instance (each ~15-30MB with its own librdkafka
client, buffers, and thread pool) for every group whose committed offsets
are queried.
At scale (4-5 digit consumer groups), this caused the exporter to
effectively DDOS itself — creating thousands of concurrent Kafka
connections and consuming gigabytes of memory per collection cycle.

The Scala-based project kafka-lag-exporter avoids this entirely by using
the Kafka Admin API's listConsumerGroupOffsets(), which queries any
group's offsets through a single shared AdminClient connection.
Until now, rdkafka lacked this Admin API.
A fork (https://github.com/j-santander/rust-rdkafka, rebased on top of
latest rdkafka master through https://github.com/x10an14-nav/rust-rdkafka)
adds the missing bindings, enabling the same approach in Rust.

This refactor switches all Kafka interactions to the high-level Admin API
so that a single AdminClient replaces the per-group BaseConsumer pattern:

- Committed offset fetches now go through
  AdminClient::list_consumer_group_offsets() instead of creating a
  throwaway BaseConsumer per group, eliminating the dominant source of
  memory growth.
- Consumer group descriptions now use a single batched
  AdminClient::describe_consumer_groups() call, which also returns parsed
  member assignments natively — removing 60 lines of manual binary
  protocol parsing (parse_member_assignment).
- Per-partition fetch_watermarks() calls (N blocking calls, one per
  partition) are replaced by two concurrent AdminClient::list_offsets()
  calls (earliest + latest), reducing watermark fetching from
  O(partitions) Kafka round-trips to O(1).
- All ~220 lines of unsafe FFI code are eliminated — the codebase now
  contains zero `unsafe` blocks.

The collection pipeline is also restructured to avoid holding all
intermediate data in memory simultaneously.
Previously, all group offsets were collected into a large HashMap before
being transformed into snapshots.
Now each spawned task produces a complete GroupSnapshot directly, and
lag calculation is decomposed into a per-group method that can process
groups independently.

Memory profile changes from O(concurrent_groups × 25MB) to O(1) for the
AdminClient (~50-100MB regardless of group count), matching
kafka-lag-exporter's behavior.

This commit was based on work performed by an LLM.
```

#### Fase 4: Streaming refactor (Feb 19, senere samme dag) — HERO

cb6275f holdt, men ikke nok for det virkelig store clusteret. d99f656
gjør det om fra "materialize alt, så prosesser" til "stream per gruppe,
mest N in-flight".

```
b2477a7 2026-02-19    fix: double-free
bcbccae 2026-02-19    fix: move spammy output from debug to trace

d99f656 2026-02-19
refactor: streaming pipeline to eliminate memory exhaustion on large clusters

Monitoring clusters with 4-10k topics and 10k+ consumer groups caused
ever-growing memory and CPU usage, effectively DDOSing the exporter.
The root cause was that every collection cycle materialized all group
data in memory before processing any of it — holding thousands of
snapshots, watermarks, and metric points simultaneously.

This refactor ensures data is processed and freed per-group rather than
collected-all-then-iterated.
A group's offsets, lag calculations, timestamps, and metric points are
computed inline and pushed to the registry before moving to the next
group.
At most N groups (configurable via max_concurrent_groups) are in-flight
at any time.

The Kafka broker was also being overwhelmed by a single
describe_consumer_groups RPC containing 10k+ group IDs.
Chunking into configurable batches (default 500) prevents broker-side
memory spikes and timeouts.

Compacted topic detection (describe_configs for all topics) ran every
cycle despite the result rarely changing. A TTL-based cache (default 5m)
eliminates redundant calls.

Watermarks were fetched for every partition discovered via cluster
metadata — typically 100k+ partitions — even though only a subset had
active consumers.
Targeted watermark fetching queries only the partitions that consumer
groups are actually assigned to, avoiding the expensive metadata call
entirely.

This commit was worked on by an LLM.
```

#### Fase 5: Perf-dagen (Feb 20) — HEROES + tuning

Syv commits på én dag, inkl. den 12-punkts-store 107b997 og den
forferdelige silent-data-loss-buggen 4e2d9e3.

```
107b997 2026-02-20
fix: resolve large-cluster performance bugs and harden metrics pipeline
  [12-punkts forklaring, se /tmp/klag-commits.txt:381-494 for full body]
  Høydepunkter:
  1. Pre-fetch all group offsets before streaming (semaphore+spawn, ikke
     buffer_unordered, fordi list_consumer_group_offsets-futures ikke er
     Send for vilkårlige lifetimes)
  2. Derive watermark partitions from committed offsets, not member
     assignments ("orphaned" partitions etter rebalance ble silent skipped)
  3. Skip partitions with missing watermarks instead of defaulting lag=0
     (masket ekte problemer bak falske nuller)
  4. Remove aggregate metrics, replace with granularity-controlled
     pre-aggregation (sum/max/min/OR pr. Granularity::Topic)
  5. Batch describe_configs in chunks of 500
  6. Zero-clone Prometheus rendering (DashMap Ref guards istf. clone)
  7. OTel staleness filtering (matche Prometheus-path)
  8. Auto-adjust collection_timeout to exceed kafka_timeout
  9. Evict stale timestamp cache entries on data loss
  10. Config validation hardening (zero-value for kafka_timeout,
      compacted_topics_cache_ttl)
  11. Rust edition 2024 migration (temp-env crate i tests, let-chain
      syntax, unsafe set_var)
  12. Helm chart cleanup (fjern max_concurrent_watermarks-knob)
  Tester: 57 passing, 0 clippy warnings
  Co-Authored-By: @sindrerh2

4e2d9e3 2026-02-20
fix: add Consumer::fetch_watermarks fallback for unresolved list_offsets results

The kafka_consumergroup_group_lag metric was persistently reporting 0
despite real consumer lag existing, because watermark offsets were being
silently dropped during parsing of Admin API responses.

## Why this change was necessary

### The silent data loss bug
fetch_watermarks_for_partitions uses admin.list_offsets() to bulk-fetch
earliest and latest offsets. The forked rdkafka parses each result via
Offset::from_raw(raw_offset), which maps the raw integer back to an
Offset enum variant:
  - Raw -1 → Offset::End
  - Raw -2 → Offset::Beginning
  - Raw n >= 0 → Offset::Offset(n)

When list_offsets successfully resolves the offset, raw_offset is
non-negative and from_raw correctly produces Offset::Offset(n).
However, if the broker echoes back an unresolved sentinel (e.g. -1 for
a partition it couldn't resolve without setting a per-partition error),
from_raw(-1) produces Offset::End — NOT Offset::Offset(-1).

Our code matched only the happy path:
  if let rdkafka::Offset::Offset(high) = info.offset {
      // use high watermark
  }
  // else: silently dropped — no log, no fallback

Every partition whose offset resolved to a non-Offset variant was
silently excluded from the watermarks map. Downstream in calculate_group,
missing watermarks triggered the "Missing watermark for committed
partition" skip path → NO lag metrics. On Prometheus this appeared as
kafka_consumergroup_group_lag being 0 (absent, not explicit zero).

### Why a fallback instead of just fixing the match
Sentinel values like Offset::End (-1) and Offset::Beginning (-2) are not
valid watermark offsets — they indicate the request was not resolved.
Fall back to Consumer::fetch_watermarks() which returns (i64, i64)
directly, same API the BaseConsumer-based impl used before Admin-API
migration.

### Why the function was split into helpers
clippy pedantic 100-line limit. Decomposed into collect_resolved_offsets
(logs warn! with actual Offset variant for unresolved), build_watermarks,
fallback_missing_watermarks (uses tokio::task::block_in_place).

### Why block_in_place for the fallback
Consumer::fetch_watermarks is sync blocking (wraps
rd_kafka_query_watermark_offsets). block_in_place signals tokio that the
thread is about to block without requiring Arc<Self> restructuring.
Fallback only triggers when list_offsets fails → blocking cost
acceptable.

### Diagnostic logging for list_consumer_group_offsets
Added trace! for partitions where elem.offset() doesn't match
Offset::Offset(n>=0). Same root-cause potential for committed offsets.

This commit is based on work done by an LLM.

3520aa8 2026-02-20    fix(helm): remove dead/useless configuration knob; less insane defaults
b14e5a0 2026-02-20    upkeep: add some more timing data
bbe4fe0 2026-02-20    fix: batch chunks in parallel to avoid sequential I/O delay
5d3c0ed 2026-02-20    test: replace several tests w/property-based tests

5760504 2026-02-20
perf: add negative caching and cross-group dedup for timestamp fetches

Production logs showed stream_metrics_ms=6047 (93% of cycle time) with
timestamp_sampling enabled. Two root causes:

1. 255 cache misses each waited the full 5s fetch_timeout despite Kafka
   returning no message (offset at or beyond high watermark). These None
   results were not cached, so the same futile fetch repeated every cycle.

2. Only 82 unique (topic, partition, offset) tuples existed among the 255
   fetches — the remaining 173 were duplicate Kafka polls caused by
   multiple consumer groups consuming the same partition at the same
   committed offset. E.g., pdl.aktor-v2:0@13168591 was fetched 24 times.

Additionally, two expect() calls in consumer.rs were replaced with
non-panicking alternatives to improve robustness in the spawn_blocking
hot path.

## Changes

### 1. Negative caching in timestamp sampler
CachedTimestamp.timestamp_ms: i64 → Option<i64>. When fetch_timestamp
returns None, now cached with timestamp_ms: None. Subsequent calls return
immediately from cache.

### 2. Cross-group offset dedup cache
Second cache layer keyed by (TopicPartition, i64) instead of
(String, TopicPartition). Group A fetches topic-X:0@42 → stored in both
per-group cache and offset_cache. Group B requests same → hits dedup
cache without touching Kafka. Promoted into per-group cache on hit.
Both share cache_ttl.

Expected impact: 255 Kafka fetches → 82 per cycle (68% reduction).

### 3. Remove expect() from hot path
- fetch_timestamp: let-else instead of expect() — structurally
  unreachable but eliminates panic surface in spawn_blocking
- with_pool_size: .unwrap_or_else(PoisonError::into_inner) consistent
  with acquire/release poison-recovery

### 4. Property test for negative cache

This commit is based on work fram an LLM.

fd41a14 2026-02-20    upkeep: tune logging, make it JSON for monitoring
318d46d 2026-02-20    fix: reduce excessive cache-eviction
```

#### Fase 6: librdkafka FFI-helvete (Feb 23-25) — Bolk 2-material

Dette er "selv når stacken ikke er Rust hele veien ned, gir verktøy-
kjeden deg en fightende sjanse". FFI-double-free, blocking FFI som
kveler tokio, SIGSEGV fra C-tråder som ikke kan fanges fra Rust,
og til slutt en fix som *begrenser concurrency mot C-lagene*.

```
d68bb0c 2026-02-23
fix: avoid librdkafka double-free upon program shutdown
  (Co-Authored-By: @sindrerh2. LLM-basert.)

d03f788 2026-02-23
fix: reduce memory growth from pool consumers, allocator fragmentation,
     and Vec reallocation

- Set topic.metadata.refresh.interval.ms to -1 on the 50 pooled
  BaseConsumer instances in TimestampConsumer, disabling periodic
  metadata refresh. These consumers only need metadata for the single
  partition they're assign()'d to — default 300s refresh caused each
  consumer to independently accumulate and refresh metadata for every
  topic it had ever seen.

- Add jemalloc as global allocator via tikv-jemallocator with
  unprefixed_malloc_on_supported_platforms. The per-cycle pattern of
  allocating ~15,000 MetricPoint objects (each String + HashMap) then
  dropping them all causes glibc malloc to fragment and retain freed
  pages. jemalloc handles this pattern significantly better and returns
  memory to OS. The Nix flake uses JEMALLOC_OVERRIDE pointing to
  pkgs.jemalloc's pre-built libjemalloc.a to bypass a GCC 15
  incompatibility in tikv-jemalloc-sys's bundled jemalloc 5.3.0
  configure script (cannot determine return type of strerror_r).

- Change MetricsRegistry::begin_cycle() to use
  Vec::with_capacity(previous_cycle_len) instead of Vec::new(),
  pre-allocating based on previous cycle's point count. Eliminates
  repeated geometric reallocations during push_points() calls within
  a cycle, reducing transient heap pressure.

  ↑↑↑ DETTE ER NIX-POENGET I BOLK 2 ↑↑↑
  JEMALLOC_OVERRIDE-hacket fungerer fordi Nix leverer pkgs.jemalloc's
  libjemalloc.a reproduserbart. Samme hack i en Dockerfile = kaos.

  Co-Authored-By: @sindrerh2. LLM-basert.

e09a57d 2026-02-24
fix: prevent readiness probe timeouts caused by blocking FFI on async runtime

list_consumer_groups() and fetch_metadata() call synchronous librdkafka
C functions (fetch_group_list, fetch_metadata) that block the calling
thread for up to several seconds. Because these were called directly on
the tokio async runtime without block_in_place, they monopolized a
worker thread, preventing the HTTP server from serving /ready within the
Kubernetes readiness probe's 3-second timeoutSeconds.
On resource-constrained pods with few CPU cores (and thus few tokio
worker threads), this caused 3+ consecutive probe failures, marking the
pod as not-ready 15–20 minutes into execution — despite collection
cycles completing successfully.

Wrapping both calls in tokio::task::block_in_place signals to the tokio
runtime that the current thread is about to block, allowing it to move
other async tasks (including the HTTP readiness handler) to available
worker threads.

This commit is based on work by an LLM.

406cf2c 2026-02-24    fix: test dep update for removing double-free sigsev

85df581 2026-02-24
feat: install SIGSEGV signal handler for crash-site backtraces

Runtime SIGSEGV crashes produce exit code 139 with no indication of
where the fault occurred. Without backtrace the only option is to bisect
code paths by disabling features — slow and lossy in a production-only
reproduction environment.

This registers a SIGSEGV handler via libc::signal at process start that
emits a JSON-formatted crash line (compatible with tracing-subscriber's
JSON layer) followed by a native backtrace via libc::backtrace/
libc::backtrace_symbols_fd, then re-raises the signal so exit code stays
139.

Handler deliberately avoids tracing macros and all Rust standard I/O —
tracing-subscriber holds a Stderr mutex during writes, and
tracing::error! allocates on the heap. Either would deadlock or trigger
UB inside a signal handler. Raw libc::write(fd=2) is async-signal-safe.

This commit is based on work by an LLM.

af00152 2026-02-24    ← senere samme dag
Revert "feat: install SIGSEGV signal handler for crash-site backtraces"

The signals are blocked in the C-level librdkafka library, rev
https://github.com/confluentinc/librdkafka/issues/4571
This reverts commit 85df5819d56a9a0c71e7771797420671242f5222.

  ↑↑↑ GULL FOR BOLK 2 ↑↑↑
  "Jeg tør å installere en signal handler og revert-e den når det ikke
  virker — fordi verktøyene mine forteller meg at det ikke virker."

a30f0d9 2026-02-24
fix: bound concurrent describe_consumer_groups batches to prevent SIGSEGV

The process crashes with SIGSEGV (exit 139) during
describe_consumer_groups on a cluster with 13,400+ consumer groups.
The crash occurs on librdkafka's internal broker threads, which mask all
signals via sigfillset — making it impossible to catch with a Rust
signal handler.

The previous implementation fired all 27 batches of 500 groups
concurrently through a single AdminClient via try_join_all. This
overwhelms librdkafka's internal C state management and triggers memory
corruption on its broker threads.

Reduce default describe_groups_batch_size from 500 to 100 and limit
concurrent try_join_all rounds to 5 batches at a time with a 10ms pause
between rounds, giving librdkafka's broker threads time to drain their
internal queues.

This commit is based on work by an LLM.

0791d3e 2026-02-25
fix: reduce timeout-thundering-herd load

So as to avoid librdkafka (C lib) sigsegv (139 return code) when doing
group describes.

This commit is based on work done by an LLM.
```

### Fallgruve-/mønster-analyse for R3 ("fingerspissfølelse")

1. **Yak-shaving dominerer** (Feb 16-18): 30+ helm/CI/fasit-commits
   før den første tekniske kjerne-fiksen landet. Ikke blameverdig —
   bare realistisk. Publikum skal kjenne seg igjen.
2. **Klippet Feb 18→19**: clippy + logging +
   "ready-state" + "debug: logs to differentiate when code hangs".
   Klassisk "jeg forstår ikke, la meg se mer". Gode tilbakekoblinger
   = kommer seg ut av dette raskere.
3. **Hero-par-dagen Feb 19**: cb6275f og d99f656 er
   *to forskjellige fikser* til overlappende symptomer. Den første
   fjerner per-group-allokering, den andre slutter å materialisere
   alt i minnet. Uten tilbakekobling fra kompilator + tester hadde
   dette tatt uker, ikke én dag.
4. **Perf-dagen Feb 20** (7 commits): "Nå som det funker, raskere."
   4e2d9e3 er kronjuvelen — silent data loss buggen der `Offset::from_raw(-1)`
   → `Offset::End` istf. `Offset::Offset(-1)` maskerte `lag=0`.
   Kompilatoren fanget ikke dette (enum-matching var *syntaktisk* riktig),
   men et *test-run mot ekte cluster* + logging gjorde det.
5. **FFI-helvete-uken Feb 23-24**: double-free → blocking FFI →
   SIGSEGV-handler installert og revert-et **1 t 50 min senere** →
   til slutt fikset ved å *begrense concurrency mot C-lagene*.
   Demonstrerer at verktøy-tilbakekobling virker selv når stacken
   ikke er Rust helt ned.
6. **af00152-revert som fortellerteknikk**: Samme dag som
   feil-installeringen. Det korte vinduet er i seg selv poenget —
   "jeg turte å prøve fordi jeg kunne revert-e raskt".

### Hero-commits per bolk (forslag, venter på brukers avgjørelse)

| Bolk | Commit | Hvorfor |
|---|---|---|
| Motivasjon | teaser-tallene i seksjon over | — |
| Bolk 1 (Rust) | `cb6275f` | 220 linjer unsafe fjernet, O(N)→O(1) |
| Bolk 1 (Rust) | `4e2d9e3` | Offset::from_raw sentinel-bug — viser *grensen* for hva kompilatoren fanger; testing + logging fanget |
| Bolk 1 (Rust) | `d99f656` eller `107b997` | Streaming + 12-punkts large-cluster hardening |
| Bolk 2 (Nix) | `d03f788` | `JEMALLOC_OVERRIDE` mot `pkgs.jemalloc` — Nix-poenget med én linje |
| Bolk 2 (Nix) | `af00152` revert | Turte-å-prøve demonstrasjon |
| Bolk 3 (fryktløshet) | hele Feb 23-24-sekvensen | Én uke, FFI-helvete, ingen backup, likevel framover |

