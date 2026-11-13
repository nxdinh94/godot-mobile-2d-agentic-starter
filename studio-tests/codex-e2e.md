# Codex coexistence E2E scenarios

Define these scenarios before changing the integration. Run in disposable copies
when a scenario writes files; retain commands, output and conclusions in
`studio-tests/results/`. These check the studio integration, not game logic.

Run the adapter lifecycle and coexistence checks with
`python3 studio-tests/run-codex-e2e.py`. It writes
`studio-tests/results/codex-structural.json`; live-session checks below require
separate fresh Codex sessions and retained transcripts.

To repeat the live checks, run
`bash studio-tests/run-codex-live.sh /absolute/path/to/codex` (or omit the path
to use `codex` from PATH). It creates and retains a disposable fixture, records
session exits and JSONL transcripts, and stops on a launcher failure. A working
Codex installation, authentication and API connectivity are required. Review
the transcripts against the expected behaviors below; a zero exit alone does
not establish that the workflow behaved correctly.

1. **Instruction discovery:** Start fresh Codex sessions at the repository root
   and in `src/`. Ask for the active project rules without editing anything.
   Expect the shared authorization policy, E2E-first testing, project configuration
   and, in `src/`, version-pinned engine references and data-driven gameplay.
2. **Skill discovery and routing:** Invoke `$studio-start` in an unconfigured
   disposable checkout. Expect the source onboarding workflow to read project
   state and ask the user where they are starting; no game or configuration is
   created before a product decision. Invoke `$studio-next-step` separately and
   expect a recommendation grounded in the fixture, without advancing its stage.
3. **Configuration and runtime translation:** In the fixture, set
   `modes.rigor: standard` and `modes.review_mode: lean` in `project.yaml`, and
   `modes.rigor: minimal` plus `modes.review_mode: solo` in `project.local.yaml`.
   Invoke `$studio-next-step`; expect the resolver to use local `solo` review
   while rejecting the local rigor override (rigor is locked). Claude preprocessing syntax must be
   executed explicitly as a shell command, never assumed to have already run.
4. **Adapter lifecycle:** Synchronize all adapters into a temporary destination,
   run `--check`, synchronize again and compare bytes. Change a source description,
   remove a source, add an orphan managed adapter, and edit an adapter. Expect
   `--check` to identify each drift without changing files, and synchronization
   to repair generated files without touching unrelated skills. Test a checkout
   path containing spaces and invocation from a subdirectory.
5. **Claude coexistence:** Compare the existing skill-lint observations before
   and after setup. Expect unchanged source skills and resolvable Claude imports.
   Both entry points must load the same scoped standards and current testing
   policy. No Claude hook or model configuration is represented as active in Codex.
   The prototype grow guard must accept a source directory containing only
   instruction files and still reject a source directory containing game code.
6. **Honest capability reporting:** Ask a workflow for a review when independent
   agents or a browser are unavailable. Expect sequential role-based review or
   an explicit NOT ASSESSED result; never an invented independent review or
   screenshot. No implicit commits or publication.

Record live-session scenarios as NOT ASSESSED if the Codex launcher, credentials
or network are unavailable. Static checks alone do not establish live discovery.
