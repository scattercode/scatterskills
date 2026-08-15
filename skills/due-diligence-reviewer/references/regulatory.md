# Regulatory context

What various regimes actually require, phrased as the questions a reviewer
will ask. Consult the sections relevant to the institution's sector and
jurisdiction — do not recite all of it.

This is orientation for framing findings, not legal advice. Where a finding
turns on a legal question, say that it needs the institution's legal or
compliance function rather than asserting a conclusion.

## Financial services

### DORA (EU, applies from January 2025)

The Digital Operational Resilience Act governs ICT risk for EU financial
entities and reaches their third-party providers. It is the sharpest current
driver of vendor requirements.

Reviewer questions:

- Are there contractual provisions on service levels, incident reporting,
  exit strategies and audit rights?
- Can the institution exit and take its data in a usable form?
- Is there an incident-notification obligation, and on what timeline?
- Does the vendor support the institution's own resilience testing?
- Where is the arrangement recorded in the register of information?

For a product with no SLA, no incident process and no documented exit path,
these are High findings — not because the vendor is careless, but because the
institution cannot contract for it without them.

### UK operational resilience (SS1/21, SYSC 8)

Comparable expectations for UK entities: important business services,
impact tolerances, and outsourcing/third-party arrangements. If the software
supports an important business service, expect scrutiny of concentration risk
and substitutability.

### Critical third parties

Both regimes are increasingly concerned with concentration. A new vendor is
unlikely to be designated critical, but "what happens if this company ceases
to exist" is a standard question and deserves a neutral answer rather than a
defensive one.

## Data protection

### UK and EU GDPR

Relevant whenever the product processes personal data — and prompts, logs and
documents routinely contain it, even when the product is not "about" personal
data.

Reviewer questions:

- What personal data is processed, and on what basis?
- Controller or processor? For local-only tools this is often "the
  institution remains controller and no processing by the vendor occurs" —
  but it needs stating, not assuming.
- Is a DPIA required? Likely yes where the tool systematically monitors
  employee activity.
- International transfers? A local product with a remote-API fallback changes
  this answer.
- Retention, deletion, and data-subject rights — can a specific individual's
  data be found and removed?

Employee monitoring deserves specific attention. A tool capturing every prompt
a developer writes is, in employment-law terms, monitoring — regardless of
intent — and many jurisdictions require consultation.

## AI-specific

### EU AI Act

Phasing in from 2025. Most developer-productivity tooling lands in the
limited-risk or minimal-risk tiers, but the institution must classify it and
will want the vendor's stated position. Transparency obligations apply where
users interact with an AI system.

### Model risk management (SR 11-7 and equivalents)

Where model output influences decisions, expect model documentation,
validation evidence and ongoing monitoring. A coding assistant is usually out
of scope; anything touching pricing, risk or credit is not.

The practical question is auditability: can the institution reconstruct why a
model produced a given output, months later, with retained evidence?

## Certifications and questionnaires

What a reviewer expects to see, in rough order of how often it is asked for:

| Artefact | What it signals |
|---|---|
| **Completed CAIQ or SIG Lite** | The cheapest credible starting point for a young vendor; a completed questionnaire answers most first-round questions |
| **SOC 2 Type II** | Operating effectiveness of controls over a period. The common expectation for SaaS |
| **ISO 27001** | Certified information security management system. Common in Europe |
| **Penetration test report** | Independent testing, ideally recent and with remediation evidence |
| **SBOM** | Component inventory. Increasingly a hard gate rather than a nice-to-have |

For an early-stage vendor, absence of SOC 2 and ISO 27001 is expected and not
itself a finding. Absence of *any* of these, including a completed
questionnaire, is a finding — it means the institution must generate the
evidence itself.

## Sector notes

**Energy and utilities.** NIS2 in the EU; national critical infrastructure
regimes elsewhere. Operational technology environments have far stricter
change control than corporate IT — assume nothing about ability to install.

**Healthcare.** Patient data attracts additional regimes (HIPAA in the US, and
national rules elsewhere). Any possibility of clinical data entering prompts
changes the assessment entirely.

**Government and defence.** Clearance, data classification and sovereignty
requirements dominate. Where data is processed and by whom often matters more
than any technical control.

## Framing findings against regulation

Cite the regime when it explains *why* a finding matters to this buyer, not to
demonstrate familiarity. "No documented exit path" is a finding on its own
merits; "no documented exit path, which DORA expects to be contractual for EU
financial entities" tells the vendor why their pipeline will stall.

Avoid asserting that something is non-compliant. Reviews inform a compliance
judgement made by people qualified to make it. The useful formulation is what
a reviewer will ask and what evidence would satisfy them.
