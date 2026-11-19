"""Scaffold persistent role directories and provider configs."""

import json
from pathlib import Path

from subagent_roles import Role, subagent_root


def _provider_config(role: Role) -> dict[str, object]:
    provider_name = f"{role.value}-provider"
    return {
        "providers": [{"name": provider_name, "type": "openai"}],
        "models": [
            {
                "id": f"{role.value}-model",
                "provider": provider_name,
                "maxPromptTokens": 128000,
                "maxOutputTokens": 8192,
            }
        ],
    }


def _write_provider_config(path: Path, role: Role) -> bool:
    path.parent.mkdir(parents=True, exist_ok=True)
    try:
        with path.open("x", encoding="utf-8") as file:
            json.dump(_provider_config(role), file, indent=2)
            file.write("\n")
    except FileExistsError:
        return False
    return True


def scaffold(project_root: str) -> list[Path]:
    """Create missing role directories and provider configs without overwriting files."""
    root = subagent_root(project_root)
    created: list[Path] = []

    for role in Role:
        role_root = root / role.value
        for directory in ("template", "subagent", "tools", "workflows"):
            (role_root / directory).mkdir(parents=True, exist_ok=True)

        for log_directory in role.log_directories:
            (role_root / "logs" / log_directory).mkdir(
                parents=True,
                exist_ok=True,
            )

        provider_path = role_root / "template" / "providers.json"
        if _write_provider_config(provider_path, role):
            created.append(provider_path)

    return created