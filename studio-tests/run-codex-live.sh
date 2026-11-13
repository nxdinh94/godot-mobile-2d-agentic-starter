#!/usr/bin/env bash
# Fresh read-only model sessions; transcripts are retained, fixtures stay in /tmp.
set -eu
ROOT=$(cd "$(dirname "$0")/.." && pwd)
CODEX_BIN=${1:-codex}
RESULTS="$ROOT/studio-tests/results"
mkdir -p "$RESULTS"
FIXTURE=$(python3 - "$ROOT" <<'PY'
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

root = Path(sys.argv[1])
fixture = Path(tempfile.mkdtemp(prefix="my-game-codex-live-"))
for name in (".claude", ".agents", "docs", "src", "design"):
    shutil.copytree(root / name, fixture / name, ignore=shutil.ignore_patterns(
        "settings.local.json", "agent-memory", "worktrees", "__pycache__"))
for name in ("AGENTS.md", "CLAUDE.md", "README.md", ".gitignore"):
    shutil.copyfile(root / name, fixture / name)
(fixture / "project.yaml").write_text(
    "schema_version: 1\nmodes:\n  rigor: standard\n  review_mode: lean\n")
(fixture / "project.local.yaml").write_text(
    "modes:\n  rigor: minimal\n  review_mode: solo\n")
subprocess.run(["git", "init", "-q", str(fixture)], check=True)
print(fixture)
PY
)
printf 'Fixture retained at %s\n' "$FIXTURE"
printf '%s\n' "$FIXTURE" > "$RESULTS/codex-live-fixture.txt"

run_session() {
  local label=$1 directory=$2 prompt=$3 status=0
  timeout 55s "$CODEX_BIN" exec --ephemeral --ignore-user-config --sandbox read-only \
    --cd "$directory" --json "$prompt" </dev/null \
    > "$RESULTS/$label.jsonl" 2> "$RESULTS/$label.stderr" || status=$?
  printf '%s\t%s\n' "$label" "$status" >> "$RESULTS/codex-live-exits.tsv"
  if [ "$status" -ne 0 ]; then
    printf '%s failed (exit %s); inspect retained stderr and transcript.\n' "$label" "$status"
    return "$status"
  fi
  printf '%s finished; inspect its transcript against codex-e2e.md.\n' "$label"
}

: > "$RESULTS/codex-live-exits.tsv"
run_session codex-root-live "$FIXTURE" \
  'Read-only integration check: summarize the active project authorization, testing, configuration and studio skill discovery instructions. Do not edit files, run other models, or access the network.'
run_session codex-src-live "$FIXTURE/src" \
  'Read-only integration check: summarize active root and scoped instructions, emphasizing testing, data-driven gameplay and engine version references. Do not edit files, run other models, or access the network.'
run_session codex-start-live "$FIXTURE" \
  '$studio-start
Onboarding E2E check: follow this skill until the first required user decision, ask it in your final response and stop. Do not edit files, run other models, or access the network.'
run_session codex-next-step-override-live "$FIXTURE" \
  '$studio-next-step
E2E check: explicitly resolve rigor, workflow and review_mode with the existing helper. Include effective values and sources in your final recommendation. Do not edit files, advance stage, run other models, or access the network.'
