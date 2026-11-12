"""Create persistent role files from checked-in subagent templates."""

import json
from pathlib import Path
import shutil

from subagent_roles import Role, subagent_root


TEMPLATE_ROOT = Path(__file__).resolve().parents[1] / "templates" / "subagents"


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


def _copy_role_templates(source: Path, destination: Path) -> list[Path]:
    if not source.is_dir():
        raise FileNotFoundError(f"Subagent template directory not found: {source}")

    created: list[Path] = []
    for template_file in sorted(source.rglob("*")):
        if not template_file.is_file():
            continue
        destination_file = destination / template_file.relative_to(source)
        destination_file.parent.mkdir(parents=True, exist_ok=True)
        try:
            with (
                template_file.open("rb") as source_file,
                destination_file.open("xb") as target_file,
            ):
                shutil.copyfileobj(source_file, target_file)
            mode = (
                0o755
                if destination_file.suffix == ".bash"
                else template_file.stat().st_mode & 0o777
            )
            destination_file.chmod(mode)
        except FileExistsError:
            continue
        created.append(destination_file)
    return created


def scaffold(project_root: str) -> list[Path]:
    """Create missing role configs and scripts without overwriting custom files."""
    root = subagent_root(project_root)
    created: list[Path] = []
    for role in Role:
        for log_directory in role.log_directories:
            (root / role.value / "logs" / log_directory).mkdir(
                parents=True,
                exist_ok=True,
            )
        provider_path = root / role.value / "template" / "providers.json"
        if _write_provider_config(provider_path, role):
            created.append(provider_path)
        created.extend(
            _copy_role_templates(
                TEMPLATE_ROOT / role.value,
                root / role.value,
            )
        )
    return created
