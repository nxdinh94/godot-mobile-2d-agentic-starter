# Source Directory

When writing or editing game code in this directory, follow these standards.

## Engine Version Warning

The LLM's training data predates the pinned engine version.
**Always check `docs/engine-reference/` before using any engine API.**
Do not guess at post-cutoff API signatures — look them up first.

## Coding Standards

- All public APIs require doc comments
- Gameplay values must be **data-driven** (external config files), never hardcoded
- Prefer dependency injection over singletons for testability
- Architecture decisions go in `docs/architecture/` as ADRs — **how many depends on
  `modes.workflow`**: all at `full`, critical only at `standard`, none required at
  `minimal` (the decision log carries them)
- Commits must reference the relevant story ID or design document

## File Routing

Match the engine-specialist agent to the file type being written.
`/setup-engine` records which specialist handles code, shaders and UI in the
`specialists` block of `project.yaml`.

When in doubt, use `specialists.code` from `project.yaml`.

## Tests

Tests live in `tests/` — not in `src/`.
Run `/test-setup` to scaffold the test framework if it doesn't exist yet.
Verify gameplay formulas and edge cases through E2E scenarios with retained evidence.
Follow the root testing policy; isolated tests are exceptional and planned first.

## Verification-Driven Development

Define E2E scenarios before implementing gameplay systems. Never write unit tests
after code; for necessary isolation testing, list failure cases before code.
For UI changes, verify with screenshots.
Compare expected output to actual output before marking work complete.
