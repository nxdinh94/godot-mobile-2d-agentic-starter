# Godot Mobile 2D Agentic Starter

A ready-to-clone starting point for building a **2D mobile game (Android + iOS)
in Godot 4.7 with GDScript**, driven by an AI coding agent. It works with both
**Claude Code** and **Codex** and shares one config, one set of workflows and one
set of design records between them.

It is built on [Claude Code Game Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)
(MIT). The upstream README is kept at [`docs/studio-readme.md`](docs/studio-readme.md).

## What you get

| Piece | Where |
|---|---|
| Engine pinned and configured: Godot 4.7.2, GDScript, Mobile renderer, Godot Physics 2D | `project.yaml`, `project.godot` |
| Version-pinned Godot API reference, so agents don't guess post-training APIs | `docs/engine-reference/godot/` |
| Agent workflows (skills), roles and rules | `.claude/` |
| Codex adapters for every workflow (`$studio-*`) | `.agents/skills/`, `docs/codex.md` |
| Shared instructions for both assistants | `AGENTS.md` (+ scoped `AGENTS.md`), `CLAUDE.md` |
| Test scaffold (gdUnit4, E2E-first), smoke checklist, evidence folder | `tests/`, `production/qa/evidence/` |
| CI that runs the tests on every push and PR | `.github/workflows/tests.yml` |

## Start a new game

1. Click **Use this template** on GitHub (or `gh repo create <name> --template <owner>/godot-mobile-2d-agentic-starter`).
2. Clone it and follow [`TEMPLATE.md`](TEMPLATE.md), a short first-run checklist.
3. Open your agent in the repo root and describe the game in one line:
   - Claude Code: `/prototype an isometric village builder, tap to place buildings`
   - Codex: `$studio-prototype an isometric village builder, tap to place buildings`
4. Play it, ask for changes in plain words, then run `/next-step` (or `$studio-next-step`).

## Requirements

- [Godot](https://godotengine.org/) 4.7.2 on your `PATH` (`godot --version`)
- Claude Code and/or Codex
- For device builds: Android SDK + JDK (Android), a Mac with Xcode (iOS)

## Using both assistants

See [`docs/codex.md`](docs/codex.md). Don't run both in the same checkout at the
same time. Record decisions in `project.yaml`, `design/` and `production/` before
handing over.

## License

MIT, see [`LICENSE`](LICENSE). Framework © its upstream authors.
