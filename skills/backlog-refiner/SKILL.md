---
name: backlog-refiner
description: Write and refine backlog items — epics, stories, spikes, tasks, bugs — and break designs, ADRs or plans into deliverable work. Covers choosing an issue type, active-sentence titles, the "As a / I want / So that" story format, acceptance criteria somebody else can check, INVEST, splitting an item that is too large, dependency link semantics, what belongs in a definition of done rather than on every item, and how an item travels from the board to a review. Use this whenever the user mentions a ticket, issue, story, epic, spike, bug, backlog, acceptance criteria, definition of done, definition of ready, sprint, story points or refinement — and also when they ask you to turn a design, ADR, review or piece of analysis into deliverable work items, or to propose a phased implementation, even if they never name a tracker.
---

# Backlog refinement

What a work item has to say, how to choose its type, and how to turn a design or an analysis into a set of them.

**This produces drafts.** It does not raise anything in a tracker — the output is text to review and then create.

The examples use Jira's vocabulary, because it is the tracker most readers will be using and it has a name for everything. The substance is not Jira-specific: what makes an item well-formed, when to split one, and how to record ordering apply just as well in Linear, Azure DevOps, GitHub Issues, or on index cards. Where a tracker names something differently, the concept still holds.

---

## What every item must be

Whatever the type, an item is expected to be:

- **Clearly scoped** — a well-defined purpose and boundary, so it is obvious what is in and what is not.
- **Deliverable** — completable, and producing tangible value either directly for a user or by enabling other work.
- **Acceptance criteria defined** — measurable conditions for success, so "done" is not a matter of opinion.
- **Traceable to value** — linked back to an objective, so the effort is accounted for.

The recurring failure is an item that describes a *state* rather than a *change*, and whose completion nobody can test. If you cannot write acceptance criteria for a draft, it is not yet understood well enough to raise.

---

## Issue types

```text
Epic          a body of value too large for one iteration
├── Story     a functional, releasable change
├── Spike     time-boxed research to reduce uncertainty
├── Task      valuable work with no user-visible behaviour change
└── Bug       a fault found outside a story

Sub-task      an activity needed to complete any of the above
Defect        a fault found while testing a story, raised against that story
```

Sub-tasks and defects hang off whichever item they belong to, rather than sitting under one particular type.

Choosing between them:

- **Story vs Task.** A story delivers a functional, releasable change a user can perceive. A task is valuable work with no functional surface — an ADR, a runbook, a documentation page, a migration with no behavioural change. Do not dress a task up as a story with a contrived persona.
- **Story vs Spike.** If the outcome is a decision or an answer rather than a change, it is a spike, and it must be time-boxed. A spike's acceptance criteria describe the *finding* being recorded, not a system behaving differently.
- **Bug vs Defect.** A bug is found in the wild, outside a story. A defect is found while testing a story and hangs off it.

Trackers vary in which of these they offer, and teams add their own — request queues, onboarding, support. The distinctions above are the ones that change how the work is written; anything else your tracker offers is routing.

**Standing epics** are the deliberate exception to "an epic must be completable". Most teams keep a few long-running buckets for work belonging to no project — monitoring and alerting, technical debt, small enhancements. Put small unplanned work there rather than inventing a throwaway epic for it.

---

## Titles

**Favour active sentences over descriptions of state.** This is the single most consistently applied rule across every issue type, and the easiest to get wrong when converting findings into items.

| Write this | Not this |
| --- | --- |
| Amend date on search screen to MM/dd/yyyy | Search screen date in incorrect format |
| Implement OCR using Tesseract | Tesseract OCR |

A finding is a symptom; a title is the change. When working from a review, an ADR or an incident report, every heading you inherit will be phrased as a state — rewrite each one.

---

## Story template

The description opens with the three-line intent block, then a horizontal rule, then the detail. (In Jira, type four hyphens and press return.)

```text
As a WHO IS THE CHANGE FOR;
I want SHORT DESCRIPTION OF WHAT IS REQUIRED;
So that WHY ARE WE DOING THIS.

----

Any further context needed to understand the change.

Acceptance criteria
- ...
- ...

Out of scope
- ...

Environments
- ...
```

**Acceptance criteria** define the scope of *this* change. They do not restate what is true of every item — that is the definition of done, below. **Out of scope** and **Environments** are optional; include them when they prevent a genuine misunderstanding, and leave them out when they would only be noise.

### Worked example

