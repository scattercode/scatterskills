# Review domains

Seven domains. Work through each, marking any that genuinely do not apply
rather than padding. The prefix in brackets is the finding ID prefix.

## 1. Information security (SEC)

The questions a security reviewer asks first, roughly in the order they ask
them.

- **Authentication and authorisation.** Is there any? A local-only API is
  still an API — any process or user on the host can reach it. What does an
  unauthenticated caller get?
- **Network exposure.** What binds where, by default? Check published ports
  and listener addresses, not the documentation's claim about them. A default
  of all-interfaces on a laptop means "exposed on every café and hotel network
  the developer visits".
- **Encryption.** At rest and in transit. What is the *default*, not what is
  possible. If encryption requires generating a key first, it is off for
  almost everyone.
- **Secrets handling.** Where do credentials live? Are they logged? Does the
  product read files likely to contain them?
- **Privilege.** What user does the process run as? What can it write? A
  container running as root is a finding; one that drops privileges properly
  is worth crediting.
- **Blast radius.** If this host is compromised, what does the attacker get
  that they would not otherwise have? For developer tooling the answer often
  includes source code, credentials and client data.

## 2. Data governance (DAT)

Frequently where the real findings are, and frequently under-examined because
it is less exciting than security.

- **What is captured.** Precisely. Prompts? Responses? File contents? File
  paths? Metadata? Get this from the source, not the README.
- **Scoping controls.** Can the user limit what is captured or indexed? Do
  the controls work the way their names imply? A feature called "workspaces"
  with add and remove verbs will be assumed to scope things; verify that it
  does.
- **Exclusion mechanisms.** Is `.gitignore` honoured? `.dockerignore`? Any
  explicit exclude list? Users assume ignore files are respected because that
  is the convention everywhere else.
- **Retention and deletion.** Is there a retention policy? A limit? Can a user
  delete specific items, and prove it? Cryptographic deletion is a strong
  positive when present.
- **Personal data.** Prompts routinely contain names, addresses, credentials
  and client information. Is there a data-handling note? A DPIA? A stated
  controller/processor position? For local-only tools the answer may be
  simple, but it needs stating.
- **Classification fit.** Which of the institution's data classifications may
  this touch? Most have four or five tiers and clear rules about what may
  leave a controlled system.

## 3. Software supply chain (SUP)

Post-SolarWinds, this domain has moved from advisory to gating at most large
institutions.

- **SBOM.** Is there a component inventory — CycloneDX or SPDX? Increasingly
  a hard requirement for onboarding.
- **Provenance and signing.** Are releases signed? Is there build attestation?
  Can a buyer verify that the artefact came from the vendor's pipeline?
- **Dependency surface.** How many direct and transitive dependencies? Is
  there automated vulnerability scanning, and a published cadence?
- **Installation path.** How does it get onto the machine? A `curl | bash`
  installer that mutates global configuration is a finding, regardless of the
  quality of what it installs. What exactly does it touch outside its own
  directory?
- **Update mechanism.** How are updates delivered and verified? Can the vendor
  push code to the endpoint?
- **What CI actually gates.** Read the workflow files rather than the badges.
  Components excluded from lint, type-checking or tests are where defects
  accumulate — and installers are excluded surprisingly often, despite being
  the only component that mutates host state.

## 4. Legal and contractual (LEG)

Cheap to check, and capable of stopping everything.

- **Completeness.** Are there unfilled placeholders? An unset liability cap or
  blank jurisdiction stops legal review immediately.
- **Acceptance mechanism.** How does a user accept the terms? Is acceptance
  recorded? Is the version they accepted recorded? "By accessing this you
  agree" with no click-through and no versioning is weak.
- **Availability of the terms.** Can the people bound by the agreement
  actually read it? Rights-managed documents requiring membership of the
  vendor's identity tenant are not readable by the counterparty.
- **Liability and warranty.** Caps, exclusions, "as is" disclaimers. Normal in
  previews; must change before production.
- **IP and feedback licences.** What rights does the vendor take over
  contributions and feedback? Institutions want carve-outs for their own
  confidential material.
- **Usage scope.** Are there restrictions on what the software may be used
  with? Check whether such restrictions appear in the repository and the terms,
  or only in a covering email — those onboarded by another route will never
  see them.
- **Data ownership.** Who owns what the product produces and captures?

## 5. Operational resilience and vendor viability (RES)

Where regulated institutions differ most from ordinary buyers.

- **SLA and support.** What is committed? What are the response targets?
- **Incident response.** Is there a process? Notification obligations?
- **Exit and portability.** Can data be extracted in a usable format? Is there
  an exit plan? DORA expects this contractually for EU financial entities.
- **Vendor viability.** How long has the vendor existed? Funding? Key-person
  risk? A new company with a small team is a genuine concentration risk in a
  critical workflow — say so neutrally, it is a standard consideration.
- **Certifications.** ISO 27001, SOC 2, or a completed CAIQ/SIG questionnaire.
  Their absence is not disqualifying for a preview but will be asked about.
- **Diagnosability.** When it fails, is there anything to attach to a support
  ticket? Products that fail silently cannot be supported at scale.
- **Endpoint footprint.** Memory, disk and CPU against the institution's
  standard build. A tool needing more RAM than the standard specification is
  not deployable however good it is — and the workaround may undermine the
  product's premise.

## 6. AI governance and model risk (AIG)

Applies when the product uses, serves or conditions a model. Skip it entirely
otherwise.

- **Auditability.** Can you reconstruct why the system produced a given
  output? Regulated institutions must answer this after the fact, sometimes
  years later. Are derivation records retained and exportable?
- **Human oversight.** Is there review, approval or an opt-out before model
  behaviour is altered?
- **Model documentation.** Model cards, intended and prohibited uses, known
  failure modes for any bundled model.
- **Data flows to models.** Which models see what? A "local" product with a
  remote-API fallback tier changes the data-residency answer completely.
- **Regulatory classification.** EU AI Act risk tier; the institution must
  classify it and will want the vendor's view.
- **Evaluation rigour.** Are performance claims backed by a stated method?
  Pre-registered protocols and published harnesses are a strong positive.

## 7. Commercial claims (CLM)

Often the highest-value domain, and the one absent from standard checklists.

Compare what the vendor *says* against what the vendor's own artefacts show.
Sources to cross-check: marketing copy and sales emails, README claims,
benchmark tables and their methodology notes, research documents, changelogs.

- Does the headline metric match the table it comes from?
- Is the quoted metric the primary one, or a secondary one that reads better?
- Are competitor figures quoted at their best or their worst?
- Does the research section of a document contradict its own opening?
- Is "proven" doing work that the evidence does not support?

When the technical artefacts are candid and the commercial material is not,
say precisely that. It is the most actionable thing a friendly reviewer can
tell a vendor, because the fix is free and the cost of a buyer finding it
first is severe.
