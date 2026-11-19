
## Persistent Copilot subagents

Create missing role directories and provider configuration files by running:

```bash
bash .scripts/bash/CI/manage_subagents.bash manage-subagents-scaffold
```

Scaffolding creates the `template/`, `subagent/`, `tools/`, and `workflows/`
directories and role-specific base log directories. It creates a missing
`template/providers.json` without overwriting an existing one. It does not
create or copy the role scripts, tool configuration files, or instruction
files; supply those separately under `.subagents/<role>/`. Commit them if they
should be part of the project's defaults. The Python manager contains no
embedded subagent script bodies.

The base log directories are `logs/pytest/` and `logs/stream/` for
implementation and QA, and `logs/chat/` and `logs/stream/` for PM. At runtime,
logs are written beneath a branch-specific directory:
`.subagents/<role>/logs/<branch-key>/...`.

Each role uses only `.subagents/<role>/instructions/instructions.md` as its
custom prompt. The runner passes `--no-custom-instructions` so Copilot CLI does
not also load repository instruction files. Create the file for each role; an
empty file is allowed, but provides no instructions. No `PROMPT` environment
variable or extra prompt argument is needed.

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
persistent role file. For each endpoint field, the runner uses the role-specific
environment variable below when set, falling back to
`COPILOT_PROVIDER_BASE_URL` or `COPILOT_PROVIDER_API_KEY` when it is unset. The
resolved values are added to the temporary config in `/dev/shm`:

| Role | Base URL secret | API key secret |
| --- | --- | --- |
| Implementation | `IMPLEMENTATION_SUBAGENT_PROVIDER_BASE_URL` | `IMPLEMENTATION_SUBAGENT_PROVIDER_API_KEY` |
| QA | `QA_SUBAGENT_PROVIDER_BASE_URL` | `QA_SUBAGENT_PROVIDER_API_KEY` |
| PM | `PM_SUBAGENT_PROVIDER_BASE_URL` | `PM_SUBAGENT_PROVIDER_API_KEY` |

Run a role with the appropriate secrets already provided by Codespaces or
GitHub Actions. The instructions file is the sole custom prompt source for
every role.

```bash
bash .scripts/bash/CI/manage_subagents.bash manage-subagents-run-implementation
```

To run the implementation workflow:

```bash
bash .scripts/bash/CI/manage_subagents.bash manage-subagents-run-implementation-workflow
```

When both the base URL and API key are available, each invocation launches its
own bash process and sets Copilot CLI's documented singular
`COPILOT_PROVIDERS_CONFIG` variable to a distinct config file under `/dev/shm`.
The runtime file contains resolved endpoint credentials, is read-only, and is
deleted when the subprocess exits. Other role-specific secrets and provider
variables are removed from that child process's environment. This lets role
processes run concurrently without racing over a shared provider-config
variable or file. In this case, the host must provide a writable `/dev/shm`
mounted as `tmpfs`; the runner fails rather than falling back to disk storage.
If either credential is unavailable, no temporary provider config is created
or injected into the child process.
