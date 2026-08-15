# Report structure

Adapt section depth to the product, but keep the order — it is the order a
reviewer reads in, and it front-loads the answer.

---

## Header

Open with what the document is and, more importantly, what it is not. If this
simulates a third party's review rather than being one, say so unmissably
here and again at the end.

```markdown
# <Product> — Due Diligence Review

**What this is.** <One paragraph: purpose, who wrote it, what was assessed,
version and date.>

**What this is not.** <Explicitly: not an audit, not a penetration test, not
a legal opinion. If simulating an institution's review, state that no one at
that institution has seen the product and this is not their position.>

**Why bother.** <One or two sentences on what the reader gains.>
```

## 1. Overall assessment

A rating per deployment context, because "not production-ready" is unhelpful
about something that does not claim to be:

```markdown
**Rating for production use in a regulated environment: RED / AMBER / GREEN**
**Rating for <the actually proposed use>: RED / AMBER / GREEN**
```

Then the blockers — the two to four items that would stop a real review before
technical assessment began. Name them, number them, and say plainly that they
are cheap now and expensive later if that is true.

Keep this section short enough to be read standing up. It is the only part
some readers will read.

## 2. Scope and method

A table: product and version, deployment reviewed, method, what was not
covered, reviewer position. The "not covered" row is the one that protects
the review's credibility — be generous with it.

## 3. What is genuinely good

Before any findings. Specific, evidenced positives — not faint praise. If the
architecture makes a correct fundamental choice, say which and why it matters.

This is not diplomacy. A review with no positives reads as hostile, gets
discounted, and the vendor defends rather than fixes. And where the
foundations are right, that is genuine information: foundations are expensive
to retrofit, polish is cheap.

## 4. Findings

Grouped by domain, each domain a table:

```markdown
### <Domain name>

| ID | Sev | Finding | What "good" looks like |
|---|---|---|---|
| SEC-01 | Critical | <Specific defect with evidence — file:line, command output, observed behaviour> | <The sufficient remediation> |
```

Where several findings share a root cause or a theme, add a short prose note
after the table. The commercial-claims domain in particular usually needs one,
because the pattern across findings is the finding.

## 5. What would need to be true

Remediation staged by when it must land. This converts a list into a plan and
shows what is cheap now:

```markdown
**Before <wider distribution / a larger cohort>** (days)
1. ...

**Before <an institutional pilot>** (weeks)
5. ...

**Before production** (the roadmap)
11. ...
```

Number continuously across stages so items can be referred to individually.

## 6. Summary

Three or four paragraphs. What is sound, what is missing, and the single
highest-value change. Where the highest-value change is not technical, say so
— it usually is not.

Avoid restating the findings. This section is for the judgement that the
findings support.

## Footer

Repeat the standing disclaimer, dated, with the exact version reviewed.

```markdown
*Prepared by <who> during <context>, <date>. Shared with <vendor> as
constructive feedback. Not an <institution> assessment, not a formal audit,
and not a legal opinion. Findings are based on <version> and may be
superseded by later builds.*
```

---

## Revision reviews

When regenerating against a newer version, keep the structure and add a
section immediately after the overall assessment:

```markdown
## Changes since <previous version>, <date>

**Resolved** — SEC-02, LEG-01, SUP-03
**Still open** — SEC-01, DAT-01, DAT-02
**New** — RES-06
```

Keep finding IDs stable. A resolved finding stays in its table, marked
`(resolved, v0.2.0)`, rather than disappearing and renumbering everything
below it. The delta is the story in a revision review, and stable IDs are what
make it legible.
