# Shared studio instructions

This is a game-studio template. Resolve the selected engine from `project.yaml`.
Claude Code and Codex use the same configuration, design records and workflow sources.

## Authorization and collaboration

- Follow the user's task authorization. Complete authorized, reversible edits
  without asking permission for each file or section, including multi-file work.
- Ask for missing product decisions, scope changes and consequential actions
  that the user has not authorized. A request for a proposal or draft alone
  does not authorize implementing it. Respect explicit review checkpoints.
- Do not commit, push, publish or send messages unless the user authorizes it.
- This policy takes precedence over legacy ask-before-write examples, automatic
  commits and testing requirements in skills, agents and framework references.
  Automation modes still govern unresolved decisions, not repeated approval for
  work already authorized. A missing answer is never new authorization.

## Testing

- NEVER write unit tests after you write code.
- Highly prefer E2E tests as the sole testing mechanism. Use them to verify
  complex features. At the end of E2E tests, produce a verifiable and repeatable
  artifact: commands, fixtures, outcomes and retained screenshots or transcripts.
- If you must test a system in isolation, FIRST write all the ways it could
  fail, THEN write the code.
- For player-observable changes, launch the game and retain evidence under
  `production/qa/evidence/`. A parse check is not a run. Report unavailable
  checks as NOT ASSESSED; never invent results.

## Find the project context

- Read `project.yaml` and use `.claude/hooks/yaml-helper.sh resolve_config` for
  effective settings, including `project.local.yaml` overrides. See
  `.claude/docs/config-resolution.md`. Keep `project.yaml` as the shared config;
  do not infer a chosen engine from placeholder text in `CLAUDE.md`.
- Resolve engine-specific code and test roots using
  `.claude/docs/code-root-resolution.md` and `.claude/engines/engines.tsv`.
- Read `.claude/docs/coding-standards.md` for coding and documentation standards,
  subject to the testing and authorization policy above. Read relevant rules in
  `.claude/rules/` when editing their matching paths; Codex does not auto-load them.
- Check `docs/engine-reference/<engine>/VERSION.md` before using engine APIs.
- Read `production/session-state/active.md` if present when resuming or after
  compaction. Keep an authorized task's checkpoint concise, with changed paths,
  decisions, evidence and remaining work. It is gitignored, shared by assistants;
  simultaneous sessions should use separate checkouts to avoid overwriting it.
- Workflow sources, templates and role definitions remain under `.claude/`.
  Read only the sections relevant to the task. Helper scripts emit observations,
  never verdicts; interpret them in the current project context.

## Codex workflows

Read `docs/codex.md` before using a studio skill in Codex. Invoke the namespaced
adapters as `$studio-start`, `$studio-prototype`, `$studio-next-step`, etc.
They load original workflows; they do not enable Claude hooks or permissions.
Treat `.claude/agents/` as role references, with sequential reviews when delegation
is unavailable or unauthorized. Label sequential reviews honestly.

Scoped `AGENTS.md` files hold directory standards for both assistants. In Claude,
the corresponding `CLAUDE.md` imports them. Project settings and game artifacts
are shared; no provider-specific copy of the game is needed.
