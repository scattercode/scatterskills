# Gathering evidence

A review is only as good as what it can cite. This file lists the inspection
targets that reliably produce findings, roughly in the order worth doing them.

Adapt freely — these are the shapes of the questions, not a script. A Python
library, a SaaS API and a desktop daemon need different probes.

## Before running anything

Reading first is cheaper than running, and often produces the Critical
findings.

**The licence and terms.** Read the whole thing. Look for unfilled
placeholders (`[CAP]`, `TBD`, `e.g.`), the liability cap, warranty
disclaimers, IP and feedback grants, usage restrictions, governing law, and
how acceptance is established. Grep for `\[|TODO|TBD|XXX|e\.g\.` — template
placeholders in binding documents are Critical and take ten seconds to find.

**Security policy.** Is there a `SECURITY.md`? A private disclosure channel?
A stated scope? Presence is a positive worth crediting.

**Third-party notices.** Present? Complete?

**CI configuration.** Read the workflow files, not the badges. Establish what
is actually gated: which directories are linted, type-checked and tested.
Compare against the repository layout — components outside every gate are
where defects live. Installers and scripts are excluded remarkably often.

**Configuration examples.** Compare `.env.example` and similar against the
settings loader. Variables that the example ships but the application ignores
are a real finding, especially for security-relevant settings, because the
operator gets no error.

**Claims versus artefacts.** Collect every quantitative claim from marketing
material, then find its source in the repository — benchmark tables,
methodology notes, research documents. Check which metric is primary, how
competitors are quoted, and whether any section contradicts another.

## Installing and running

Watch what installation does to the host. This is itself evidence.

- What does the installer touch outside its own directory? Global config,
  shell profiles, `~/.local/bin`, system services, other applications'
  settings?
- Does it verify what it downloads?
- Does it require elevated privileges? For what?
- If it fails, what diagnostic trail remains? Try making it fail.

## Inspecting the running system

**Processes and privilege.** What user does the application actually run as?
For containers, `docker exec` runs as the image's `USER`, which may differ
from the process — check `docker top` or the process table inside. A container
that drops privileges via `setpriv`/`gosu` deserves credit; asserting "runs as
root" when it does not will discredit the whole review.

**Listeners.** `lsof -nP -iTCP -sTCP:LISTEN` and equivalent. Note the bind
address, not just the port. `*:8420` and `127.0.0.1:8420` are entirely
different findings.

**Mounts and filesystem access.** For containers, `docker inspect` the mounts:
source, destination, read-write or read-only. Compare against what the
configuration *says* — bind mounts are fixed at container creation, so a
corrected config file does not move an existing mount.

**Network behaviour.** Monitor outbound connections over a realistic period.
Turning "runs locally, nothing leaves the machine" from a claim into a
measured fact is one of the most valuable things a review can contribute, and
it is exactly what a security team will ask for.

**The API surface.** If it serves HTTP, fetch the OpenAPI document. Enumerate
endpoints. Try them unauthenticated. Note what an unauthenticated caller can
read or change.

**Stored data.** Inspect what has actually accumulated after normal use.
Query the store, read the on-disk files, look at the paths and metadata
recorded. This answers the data-governance domain far more reliably than the
documentation does, and it is the empirical test of any scoping control.

**Resource footprint.** Memory and disk under realistic load, against the
institution's standard build.

## Testing controls rather than trusting them

For any control the product claims, construct the situation it is supposed to
handle and observe.

- If it claims to respect exclusion rules, put a file in an excluded path,
  change it, and check whether it was ingested.
- If it claims scoping by some unit, configure the narrow scope and verify the
  boundary from the running system rather than the config file.
- If it claims deletion, delete something and verify it is gone from every
  store, including vector indexes and caches.
- If it claims local-only operation, watch the network.

Controls that turn out not to work as their names imply are among the most
valuable findings available, because users reason about safety through those
names.

## Recording evidence

For every finding, capture the citation as you go — file and line, the exact
command and its output, or a precise description of the observed behaviour.
Retrofitting citations afterwards is slow and error-prone, and uncited
findings get argued away.

Where a finding rests on a chain of reasoning, record the chain. "The mount is
wider than configured" is weaker than "the recorded path contains a
`scattercode/` segment, which only exists if `/workspace` maps to its parent —
confirmed by `docker inspect`."
