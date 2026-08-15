# scatterskills

A personal library of [Agent Skills](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview)
for Claude — reusable procedures for work I do often enough that the approach
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
| [`due-diligence-review`](due-diligence-review/) | Produces an evidence-based due diligence review of a software product from the perspective of a reviewer at a regulated institution — bank, fund, insurer, energy, government. Use it to assess inbound software, or to give a vendor a friendly pre-review before a real one happens |

## Installing

Skills live in `~/.claude/skills/` for personal use across all projects, or in
`<project>/.claude/skills/` for one project.

**Install everything, for all projects:**

```bash
git clone https://github.com/scattercode/scatterskills.git
cd scatterskills
./install.sh
```

**Install one skill:**

```bash
./install.sh due-diligence-review
```

**Install into a specific project instead of your home directory:**

```bash
./install.sh --project /path/to/project due-diligence-review
```

By default `install.sh` creates symlinks, so pulling updates in this
repository updates the installed skills. Pass `--copy` for independent copies
that will not change under you.

**Uninstall:**

```bash
./install.sh --uninstall due-diligence-review
```

Run `./install.sh --help` for the full set of options, and `--dry-run` to see
what would happen without touching anything.

### Installing by hand

Nothing magic happens in the script — a skill is just a directory:

```bash
ln -s "$PWD/due-diligence-review" ~/.claude/skills/due-diligence-review
```

## Using a skill

Once installed, describe your task normally:

> Can you review whether this vendor's tool would survive a security review at
> a bank? The repo is in `~/dev/some-vendor-tool`.

Claude picks up `due-diligence-review` from the description and follows it.
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
