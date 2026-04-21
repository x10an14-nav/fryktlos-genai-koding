#!/usr/bin/env python3
"""Injiser speaker-notes fra en pdfpc-JSON som PDF text-annotations.

Leser JSON-strukturen som `typst query slides.typ '<pdfpc-file>'`
produserer (touying-format) og legger til /Text-annotations på hver
side som har `note`. pdfpc leser slike annotations som "native"
notater uten sidecar-fil.

Usage:
    inject-notes.py <input.pdf> <pdfpc.json> <output.pdf>
"""

import json
import sys

import pikepdf


def main() -> int:
    if len(sys.argv) != 4:
        print(__doc__, file=sys.stderr)
        return 2

    in_pdf, in_json, out_pdf = sys.argv[1:]

    with open(in_json, encoding="utf-8") as f:
        data = json.load(f)

    pages_data = data.get("pages", [])

    with pikepdf.open(in_pdf) as pdf:
        n_pages = len(pdf.pages)
        for entry in pages_data:
            # pdfpc-format: idx er 0-basert sidenr.
            idx = entry.get("idx")
            note = entry.get("note")
            if idx is None or note is None:
                continue
            if idx < 0 or idx >= n_pages:
                print(
                    f"warning: pdfpc idx {idx} utenfor range 0..{n_pages - 1}",
                    file=sys.stderr,
                )
                continue

            page = pdf.pages[idx]
            # Liten ikon i nedre venstre hjørne (1pt × 1pt) for å ikke
            # forstyrre layout visuelt — pdfpc bryr seg kun om /Contents.
            annot = pikepdf.Dictionary(
                Type=pikepdf.Name("/Annot"),
                Subtype=pikepdf.Name("/Text"),
                Rect=[0, 0, 1, 1],
                Contents=note,
                T="Speaker note",
                # Open=False slik at ikonet ikke åpner popup i vanlig PDF-
                # viewer. pdfpc leser /Contents direkte uansett.
                Open=False,
                # Flags: Hidden (2) + NoView (32) = 34, slik at vanlige
                # PDF-lesere ikke viser ikonet i det hele tatt. pdfpc
                # parser annotations uavhengig av flags.
                F=34,
            )
            annot_indirect = pdf.make_indirect(annot)

            if "/Annots" in page:
                page["/Annots"].append(annot_indirect)
            else:
                page["/Annots"] = pdf.make_indirect([annot_indirect])

        pdf.save(out_pdf)

    return 0


if __name__ == "__main__":
    sys.exit(main())