```text
As an archivist;
I want a CLI tool to generate an OCR transcript of an image;
So that I can index the image based on keywords.

----

As of today, manual writing of text from an image is slow.

Acceptance criteria
- CLI tool developed
- Can pass a file location as an argument
- Plaintext transcript generated based on image name
- Change to system architecture documented

Out of scope
- Integration into a wider OCR and indexing pipeline
```

Note what the example does: the "So that" names a real benefit rather than restating the "I want", and the criteria are things somebody else could check without asking the author what was meant.

---

## Epic template

An epic focuses on the requirement, not a pre-selected technical solution:

```text
Background:
A short explanation of the current state.

Scope:
A short description of what work is required. Link to the requirements page as required.

Acceptance criteria:
A bullet pointed list of criteria that applies to the whole epic.

Out of scope:
What is not included as part of this change.
```

Where the tracker has a short label for boards, adopt a common prefix across every epic under one initiative so they are easy to find together.

---

## INVEST, and splitting

Stories are held to the INVEST test:

- **Independent** of all others
- **Negotiable** — not a specific contract for features
- **Valuable**
- **Estimatable** to a good approximation
- **Small** enough to fit within an iteration
- **Testable** in principle, even if no test exists yet

**Independence** is the one most often broken when decomposing a plan, because the phases have a natural order. That is acceptable — record the ordering through `Depends On` links rather than merging stories together to avoid the dependency.

**Small** is the other, and it is the one worth practising.

### Splitting an item that is too large

Take the OCR story above, and suppose refinement finds it spans two iterations.

The tempting split is by architecture — *"Build the CLI front end"* and *"Build the OCR back end"*. Both are wrong: neither is releasable alone, neither can be demonstrated without the other, and each is a component rather than a change.

Split along the value instead, taking the narrowest slice of behaviour still worth having:

```text
1. Generate a plaintext transcript from a single named image file
2. Generate transcripts for a directory of images in one run
3. Report a per-file confidence score so poor transcripts can be triaged
```

Each is releasable on its own, each is demonstrable, and an archivist gets something usable from the first even if the other two are never built.

The heuristic: **if the pieces can only be demonstrated together, you have split by architecture.** Go back and slice the behaviour.

### When you have gone too far

Decomposition has a floor. Signs you are below it:

- An item's acceptance criteria only restate its title.
- Two items would always be picked up by the same person in the same sitting.
- The item names an activity — "Add a column to the users table" — rather than an outcome.

Merge them. Refining, estimating and tracking each item costs real time, and forty items nobody can prioritise is worse than twelve that carry the same work.

---

## Working an item

Refinement produces items that somebody then picks up. The few steps between the board and a review are where a well-written item pays off, or where it turns out to have been vague.

1. **Take the item from the board**, rather than starting work and finding an item for it afterwards. Work that arrives without an item is work nobody can see, prioritise or account for.
2. **Confirm the requirement before writing anything.** The usual form is a *three amigos* conversation — whoever wanted the change, whoever is building it and whoever will test it, together, briefly. The three perspectives catch three different classes of misunderstanding, and all of them are cheaper to catch now than in review. If the conversation changes the scope, change the item.
3. **Branch from the trunk**, one branch per item, named so the item is identifiable from the branch alone.
4. **Implement it**, moving the item's status as you go, so the board reflects reality without anybody having to ask.
5. **Push, and raise a merge or pull request that references the item**, so the change and the reason for it stay connected long after both are forgotten.

The thread running through all of it is that **the item is the unit of work**: one item, one branch, one review. When that holds, the history explains itself and anybody can get from a line in a changelog to the reason it was built. When it does not, the item degrades into a label attached to whatever happened to get done that week.

If step 2 routinely changes the scope, the problem is upstream in refinement rather than in how developers work.

---

## Definition of done

Acceptance criteria say what makes *this* item different. A **definition of done** says what is true of *every* item before anybody calls it finished. Teams that conflate the two end up copying "unit tests written" onto three hundred stories, and the criteria that actually mattered get lost in the boilerplate.

Agree it once, as a team, and keep it out of individual items. If you catch yourself putting "code reviewed" or "tests pass" into acceptance criteria, it belongs here instead.

A definition of done belongs to the team rather than to any standard, but most cover the same ground. A representative one:

**Acceptance criteria met, with nothing quietly dropped**

- Defects found against the item are fixed, or raised as items of their own
- Technical debt accepted along the way is raised as an item of its own

