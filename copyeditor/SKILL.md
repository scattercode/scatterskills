---
name: copyeditor
description: Copy-edit book manuscripts and long-form prose, producing a self-contained HTML annotation report with colour-coded issue cards (TYPO, PUNCT, STYLE, CONSISTENCY, QUERY). Use when the user asks to copy-edit, proofread or review a book, chapter, manuscript or extracted Markdown file, or asks for writing quality to be reviewed and errors flagged. Applies Hart's Rules for British English or the Chicago Manual of Style for US English, with a dedicated pass for OCR artefacts when the text came from scanned pages. Trigger on any request to copy-edit or proofread a document — including when the user simply loads the skill and gives a file path.
---

# Copy editor

Copy-edit a manuscript and produce an HTML annotation report.

The report **annotates rather than rewrites**. Every issue is raised with its
context, the rule behind it and a suggested correction, so that an editor or
author decides what to accept. That distinction matters most on the judgement
calls: an unusual phrasing may be a mistake or may be the writer's voice, and
only they can say.

## Scope

This skill copy-edits **Markdown**. It deliberately knows nothing about where
files live or how they are produced — those are properties of whatever project
the manuscript belongs to, and baking them in here would make the skill work
in one repository and nowhere else.

A project using this skill should tell you, in its own `CLAUDE.md` or
equivalent, where manuscripts live, how to produce Markdown from the source
format, where reviews are written, and how the target language variety is
recorded. If that guidance exists, follow it. If it does not, the defaults
below are sufficient.

`scripts/extract-vellum.py` ships with the skill for the common case of a
Vellum source file:

```
python3 scripts/extract-vellum.py <input.vellum> <output.md>
```

For OCR of scanned pages, use whatever pipeline the project provides. Cleaning
should at minimum rejoin hyphenated line breaks and reflow paragraphs before
review.

## Establishing the style baseline

Several rules invert between the two style guides, so applying the wrong one
produces confidently wrong corrections. Settle this before annotating
anything. Work down until something answers:

1. **The user says so.** Always wins.
2. **Project metadata.** Publishing projects commonly record the target
   variety per book — for example a `language` field in a metadata file beside
   the manuscript. `en-GB` → Hart's Rules; `en-US` → Chicago.
3. **The text itself.** Look at quotation marks, dash style, and
   `-our`/`-or` spellings. Where the text is internally consistent, follow it.
4. **Ask.** If the text is genuinely mixed, that inconsistency is itself a
   finding. Ask which variety is intended rather than guessing, and report the
   mixture.

Default to Hart's Rules only when nothing above resolves it.

## Workflow

A manuscript typically opens with YAML front matter (`title`, `author`)
followed by `##` chapter headings — take the title and author from there for
the report header.

1. **Read the whole manuscript before annotating.** Consistency issues are
   invisible chapter by chapter: you cannot flag a name spelled two ways until
   you have seen both.
2. Establish the style baseline.
3. If the text came from OCR, make the **OCR artefact pass** first — those
   errors need different detection strategies and will otherwise be missed.
4. Work chapter by chapter, identifying every issue.
5. Write the HTML review with the Write tool. Put it wherever the project
   expects review output; absent a convention, alongside the source as
   `<name>-review.html`. Name the detected style guide in the report header.

---

## OCR artefact pass

Only when the text came from scanned pages. Make this sweep before applying
the style rules. These errors need different detection strategies from normal
copy-editing, because they stem from how the recognition engine misread
letterforms rather than from any choice the author or translator made — which
also means they are not the writer's fault and should be corrected, not
queried.

### Fused words

Two words joined without a space, caused by OCR losing a word boundary: `ofMezre` (of Mezre), `onthe` (on the), `OldRomanRoad` (Old Roman Road). Look for a lowercase letter immediately followed by an uppercase letter mid-word, and for common short words (prepositions, articles, conjunctions) fused to the following word. Flag as **TYPO**.

