# Using the studio with Codex

Start Codex in the repository root with `codex`, or open this folder in the
Codex app. The root and scoped `AGENTS.md` files provide project instructions.
No global configuration, model pin or Claude installation is required. Python 3
and Bash run the existing configuration and workflow helpers; an engine or
browser is needed only for workflows that use one.

## Skills and maintenance

Use `$studio-start` for onboarding, `$studio-prototype a fishing game` to begin
a game, or `$studio-next-step` to find the next task. In Claude Code, continue to
use `/start`, `/prototype` and `/next-step`. All 78 current skill entries,
including legacy aliases, have adapters under `.agents/skills/`. Codex supports
[repository skills](https://learn.chatgpt.com/docs/build-skills) and
[scoped instructions](https://learn.chatgpt.com/docs/agent-configuration/agents-md).

The adapters reference `.claude/skills/<name>/SKILL.md` and its existing resources.
Edit the original workflow, then run:

```bash
python3 .claude/scripts/codex-skills.py
python3 .claude/scripts/codex-skills.py --check
```

The command works from any directory. It regenerates adapter metadata and
entrypoints deterministically, removes orphaned generated entrypoints and leaves
unrelated skills alone. `--check` reports drift without writing. Restart Codex
if new skills do not appear. Names use `studio-` to avoid collisions with user
skills. Source descriptions remain authoritative; adapters are generated files.

## Translate the workflow at runtime

Apply root `AGENTS.md` authorization and testing policy before the source
workflow. Legacy per-write approval and mandatory-unit-test instructions do not
override it. Preserve genuine user decisions and read-only workflow boundaries.

| Claude construct | Codex action |
| --- | --- |
| `Read`, `Glob`, `Grep`, `Write`, `Edit`, `Bash` | Use available file and shell tools for the same operation. |
| `AskUserQuestion` | Use the available question tool, or ask in plain text and wait when an answer is required. |
| `Skill`, `/name` | Read the local `studio-name` adapter and original workflow; pass the user's arguments. Never assume Claude slash commands execute in Codex. |
| `$ARGUMENTS`, `$0`, `$1`, `${ARGUMENTS[...]}` | Bind them to this workflow's invocation arguments as described by its argument hint; nested calls get their own arguments. Do not perform blind shell substitution. |
| `${CLAUDE_SKILL_DIR}` | Absolute path of the **original** `.claude/skills/<name>` directory, not the adapter directory. Resolve relative references from the original file. |
| `${CLAUDE_PROJECT_DIR}` | Absolute repository root. Run root-relative helpers from that root, even when Codex starts in a subdirectory. Quote paths. |
| Inline shell preprocessing (exclamation mark followed by a backtick), or fenced preprocessing blocks | Inspect the command, resolve its paths and arguments, then explicitly execute it when needed and authorized. Treat stdout as the resolved context. It has **not** already run. Do not execute examples or every shell block automatically. |
| `@path` instruction imports | Explicitly read the referenced file when relevant; Codex does not expand Claude imports. |
| `Agent`, `Task`, `subagent_type`, Claude task lists | Read the named `.claude/agents/<role>.md` instructions and use authorized native delegation if available. Otherwise perform role-based passes sequentially, retain dependencies and report that they are not independent reviews. Track task progress with available tools. |
| Claude `model`, `context: fork`, `allowed-tools`, `hooks` and permission frontmatter | Claude runtime metadata, not Codex configuration. Stay on the current model and obey actual Codex permissions. Never claim these settings took effect. |
| Claude effort, session or memory environment variables | Do not fabricate values or Claude runtime state. Use current session information if available; otherwise report it unavailable. Shared memory paths remain usable as ordinary files. |

For example, translate the `next-step` resolver to an explicit command from the
repository root:

```bash
bash .claude/hooks/yaml-helper.sh resolve_config --keys project.stage,workflow
```

Follow the original workflow's phase order and read its references on demand.
For applicable role coordination, read `.claude/docs/coordination-rules.md`;
its Claude model selection and Agent Teams sections apply only to Claude.
If an essential capability has no equivalent, report that step as blocked or
NOT ASSESSED. Never invent browser evidence, independent approvals or tool runs.

## Guardrails and handoff

Claude's `.claude/settings.json`, deny rules, status line and lifecycle/tool hooks
are not installed in Codex by this integration. Helpers under `.claude/scripts/`
can still be run explicitly when their inputs match the workflow. Hook scripts
expect Claude event payloads: do not invoke them blindly or claim their checks
ran automatically. Codex uses its own configured sandbox and approval system.

Both assistants share `project.yaml`, design documents, production records and
the session checkpoint. Record decisions and evidence before handing work over.
Use separate checkouts for concurrent editing. Do not commit or publish simply
because a legacy workflow says to; the shared authorization policy applies.

Verification scenarios: `studio-tests/codex-e2e.md`. Live Codex sessions require a
working local installation and authentication. A structural adapter check proves
the files are consistent, not that a live model successfully followed a workflow.
