# deliverables/ — generated files, do not edit by hand

Everything in this folder is a **snapshot built from the markdown sources**
elsewhere in the repository. Editing a `.docx` here will be silently
overwritten on the next build, and editing a source `.md` will **not** update
these files.

## Rebuild after any source change

```bash
./tools/build-deliverables.sh          # macOS / Linux / WSL / Git Bash
```
```powershell
.\tools\build-deliverables.ps1         # Windows PowerShell
```

## Check whether the package has drifted

```bash
./tools/build-deliverables.sh --check
```
```powershell
.\tools\build-deliverables.ps1 -Check
```

This compares a SHA-256 of every source against `.build-manifest`, written at
the last build, and lists anything added, changed, or removed.

## Why this exists

In June 2026 this package was handed round while still containing a retracted
figure — the seagrass restoration extent, corrected in the markdown to
3,612 ha (Orth et al. 2020) but never regenerated here. The sources were right
and the distributed documents were wrong for several weeks. The `--check` flag
exists specifically to make that failure mode visible.

**Before sending this package to anyone, run `--check`.**

## Contents

| File | Built from |
|---|---|
| `ECOLOGICAL_EFFECTS_SYNTHESIS.docx` | `ECOLOGICAL_EFFECTS_SYNTHESIS.md` |
| `ECOLOGICAL_BIBLIOGRAPHY.docx` | `ECOLOGICAL_BIBLIOGRAPHY.md` |
| `ECOLOGICAL_RESEARCH_STRATEGY.docx` | `ECOLOGICAL_RESEARCH_STRATEGY.md` |
| `POSTER_CONTENT_AND_LAYOUT.docx` | `poster/POSTER_CONTENT_AND_LAYOUT.md` |
| `ESVA_Symposium_Poster.html` | copied from `poster/` |
| `article_eastern_shore_post_*.docx` | `outreach/` |
| `resident_resources_guide.docx` | `outreach/` |
| `pathway_1` … `pathway_6*.docx` | `research/` |
| `ESVA_Septic_Project_Deliverables.zip` | all of the above |

New `.md` files added to `outreach/` or `research/` are picked up
automatically. New top-level documents must be added to the `SOURCES` list in
both build scripts.
