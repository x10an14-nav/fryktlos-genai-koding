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
