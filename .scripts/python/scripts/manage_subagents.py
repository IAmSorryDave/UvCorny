"""Scaffold and run isolated Copilot CLI subagents."""

import argparse
import os
from pathlib import Path
import subprocess
from collections.abc import Sequence

from subagent_provider_config import temporary_provider_config
from subagent_roles import PROVIDER_ENVIRONMENT_VARIABLES, Role, subagent_root
from subagent_scaffold import scaffold


def _script_path(project_root: str, role: Role, workflow: str | None) -> Path:
    role_root = subagent_root(project_root) / role.value
    if workflow is None:
        script = role_root / "subagent" / "subagent.bash"
    else:
        if Path(workflow).name != workflow:
            raise ValueError(
                "Workflow must be a filename inside the role's workflows directory"
            )
        script = role_root / "workflows" / workflow
    if not script.is_file():
        raise FileNotFoundError(
            f"Script not found: {script}; run the scaffold command first"
        )
    return script


def run_subagent(
    project_root: str,
    role: Role,
    arguments: Sequence[str] = (),
    workflow: str | None = None,
) -> int:
    """Run a role script or workflow in a process with its own provider config."""
    root = Path(project_root).resolve()
    script = _script_path(str(root), role, workflow)
    source_env = os.environ.copy()

    with temporary_provider_config(str(root), role, source_env) as config_path:
        child_env = source_env.copy()
        for configured_role in Role:
            child_env.pop(configured_role.base_url_secret, None)
            child_env.pop(configured_role.api_key_secret, None)
        for variable in PROVIDER_ENVIRONMENT_VARIABLES:
            child_env.pop(variable, None)
        child_env["COPILOT_PROVIDERS_CONFIG"] = str(config_path)
        result = subprocess.run(
            ["bash", str(script), *arguments],
            cwd=root,
            env=child_env,
            check=False,
        )
    return result.returncode


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)

    scaffold_parser = commands.add_parser(
        "scaffold",
        help="create the persistent .subagents tree",
    )
    scaffold_parser.add_argument("project_root", nargs="?", default=".")

    run_parser = commands.add_parser(
        "run",
        help="run one subagent in an isolated process",
    )
    run_parser.add_argument("role", choices=[role.value for role in Role])
    run_parser.add_argument("--project-root", default=".")
    run_parser.add_argument(
        "--workflow",
        help="run a workflow from the role's workflows directory",
    )
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    parser = _build_parser()
    args, script_arguments = parser.parse_known_args(argv)
    if args.command == "scaffold":
        if script_arguments:
            parser.error(f"unrecognized arguments: {' '.join(script_arguments)}")
        created = scaffold(args.project_root)
        output_root = subagent_root(args.project_root)
        print(f"Scaffolded {len(created)} file(s) under {output_root}")
        return 0

    role = Role(args.role)
    if script_arguments and script_arguments[0] == "--":
        script_arguments = script_arguments[1:]
    return run_subagent(
        args.project_root,
        role,
        script_arguments,
        workflow=args.workflow,
    )


if __name__ == "__main__":
    raise SystemExit(main())
