# First-run checklist for a new project

Do these once, right after creating a project from this template.

## 1. Name it
- [ ] `project.godot`: set `config/name="my-game"` to your game's name.
- [ ] Optional: replace `docs/studio-readme.md` references or add your own README.

## 2. Check the toolchain
- [ ] `godot --version` prints `4.7.2.stable…`. If your version differs, run
      `/setup-engine godot <version>` (or `$studio-setup-engine godot <version>`)
      and let it update the pin.
- [ ] `bash .claude/scripts/project-coherence.sh` shows only `[MATCH]` lines, or
      one expected `[DIFFERS]` for gdUnit4 until step 3.

## 3. Install gdUnit4 (tests)
- [ ] In the Godot editor: Asset Store (AssetLib before 4.7) → **GdUnit4** → install.
- [ ] Project → Project Settings → Plugins → enable **GdUnit4**, then restart.
- [ ] Confirm `addons/gdUnit4/bin/GdUnitCmdTool.gd` exists (capital U).
- [ ] **Commit `addons/gdUnit4/`**: CI runs the committed copy.

## 4. Mobile export (when you are ready to ship to a device)
- [ ] Project → Export: add Android and/or iOS presets (creates `export_presets.cfg`).
- [ ] Set `commands.build` in `project.yaml`, e.g.
      `godot --headless --export-debug '<PRESET>'` (via `/project-settings`).
- [ ] Never commit keystores or signing passwords (`.gitignore` already blocks
      common key and package files).

## 5. Choose how much process you want
- [ ] Run `/start` (or `$studio-start`) once. The default is `workflow: minimal`:
      a one-page game brief, no per-system design docs, tests optional. Raise it
      later with `/project-settings` if the game grows.

## 6. Make the game
- [ ] `/prototype <one-line pitch>` (or `$studio-prototype`). Isometric choices
      (tile size, camera, touch controls, portrait resolution) get made here.
- [ ] Then `/next-step` after each play session.

## What not to change
- Keep `project.yaml` as the single source of truth for engine, naming and
  commands; `.claude/docs/technical-preferences.md` mirrors it.
- Edit workflows under `.claude/skills/`, then run
  `python3 .claude/scripts/codex-skills.py` to regenerate the Codex adapters.
