---
name: due-diligence-reviewer
description: Produce a rigorous, evidence-based due diligence review of a software product from the perspective of a reviewer at a regulated institution — bank, fund, insurer, energy, healthcare or government. Use this whenever the user asks whether a tool, vendor or library "would pass" a security review, wants a vendor or third-party risk assessment, mentions TPRM, supplier assurance, vendor onboarding, DORA, SOC 2, ISO 27001, CAIQ or SIG, asks what a client's security team would object to, wants to assess a product before putting it in front of a regulated client, or is evaluating software as a design partner or pilot customer. Also use it proactively when the user is evaluating a third-party tool and the deployment context is a regulated or enterprise environment, even if they do not use the words "due diligence".
---

# Due diligence review

## What this is for

Regulated institutions do not adopt software because it is good. They adopt
it when a reviewer can defend the decision afterwards. That reviewer works
through a fixed set of domains, asks for evidence rather than assurances, and
records what they could not verify.

This skill reproduces that process. Two situations call for it:

- **Assessing inbound software** — should we let this near our estate, or our
  client's?
- **Friendly pre-review for a vendor** — here is what a real reviewer will
  raise, so you can fix it before they do.

The second is often the more valuable, and the tone differs: constructive,
specific, and honest about what is already good.

## The method in one line

**Read the source, run the thing, and cite what you find.** A review built
from marketing material and a questionnaire is worthless, and every reviewer
knows it. What makes a review land is that each finding points at a file and
line, a command output, or an observed behaviour.

## Working sequence

### 1. Establish scope and standing

Before any findings, pin down and write into the report:

- What was reviewed — product, version, commit hash, date
- What deployment was exercised — OS, topology, configuration
- What was **not** covered — penetration testing, dependency code audit, the
  vendor's internal controls, financial standing
- Who is speaking, and who is not

That last point protects everyone. If you are simulating a client's review
rather than conducting one, say so unmissably at the top and again at the end.
A document that reads like a bank's assessment, when no one at that bank has
seen it, can do real damage as it circulates.

### 2. Gather evidence before forming views

Read `references/evidence.md` for the specific commands and inspection
targets. In outline: read the licence and security policy; inspect CI for what
is actually gated; run the product and observe what it does to the host;
inspect the running processes, ports, mounts and stored data; check whether
published claims survive the vendor's own artefacts.

**Verify before asserting.** The single most damaging thing in a review is a
confidently stated finding that turns out to be wrong — it discredits
everything around it. If `docker exec` shows a root shell, check what user the
*application process* actually runs as before writing "runs as root". If a
config file looks ignored, prove it with the settings loader. Cheap checks,
enormous credibility difference.

### 3. Assess each domain

Work through the seven domains in `references/domains.md`. Not every domain
applies to every product — a library has no operational resilience story, a
local CLI tool has no multi-tenancy — so note domains as not applicable rather
than padding them.

The domains are: information security · data governance · software supply
chain · legal and contractual · operational resilience and vendor viability ·
AI governance and model risk · commercial claims.

Consult `references/regulatory.md` when the institution's jurisdiction or
sector matters — it maps common regimes (DORA, SS1/21, UK GDPR, EU AI Act) to
the questions a reviewer will actually ask.

### 4. Write the report

Follow the structure in `references/report-template.md`.

## What separates a good review from a checklist

**Lead with what is genuinely good.** A review that only lists faults reads as
hostile and gets discounted — the vendor becomes defensive and the real
findings land less well. There is nearly always something done properly, and
naming it precisely buys the credibility that the criticism then spends. If
you truly cannot find anything good, that is itself the headline finding.

**Rate for the actual use case, not in the abstract.** "This is not
production-ready" is unhelpful about a research preview that does not claim to
be. Give a rating per context: red for production in a regulated environment,
amber for a controlled pilot, and say which is being proposed. The gap between
the two ratings *is* the roadmap.

