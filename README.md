# Godot Mobile 2D Agentic Starter

A ready-to-clone starting point for building an **isometric 2D simulation game
for mobile (Android + iOS) in Godot 4.7 with GDScript**, driven by an AI coding
agent: village builders, tycoons, farm and city sims. It works with both
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
   - More pitch ideas and the decisions to settle first: see
     [Built for isometric simulation games](#built-for-isometric-simulation-games).
4. Play it, ask for changes in plain words, then run `/next-step` (or `$studio-next-step`).

## Built for isometric simulation games

The starter is tuned for a tap-driven, isometric, build-and-manage sim: a 2D
world drawn at an angle, a grid of tiles, placeable buildings, resources that
change over time, and a touch-only UI on a phone screen.

The engine side is already decided: Godot 4.7.2, GDScript, the Mobile renderer,
Godot Physics 2D, touch input, and a 60fps budget. What the **game** needs is
not, so settle these in your first `prototype` session and record them in
`design/game-brief.md` (or `design/` docs at a higher process level):

| Decision | Why it matters |
|---|---|
| Tile size and grid shape (e.g. 2:1 diamond) | Every sprite, the camera and placement all depend on it |
| Camera: fixed, pan, pinch-zoom, bounds | The main touch interaction in a sim |
| Placement and selection by touch | Tap, drag to place, confirm and cancel, without hover |
| Draw order (depth sorting) | Buildings and characters must overlap correctly |
| Simulation clock | Real-time, tick-based or paused-when-closed; sets how it runs offline |
| Resources and balance data | Keep numbers in data files, not in code (project rule) |
| Save and load | A sim is only fun if the town persists, including app suspend |
| Screen orientation and safe areas | Portrait or landscape, and notches on phones |

Check `docs/engine-reference/godot/` before using engine APIs for tilemaps,
cameras or input; agents are told to do the same. This README gives no API
recipes for them, because Godot 4.5 to 4.7 changed things the model may not know.

Useful pitches to paste into `prototype`:

- `an isometric village builder, tap to place houses and farms, villagers produce resources over time`
- `a cozy isometric farm sim for phones, plant and harvest on a tile grid, pinch to zoom`
- `an isometric tycoon, place shops on a grid, customers arrive on a timer, upgrade to earn more`

## Next useful commands

Every command works in both assistants: `/name` in Claude Code, `$studio-name`
in Codex. Not sure where you are? Run `next-step`; it names the one thing to do.

| When | Claude Code | Codex |
|---|---|---|
| Right after cloning (once) | `/start` | `$studio-start` |
| Have an idea, want a playable build | `/prototype <one-line pitch>` | `$studio-prototype <pitch>` |
| No idea yet | `/brainstorm` | `$studio-brainstorm` |
| After every play session | `/next-step` | `$studio-next-step` |
| Build a story or feature | `/dev-story` | `$studio-dev-story` |
| Lock a consistent visual style | `/art-bible` | `$studio-art-bible` |
| Review code you just wrote | `/code-review` | `$studio-code-review` |
| Before sharing a build | `/smoke-check` | `$studio-smoke-check` |
| Scope is growing | `/scope-check`, `/cut` | `$studio-scope-check`, `$studio-cut` |
| Change a setting (engine, process level, commands) | `/project-settings` | `$studio-project-settings` |
| Lost track of project state | `/project-stage-detect` | `$studio-project-stage-detect` |
| Move to a new engine version | `/setup-engine godot <version>` | `$studio-setup-engine godot <version>` |
| Ready to ship | `/release-checklist` | `$studio-release-checklist` |

A typical first week:

1. Follow [`TEMPLATE.md`](TEMPLATE.md): name the game, install gdUnit4, add export presets.
2. `start` → `prototype` → play → ask for changes in plain words.
3. `next-step` after each session; `smoke-check` before you share a build.
4. When the game needs more structure, raise the process level with
   `project-settings`, then use `gate-check` to see if you're ready for the next stage.


- [Godot](https://godotengine.org/) 4.7.2 on your `PATH` (`godot --version`)
- Claude Code and/or Codex
- For device builds: Android SDK + JDK (Android), a Mac with Xcode (iOS)

## Using both assistants

See [`docs/codex.md`](docs/codex.md). Don't run both in the same checkout at the
same time. Record decisions in `project.yaml`, `design/` and `production/` before
handing over.

## License

MIT, see [`LICENSE`](LICENSE). Framework © its upstream authors.