**The change is fit to merge**

- Formatting and lint checks pass
- Automated tests added, meeting whatever coverage threshold the team has agreed
- Static analysis, security scanning and dependency checks show nothing outstanding
- Integration tests cover the change and pass

**It is merged and building**

- Reviewed and merged to the target branch
- Branch protection satisfied and the pipeline green

**It runs somewhere real**

- Deployed to an environment and exercised there by whoever built it
- Demonstrated in the most production-like environment available, and accepted by the person who asked for it

**It is documented**

- The artefact explains itself to the next person who opens it
- Repository documentation updated where behaviour changed
- Shared documentation updated where other people rely on it

**The tracker matches reality**

- The item and its sub-tasks are closed

Two entries in that list carry more weight than the rest.

**Raising a new item rather than carrying an unfinished one** is what stops "done" quietly coming to mean "mostly done". The compromise ends up visible in the backlog, where it can be prioritised, instead of in somebody's memory.

**Acceptance by the person who asked** is the other. The author is not the judge of whether the thing requested was delivered, and a demonstration is the cheapest way to find out before the iteration closes rather than after.

Adapt the specifics freely. Coverage thresholds, the names of scanners, and which environments exist are all local; the shape is not. What is worth preserving is that every entry is checkable by somebody other than the author — a definition of done full of judgements only the author can make is a definition of nothing.

The counterpart is a **definition of ready**: what has to be true before an item can be pulled into an iteration at all. Refinement is the activity that gets items there, and most of this skill describes how.

---

## Fields

Names vary between trackers; these are Jira's. What matters is that each is a decision somebody has to make, not a box to fill.

| Field | Applies to | Notes |
| --- | --- | --- |
| Title | all | Active sentence describing the change |
| Description | all | Templates above |
| Epic Link / Parent Link | Story / Epic | Story links to its epic; epic links to its initiative |
| Priority | all | How important is it |
| Team | all | Controls which board it appears on |
| Assignee | all | Who works on it |
| Reporter | all | Who the item is for |
| Component/s | Epic | Which part of the system it relates to |
| Sprint | Issue level | Set during iteration planning |
| Story Points | Issue level | Set during backlog refinement |
| Release / Fix Version | Issue level | Flags inclusion in a named release |

Do not invent values for team, assignee, reporter or component. If none fits, that is a question for the team, not a licence to add one. When drafting rather than raising, leave a field blank rather than guessing — a wrong team routes the item to the wrong board, where it is easily missed.

Sprint, story points and priority are decided by the team in refinement and planning. Leave them alone when drafting.

---

## Links

The distinction between the first two is meaningful and routinely collapsed:

| Link | Reverse | Meaning |
| --- | --- | --- |
| Depends On | Is a dependency of | Cannot be started or completed until the other is done — *"I need that done first."* |
| Blocks | Is blocked by | Work is *currently* prevented because the other is unresolved — *"I'm stuck right now because of that."* |
| Is Related To | Is Related To | Other items that may be relevant |
| Documentation | – | The requirements page, design or ADR the work came from |

`Depends On` is a planning statement, known when the work is written. `Blocks` is a status statement, discovered while the work is in flight. Use `Depends On` when decomposing a plan.

---

## Turning a design, ADR or analysis into items

This is the most common request, and the point where the conventions are most often lost.

1. **Work from the phases, not the findings.** A design document's findings are states. Its implementation plan is already a sequence of changes — start there, and give each numbered action a story.
2. **Give each one an active-sentence title.** Rewrite every inherited heading.
3. **Pick the type honestly.** An investigation with an unknown answer is a spike. Producing a document or a pattern is a task. Only a functional, releasable change is a story.
4. **Make acceptance criteria concrete and evidence-based.** Prefer criteria a reader could verify against a real artefact — a named file, a count, a named group or catalogue — over criteria that restate the title. Where the source analysis established a number, use it.
5. **Record ordering as `Depends On` links**, and state the sequence explicitly if you are delivering the set as a document rather than raising it directly.
6. **Flag the gates.** If one item's outcome could invalidate the plan, say so rather than burying it at position nine.
7. **Link back.** Every item should reference the ADR, design or initiative it came from, so the work stays traceable to value.

When delivering a set of drafts in a chat or a document rather than raising them directly, give each one a title, the intent block and acceptance criteria, and add a short sequencing table at the front. Leave team, priority, sprint and story points to the person raising them.
