#!/usr/bin/env bash
#
# install.sh — install skills from this repository into a Claude skills
# directory.
#
# Purpose: a skill is just a folder containing SKILL.md, so "installing" one
# means putting it where Claude looks. This script does that predictably,
# symlinking by default so that `git pull` here updates what is installed.
#
# Prerequisites: bash, and a Claude installation that reads
# ~/.claude/skills/ (personal) or <project>/.claude/skills/ (project-scoped).
#
# How to run:
#   ./install.sh                                  install all skills for all projects
#   ./install.sh due-diligence-review             install one skill
#   ./install.sh --project /path/to/repo NAME     install into one project
#   ./install.sh --copy NAME                      copy instead of symlinking
#   ./install.sh --uninstall NAME                 remove an installed skill
#   ./install.sh --list                           show what is available and installed
#   ./install.sh --dry-run ...                    show actions without taking them
#
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TARGET_BASE="${HOME}/.claude/skills"
MODE="symlink"
ACTION="install"
DRY_RUN=0
declare -a NAMES=()

die() { printf 'error: %s\n' "$*" >&2; exit 1; }
log() { printf '%s\n' "$*"; }
run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '  would: %s\n' "$*"
  else
    "$@"
  fi
}

usage() {
  sed -n '3,20p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
  cat <<'EOF'

Options:
  --project PATH   Install into PATH/.claude/skills instead of ~/.claude/skills
  --copy           Copy the skill directory instead of symlinking it
  --uninstall      Remove the named skill(s) instead of installing
  --list           List available and installed skills, then exit
  --dry-run        Print what would happen, change nothing
  -h, --help       Show this help
EOF
}

# `discover_skills` — a skill is any top-level directory containing SKILL.md.
# Deriving the list from the filesystem means adding a skill needs no edit
# here, which is one less thing to forget.
discover_skills() {
  local d
  for d in "$REPO_ROOT"/*/; do
    [ -f "${d}SKILL.md" ] || continue
    basename "$d"
  done
}

while [ $# -gt 0 ]; do
  case "$1" in
    --project)
      [ $# -ge 2 ] || die "--project needs a path"
      [ -d "$2" ] || die "not a directory: $2"
      TARGET_BASE="$(cd "$2" && pwd)/.claude/skills"
      shift 2
      ;;
    --copy)      MODE="copy";        shift ;;
    --uninstall) ACTION="uninstall"; shift ;;
    --list)      ACTION="list";      shift ;;
    --dry-run)   DRY_RUN=1;          shift ;;
    -h|--help)   usage; exit 0 ;;
    -*)          die "unknown option: $1 (try --help)" ;;
    *)           NAMES+=("$1");      shift ;;
  esac
done

# Read into an array without `mapfile`, which is bash 4+ and so absent from
# the bash 3.2 that ships with macOS.
AVAILABLE=()
while IFS= read -r line; do
  [ -n "$line" ] && AVAILABLE+=("$line")
done < <(discover_skills)
[ "${#AVAILABLE[@]}" -gt 0 ] || die "no skills found in $REPO_ROOT"

if [ "$ACTION" = "list" ]; then
  log "Available in this repository:"
  for s in "${AVAILABLE[@]}"; do log "  $s"; done
  log ""
  log "Installed in $TARGET_BASE:"
  if [ -d "$TARGET_BASE" ]; then
    find "$TARGET_BASE" -maxdepth 1 -mindepth 1 \( -type d -o -type l \) -exec basename {} \; | sort | sed 's/^/  /'
  else
    log "  (none — directory does not exist)"
  fi
  exit 0
fi

# No names given means all of them; being explicit beats a surprising default.
if [ "${#NAMES[@]}" -eq 0 ]; then
  NAMES=("${AVAILABLE[@]}")
  [ "$ACTION" = "install" ] && log "No skill named; installing all ${#NAMES[@]}."
fi

for name in "${NAMES[@]}"; do
  src="$REPO_ROOT/$name"
  dst="$TARGET_BASE/$name"

  if [ "$ACTION" = "uninstall" ]; then
    if [ -e "$dst" ] || [ -L "$dst" ]; then
      log "Removing $name from $TARGET_BASE"
      run rm -rf "$dst"
    else
      log "Not installed, skipping: $name"
    fi
    continue
  fi

  [ -f "$src/SKILL.md" ] || die "no such skill: $name (try --list)"

  run mkdir -p "$TARGET_BASE"

  # Replace rather than merge. A half-updated skill directory is worse than
  # either version, and symlink-over-directory fails confusingly otherwise.
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    log "Replacing existing $name"
    run rm -rf "$dst"
  fi

  if [ "$MODE" = "symlink" ]; then
    log "Linking $name -> $TARGET_BASE"
    run ln -s "$src" "$dst"
  else
    log "Copying $name -> $TARGET_BASE"
    run cp -R "$src" "$dst"
  fi
done

if [ "$DRY_RUN" -eq 1 ]; then
  log ""
  log "Dry run — nothing was changed."
else
  log ""
  log "Done. Installed skills live in $TARGET_BASE"
  [ "$MODE" = "symlink" ] && log "Symlinked, so 'git pull' in this repository updates them."
fi
