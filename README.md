# scatterskills

A collaborative library of [Agent Skills](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview)
for Claude — reusable procedures for work we do often enough that the approach
is worth writing down.

Each skill captures a method: what to do, in what order, and *why* each step
matters. They exist because good work is repeatable, and because an approach
written down can be improved over time in a way that one held in your head
cannot.

## What is a skill?

A skill is a folder containing a `SKILL.md` — some instructions and a
description of when to use them. Claude reads the description, decides whether
the skill is relevant to what you have asked for, and if so follows the
instructions. Larger skills split detail into `references/` files that are
read only when needed, keeping the main instructions short.

You do not invoke a skill explicitly. You describe your task in the usual way,
and if a skill fits, it is used. You can also ask for one by name.

## Skills in this library

| Skill | What it does |
|---|---|
| [`manuscript-copyeditor`](skills/manuscript-copyeditor/) | Copy-edits book manuscripts and long-form prose, producing a self-contained HTML annotation report. Applies Hart's Rules or the Chicago Manual of Style depending on the target variety, with a dedicated pass for OCR artefacts in scanned text. Annotates rather than rewrites, so an editor decides what to accept |
| [`due-diligence-reviewer`](skills/due-diligence-reviewer/) | Produces an evidence-based due diligence review of a software product from the perspective of a reviewer at a regulated institution — bank, fund, insurer, energy, government. Use it to assess inbound software, or to give a vendor a friendly pre-review before a real one happens |

## Installing

Skills live in `~/.claude/skills/` for use across all your projects, or in
`<project>/.claude/skills/` for one project.

### With `npx skills` (recommended)

The [skills CLI](https://github.com/vercel-labs/skills) installs straight from
this repository — no clone needed, and it works with Claude Code, Cursor,
Codex and many other agents.

```bash
npx skills add scattercode/scatterskills            # everything
npx skills add scattercode/scatterskills --list     # preview first
npx skills add scattercode/scatterskills --skill manuscript-copyeditor
```

Pin to a release if you would rather not track `main`:

```bash
npx skills add scattercode/scatterskills@v1.0.0
```

Then `npx skills update` to refresh, and `npx skills remove <name>` to drop one.

### As a Claude Code plugin marketplace

```
/plugin marketplace add scattercode/scatterskills
/plugin install scatterskills@scatterskills
```

`/plugin marketplace update` refreshes the catalogue.

### With `install.sh` (no npm required)

Clone and run the script. Useful without Node, or when you want the installed
skills symlinked to a working copy you are editing.

```bash
git clone https://github.com/scattercode/scatterskills.git
cd scatterskills
./install.sh                                            # everything
./install.sh manuscript-copyeditor                      # one skill
./install.sh --project /path/to/project due-diligence-reviewer
./install.sh --uninstall manuscript-copyeditor
```

It symlinks by default, so `git pull` here updates what is installed. Pass
`--copy` for independent copies. `--help` lists every option and `--dry-run`
shows what would happen without touching anything.

### By hand

Nothing magic happens in any of the above — a skill is just a directory:

```bash
ln -s "$PWD/skills/due-diligence-reviewer" ~/.claude/skills/due-diligence-reviewer
```

## Using a skill

Once installed, describe your task normally:

> Can you review whether this vendor's tool would survive a security review at
> a bank? The repo is in `~/dev/some-vendor-tool`.

Claude picks up `due-diligence-reviewer` from the description and follows it.
You can also name it directly if you want to be sure.

To check what is installed:

```bash
ls -l ~/.claude/skills/
```

## Writing a skill

See [CONTRIBUTING.md](CONTRIBUTING.md) for structure, conventions and the
commit format. The short version: a skill is a folder with a `SKILL.md` whose
frontmatter carries a `name` and a `description`. The description is what
determines whether the skill gets used, so it deserves more care than
anything else in the file.

## Licence

[MIT](LICENSE). Use them, fork them, adapt them.