**Separate what blocks from what needs a plan.** Reviewers distinguish
findings that stop onboarding on day one from those needing a remediation
commitment. Conflating them makes everything look equally urgent and nothing
gets fixed. Three genuine blockers stated plainly land harder than thirty
findings of undifferentiated severity.

**Say what "good" looks like.** A finding without a remediation is a
complaint. For each one, state what would satisfy a reviewer — not the perfect
answer, the sufficient one.

**Stage the remediation.** Group fixes by when they must land: before wider
distribution, before a pilot, before production. This turns a list into a
plan, and shows which items are cheap now and expensive later.

**Check the pitch against the artefacts.** Frequently the strongest finding is
that a vendor's own documentation contradicts its marketing. Benchmark tables,
research notes and READMEs are often written by careful people, while the sales
material is not. When you find such a gap, say so — and be precise about which
side is honest, because that distinction is the useful information. It is also
the finding a vendor most wants before a buyer's reviewer discovers it, since
a claim disproved by a buyer converts a technical conversation into an
integrity one.

**Be fair about immaturity.** Early software has rough edges and everyone
knows it. What matters is whether the *foundations* are right — architecture,
data handling, deletion, privilege — because those are expensive to retrofit,
while polish is cheap. Distinguish "not built yet" from "built wrong". The
first is a schedule; the second is a rewrite.

## Severity

Use four levels, defined by consequence rather than feeling:

| Level | Meaning |
|---|---|
| **Critical** | Blocks onboarding. A reviewer stops here and the conversation does not continue until it is resolved |
| **High** | Requires remediation before any pilot with real data or real users |
| **Medium** | Requires a documented plan and a date; will not stop a pilot |
| **Low** | Advisory. Worth fixing, will not be argued about |

Reserve Critical. Its power comes from being rare, and a review with twelve
criticals is not read as twelve times more serious — it is read as
unserious.

## Finding format

Each finding carries an ID, so it can be tracked across revisions and quoted
in correspondence. Use a domain prefix: `SEC-01`, `DAT-03`, `SUP-02`,
`LEG-01`, `RES-04`, `AIG-02`, `CLM-01`.

Present findings as a table per domain:

| ID | Sev | Finding | What "good" looks like |
|---|---|---|---|
| SEC-01 | Critical | The specific defect, with evidence — file and line, command output, or observed behaviour | The sufficient remediation, not the ideal one |

Keep the finding column concrete. "Weak authentication" is not a finding.
"No authentication on the local API; any process on the host can read the
entire store via unauthenticated HTTP on `:8420`" is a finding.

## Designed for revision

These reviews are most useful as a series. A vendor fixes things; a new
version ships; the review is regenerated and the delta is the story.

To support that, keep finding IDs stable across revisions — a fixed finding
becomes `SEC-02 (resolved, v0.2.0)` rather than vanishing and renumbering
everything after it. Date every review and name the exact version reviewed.
When regenerating, lead with what changed since the last one: resolved,
still open, newly found.

## Common traps

- **Reviewing the roadmap instead of the product.** Vendors respond to
  findings with what is coming. Record it as a commitment with a date, and
  keep the finding open until it ships.
- **Accepting "it's local" as a security answer.** Local means the blast
  radius is the endpoint — which for a developer machine holds source code,
  credentials and client data. Ask what a compromise of *that* host yields.
- **Missing the aggregate.** Individually minor findings can combine: no
  authentication plus a permissive bind address plus plaintext storage is not
  three medium findings, it is one critical one.
- **Ignoring the human path.** How does the software arrive on the machine?
  A `curl | bash` installer that mutates global configuration is a supply
  chain finding regardless of how good the daemon is.
- **Treating an unfilled template as a typo.** Placeholders in binding
  documents — an unset liability cap, a blank jurisdiction — stop legal
  review dead. They are Critical, not Low, however trivial they look.

## Reference files

- `references/domains.md` — the seven domains and what to probe in each
- `references/evidence.md` — commands and inspection targets for gathering evidence
- `references/regulatory.md` — regimes, certifications, and what each implies
- `references/report-template.md` — the output structure