### Dropped characters

OCR misses a character, producing a plausible-looking but wrong word: `bom` (born), `Westem` (Western). The letters `r`, `n`, and the combination `rn` are particularly prone to being dropped or merged. Read every word in context — a word that looks acceptable in isolation may be wrong. Flag as **TYPO**.

### `d` misread as `cl`

In many print typefaces, a lowercase `d` resembles `cl` to an OCR engine: `Saddler` → `Sadcller`, `middle` → `micldle`. Scan for any occurrence of `cl` adjacent to consonants where `d` would make more sense. Flag as **TYPO**.

### Spurious characters in proper nouns

OCR inserts wrong characters into names: `Tow:vanda` (colon inserted), `Ktikor` (missing `r`). Once you have seen each name in its correct form, any variant with an extra or wrong character is an OCR error. Flag as **TYPO**.

### Split proper nouns

When reflow joins lines with a space, a name that was split mid-word across a line break becomes two fragments: `Tour vanda` (Tourvanda), `Kri kor` (Krikor). Flag as **TYPO**.

### Digit spacing

OCR inserts a space mid-number: `189 3` (1893), `2 0th` (20th). Flag as **TYPO**.

### Name consistency

Note the correct form of every proper noun on first encounter. Flag any subsequent variant — whether OCR corruption or genuine inconsistency — as **CONSISTENCY** if it could be intentional, or **TYPO** if it is clearly OCR noise.

---

## Style rules — en-GB: Hart's Rules (British English)

### 1. Quotation marks

