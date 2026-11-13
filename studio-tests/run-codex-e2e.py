#!/usr/bin/env python3
"""Exercise the adapter CLI in disposable checkouts and retain JSON evidence."""

import argparse
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile


ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path,
                        default=ROOT / "studio-tests/results/codex-structural.json")
    args = parser.parse_args()
    observations = []

    def run(command, cwd, expected=0):
        result = subprocess.run(command, cwd=cwd, text=True, capture_output=True)
        observations.append({"command": command, "cwd": str(cwd),
                             "exit": result.returncode, "stdout": result.stdout,
                             "stderr": result.stderr})
        accepted = expected if isinstance(expected, tuple) else (expected,)
        if result.returncode not in accepted:
            raise AssertionError(f"Expected exit {expected}, got {result.returncode}: {command}")
        return result.stdout

    def snapshot(path):
        return {str(p.relative_to(path)): hashlib.sha256(p.read_bytes()).hexdigest()
                for p in sorted(path.rglob("*")) if p.is_file()}

    report = {"scenarios": [], "observations": observations}
    try:
        script = str(ROOT / ".claude/scripts/codex-skills.py")
        run([sys.executable, script, "--check"], ROOT)
        report["scenarios"].append("Repository adapters match all source entries")
        with tempfile.TemporaryDirectory(prefix="studio codex e2e ") as temp:
            fixture = Path(temp)
            sources = fixture / ".claude/skills"
            for source in sorted((ROOT / ".claude/skills").glob("*/SKILL.md")):
                target = sources / source.parent.name / source.name
                target.parent.mkdir(parents=True)
                shutil.copyfile(source, target)
            adapters = fixture / ".agents/skills"
            nested = fixture / "src"
            nested.mkdir()
            shutil.copyfile(ROOT / "src/AGENTS.md", nested / "AGENTS.md")
            shutil.copyfile(ROOT / "src/CLAUDE.md", nested / "CLAUDE.md")
            prototype = fixture / "prototypes/check/index.html"
            prototype.parent.mkdir(parents=True)
            prototype.write_text("<!doctype html><title>Guard fixture</title>\n")
            guard = ["bash", str(ROOT / ".claude/scripts/one-shot-grow.sh"),
                     "guard", "check", "--root", str(fixture)]
            output = run(guard, fixture, (0, 3))
            if "guard\troot\tpass\tnot grown" not in output:
                raise AssertionError("Instruction-only src/ blocks prototype grow")
            (nested / "game.js").write_text("console.log('game');\n")
            output = run(guard, fixture, 3)
            if "guard\troot\tfail" not in output:
                raise AssertionError("Grow guard accepted existing game code")
            (nested / "game.js").unlink()
            report["scenarios"].append("Prototype grow accepts instructions and rejects existing game code")
            command = [sys.executable, script, "--root", str(fixture)]
            run(command + ["--check"], nested, 1)
            if adapters.exists():
                raise AssertionError("--check created adapters")
            run(command, nested)
            run(command + ["--check"], nested)
            first = snapshot(adapters)
            run(command, nested)
            if first != snapshot(adapters):
                raise AssertionError("Second sync changed adapter bytes")
            report["scenarios"].append("Subdirectory invocation, spaces, read-only check and idempotence")

            source = sources / "start/SKILL.md"
            source.write_text(source.read_text().replace(
                "description:", 'description: "Fixture description"\nfixture-original-description:', 1))
            (sources / "next-step/SKILL.md").unlink()
            edited = adapters / "studio-prototype/SKILL.md"
            edited.write_text(edited.read_text() + "\nfixture drift\n")
            orphan = adapters / "studio-orphan/SKILL.md"
            orphan.parent.mkdir()
            shutil.copyfile(edited, orphan)
            unrelated = adapters / "personal/SKILL.md"
            unrelated.parent.mkdir()
            unrelated.write_text("An unrelated user skill\n")
            before = snapshot(adapters)
            drift = run(command + ["--check"], nested, 1)
            for expected in ("stale:", "orphan:", "studio-start", "studio-prototype",
                             "studio-next-step", "studio-orphan"):
                if expected not in drift:
                    raise AssertionError(f"Drift not reported: {expected}")
            if before != snapshot(adapters):
                raise AssertionError("--check modified adapters")
            run(command, nested)
            run(command + ["--check"], nested)
            if unrelated.read_text() != "An unrelated user skill\n" or orphan.exists():
                raise AssertionError("Sync failed to preserve unrelated skill or remove orphan")
            report["scenarios"].append("Metadata/source/adapter drift repaired, unrelated skill retained")

            edited.write_text("An unmanaged conflicting skill\n")
            before = snapshot(adapters)
            run(command, nested, 2)
            if before != snapshot(adapters):
                raise AssertionError("Conflicting unmanaged adapter was modified")
            report["scenarios"].append("Unmanaged name collision rejected without writes")

        for directory in ("src", "design", "docs", "studio-tests"):
            shared = ROOT / directory / "AGENTS.md"
            legacy = ROOT / directory / "CLAUDE.md"
            if "@AGENTS.md" not in legacy.read_text() or not shared.is_file():
                raise AssertionError(f"Missing shared scoped instructions: {directory}")
        report["scenarios"].append("Claude scoped imports resolve shared instruction files")
        run(["git", "diff", "--exit-code", "--", ".claude/skills"], ROOT)
        report["scenarios"].append("Original Claude skill workflows unchanged")
        report["status"] = "PASS"
        report["live_sessions"] = "Separate evidence required; this runner does not invoke a model"
    except (AssertionError, OSError) as error:
        report["status"] = "FAIL"
        report["error"] = str(error)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2) + "\n")
    print(f"{report['status']}: {len(report['scenarios'])} scenarios; evidence: {args.output}")
    return 0 if report["status"] == "PASS" else 1


if __name__ == "__main__":
    sys.exit(main())
