
## Persistent Copilot subagents

Create a project-local `.subagents` tree for the `implementation`, `qa`, and `pm`
roles by manually running the pre-commit hook:

```bash
pre-commit run scaffold-subagents --hook-stage manual
```

Scaffolding creates a `template/providers.json`, a `subagent/subagent.bash`, a
`tools/` directory, a `workflows/` directory, and a `logs/` directory for each
role. Implementation and QA have `logs/pytest/` and `logs/stream/`; PM has
`logs/chat/` and `logs/stream/`. Script and tool defaults are copied from
`.scripts/python/templates/subagents/`; existing files are left untouched, so
role definitions and provider settings can be customized and committed. The
Python manager contains no embedded subagent script bodies; edit the checked-in
templates to change defaults for newly scaffolded roles.

Each `.subagents/<role>/tools/` directory controls the Copilot CLI tools for
that role:

- `available-tools.txt`: one tool name per line; passed as `--available-tools`.
- `allowed-tools.txt`: one `--allow-tool` rule per line.
- `disallowed-tools.txt`: one `--deny-tool` rule per line.

Blank lines and lines beginning with `#` are ignored. The checked-in files
provide defaults; edit the role's files to customize that subagent's tool access.

Each `providers.json` follows Copilot CLI's provider configuration format. Edit
the provider name/type and model ID as needed. Keep one provider entry per role
(it can have multiple models), because each role has one endpoint/key pair.
Model limits use `maxPromptTokens` and `maxOutputTokens`; the CLI documentation
does not define a minimum-token field. Keep `baseUrl` and `apiKey` out of the
persistent role file. Runtime environment values for base URL and API key are
optional:

| Role | Base URL secret | API key secret |
| --- | --- | --- |
| Implementation | `IMPLEMENTATION_SUBAGENT_PROVIDER_BASE_URL` | `IMPLEMENTATION_SUBAGENT_PROVIDER_API_KEY` |
| QA | `QA_SUBAGENT_PROVIDER_BASE_URL` | `QA_SUBAGENT_PROVIDER_API_KEY` |
| PM | `PM_SUBAGENT_PROVIDER_BASE_URL` | `PM_SUBAGENT_PROVIDER_API_KEY` |

When either role-specific environment value is unset, the runner uses that
field from the matching provider in the config specified by
`COPILOT_PROVIDERS_CONFIG`, or `~/.copilot/providers.json` by default. Provider
matching uses the role provider's `name`. If the CLI config contains only one
provider, that provider is used as the fallback; with multiple providers, the
names must match or the missing environment value must be supplied. An explicit
environment value takes precedence over the config.

Run a role with the appropriate secrets already provided by Codespaces or
GitHub Actions. The implementation script also expects `PROMPT` and
`WATCH_DIR`; QA and PM expect `PROMPT`.

```bash
export PROMPT="Describe the work for this subagent"
export WATCH_DIR=tests
python .scripts/python/scripts/manage_subagents.py run implementation
```

To run the implementation workflow with the provider config attached to the
entire loop:

```bash
python .scripts/python/scripts/manage_subagents.py run implementation \
  --workflow constrained_loop_workflow.bash -- tests
```

Each invocation launches its own bash process and sets Copilot CLI's documented
singular `COPILOT_PROVIDERS_CONFIG` variable to a distinct config file under
`/dev/shm`. The runtime file contains resolved endpoint credentials, is
read-only, and is deleted when the subprocess exits. Other role-specific
secrets are removed from that child process's environment. This lets role
processes run concurrently without racing over a shared provider-config
variable or file. The host must provide a writable `/dev/shm`; the runner fails
rather than falling back to disk storage.