- **Primary quotations use single marks**: 'like this'
- **Quotations within quotations use double marks**: 'He said "I don't know" and left.'
- **Logical punctuation** (Oxford/Hart's rule): closing punctuation goes *inside* the quotation mark only if it belongs to the quoted matter.
  - Correct: She said, 'I am ready.' *(the full stop belongs to the quoted sentence)*
  - Correct: She described herself as 'ready'. *(the full stop belongs to the surrounding sentence)*
  - Correct: Did she say 'I am ready'? *(question mark belongs to the surrounding sentence)*
- Commas and full stops that follow a closing quote in narrative prose go **outside** the mark unless the punctuation is part of what is being quoted.
- Flag any use of double quotes as primary quotation marks — this is American style.
- Flag any inconsistency in quote style (mixing single and double as primaries).

### 2. Ellipsis

- Hart's uses **three unspaced dots** followed by a normal word space: `word... word`
- Or a single Unicode ellipsis character (…) is acceptable: `word… word`
- Do **not** use spaced dots (`. . .`) — this is an older typographic convention not recommended in the 2005 edition.
- When an ellipsis follows a complete sentence, a full stop precedes it: `word.... Next sentence` or `word…. Next sentence`
- Flag any inconsistency in ellipsis style throughout the book.

### 3. Dashes

- **Parenthetical asides**: use a **spaced en dash** — like this — not an em dash (em dash is American style).
  - Correct: `word – aside – word`
  - Incorrect: `word—aside—word` (em dash, no spaces)
- **Ranges**: use an **unspaced en dash**: `1939–45`, `pp. 10–15`, `Monday–Friday`
- **Compound adjectives where one element is already hyphenated** or is a proper noun: use en dash: `pre–First World War`
- Flag any use of an em dash (—) — suggest replacing with spaced en dash ( – ).
- Flag any hyphen used where an en dash is needed for ranges.

### 4. Hyphens and compound words

- **Compound adjectives before a noun**: hyphenate — `well-known author`, `eighteenth-century novel`, `long-term plan`
- **Compound adjectives after a verb**: open — `the author is well known`, `a plan for the long term`
- **Numbers twenty-one to ninety-nine**: hyphenated
- **Prefixes**: generally closed — `prewar`, `postwar`, `midcentury` — unless a doubled vowel or consonant would cause confusion (`pre-eminent`, `co-operate` are acceptable variants)
- Flag inconsistent hyphenation of the same compound across the text.

### 5. Capitalisation

- **Sentence case for headings** — only the first word and proper nouns capitalised
- **Seasons**: lowercase — `spring`, `autumn`, `winter`, `summer`
- **Compass directions**: lowercase unless part of a place name — `go south`, but `the Middle East`
- **Job titles**: lowercase except when used as a direct form of address or immediately before a name — `the president spoke`, but `President Lincoln spoke`
- **Historical periods and events**: capitalised when used as proper names — `the First World War`, `the Reformation`, `the Renaissance`
- Flag inconsistent capitalisation of the same word or phrase.

### 6. Numbers and dates

- **Spell out** one to ninety-nine in running prose; use numerals for 100 and above
- **Spell out** round numbers in prose: `two hundred`, `five thousand`
- **Exceptions** (use numerals): measurements, percentages, dates, page references, scores
- **Dates**: `15 March 2024` (day–month–year, no ordinals) or `March 2024`; not `March 15th, 2024`
- **Centuries**: lowercase and spelled out — `the nineteenth century` (noun), `a nineteenth-century novel` (compound adjective)

### 7. Spelling (British English, Oxford style)

Oxford house style (used in Hart's Rules) employs **-ize** endings, not -ise, for the main verb class — this surprises many writers but is correct for this style:

| Use | Avoid |
|---|---|
| realize, organize, recognize | realise, organise, recognise |
| But: advertise, comprise, disguise, exercise, supervise, surprise | These **always** take -ise — they are not from the Greek -izo suffix |

Other British spellings to enforce:

| Use | Avoid |
|---|---|
| colour, honour, favour, neighbour | color, honor, favor, neighbor |
| centre, theatre, metre | center, theater, meter |
| travelling, fulfilling, labelling | traveling, fulfilling, labeling |
| catalogue, dialogue, analogue | catalog, dialog, analog |
| programme (but: computer program) | program (non-computing) |
| judgement (general use) | judgment (legal contexts only) |
| ageing, likeable | aging, likable |

### 8. Oxford comma

Use the **Oxford comma** (serial comma) before the final item in a list of three or more: `red, white, and blue` — not `red, white and blue`.

### 9. Punctuation spacing

- **One space** after a full stop, not two.
- No space before a colon, semicolon, full stop, comma, or closing bracket.
- Brackets close without a space: `(like this)`, not `( like this )`.

---

## Style rules — en-US: Chicago Manual of Style (US English)

Apply these rules instead of Hart's Rules when the style baseline resolves to US English.

### 1. Quotation marks

- **Primary quotations use double marks**: "like this"
- **Quotations within quotations use single marks**: "He said 'I don't know' and left."
- **American punctuation convention**: closing commas and full stops always go *inside* the closing quotation mark, regardless of whether they belong to the quoted matter.
  - Correct: She said, "I am ready." *(full stop inside)*
  - Correct: She described herself as "ready." *(full stop inside — differs from Hart's)*
- Flag any use of single quotes as primary quotation marks — this is British style.
- Flag any inconsistency in quote style.

### 2. Ellipsis

- Three unspaced dots followed by a word space: `word... word`
- Or a single Unicode ellipsis character (…) is acceptable.
- When an ellipsis ends a complete sentence, a full stop precedes it: `word.... Next sentence`
- Flag any inconsistency in ellipsis style throughout the book.

### 3. Dashes

- **Parenthetical asides**: use an **unspaced em dash**—like this—not a spaced en dash.
  - Correct: `word—aside—word`
  - Incorrect: `word – aside – word` (spaced en dash, British style)
- **Ranges**: use an **unspaced en dash**: `1939–45`, `pp. 10–15`, `Monday–Friday`
- Flag any spaced en dashes used for parenthetical asides — suggest replacing with unspaced em dash.
- Flag any hyphen used where an en dash is needed for ranges.

### 4. Hyphens and compound words

Same rules as the en-GB section above.

### 5. Capitalisation

Same rules as the en-GB section above.

### 6. Numbers and dates

- **Spell out** one through ninety-nine in running prose; use numerals for 100 and above.
- **Spell out** round numbers in prose: `two hundred`, `five thousand`.
- **Dates**: `March 15, 2024` (month–day–year, US format); not `15 March 2024`.
- **Centuries**: lowercase and spelled out — `the nineteenth century` (noun), `a nineteenth-century novel` (compound adjective).

### 7. Spelling (American English)

| Use | Avoid |
|---|---|
| color, honor, favor, neighbor | colour, honour, favour, neighbour |
| center, theater, meter | centre, theatre, metre |
| traveling, fulfilling, labeling | travelling, fulfilling, labelling |
| catalog, dialog, analog | catalogue, dialogue, analogue |
| program (all uses) | programme |
| judgment (all uses) | judgement |
| aging, likable | ageing, likeable |
| realize, organize, recognize | realise, organise, recognise |

Note: CMOS uses -ize endings (same as Oxford/Hart's) — this is not a point of difference between the two style guides.

### 8. Oxford comma

Same as the en-GB section — CMOS requires the Oxford comma.

### 9. Punctuation spacing

Same as the en-GB section.

---

## Issue Categories

| Code | Label | Colour | Use for |
|---|---|---|---|
| `typo` | TYPO | red | Spelling errors, wrong words, missing or doubled words |
| `punctuation` | PUNCT | orange | Quote marks, dashes, ellipsis, comma, semicolon errors |
| `style` | STYLE | yellow | Spelling variants, capitalisation, numbers, hyphenation (language-specific) |
| `consistency` | CONSISTENCY | blue | Same word/name formatted differently across the book |
| `query` | QUERY | purple | Ambiguous phrasing, possible translator's idiom — flag for author/editor decision, do not correct |

---

## Translated texts

Translations need a lighter hand, because much of what looks like error is
the translator's deliberate work — and a report that "corrects" a translator's
voice is worse than no report.

- Unusual or archaic phrasing is often a **deliberate choice** carrying
  something from the original. Do not correct it. Raise it as `QUERY` with a
  note such as *"Possible translator's idiom — confirm with editor."*
- **Transliterated names** — of people and places — frequently use
  unconventional spellings on purpose, and competing transliteration schemes
  both have defenders. Flag only clear inconsistency *within* the text, not
  divergence from whatever scheme you would have chosen.
- **Register shifts** within a chapter, from formal to colloquial, may track
  the original. Flag as `QUERY`, not `STYLE`.

The same restraint applies to any text with a strong authorial voice, not only
translations. When in doubt about whether something is an error or a choice,
`QUERY` is the honest category.

---

## HTML Output Format

Write a single self-contained HTML file. The template is in `assets/review-template.html` — use it as the structure and CSS exactly. Replace `BOOK_TITLE` and `AUTHOR` in the header, fill in the summary counts, and add one `<section class="chapter">` per chapter.

Replace the `STYLE_GUIDE` placeholder in the meta line with the detected style guide:
- `en-GB` → `Hart's Rules (British English)`
- `en-US` → `Chicago Manual of Style (US English)`

**Rules for the context snippet:**
- Include 6–10 words either side of the issue for searchability.
- Use `<mark>` around only the specific word(s) in question.
- Use `…` (the ellipsis character) to show truncation.
- Keep the snippet to one sentence where possible.

**Rules for the suggestion:**
- For TYPO: give the corrected spelling.
- For PUNCT: state the rule and give the corrected form.
- For STYLE: state the applicable rule (Hart's or CMOS) and give the corrected form.
- For CONSISTENCY: quote the other occurrence(s) and their location (chapter name).
- For QUERY: explain the ambiguity and ask a specific question for the editor.
