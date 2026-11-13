"""Build isolated, memory-only Copilot provider configurations."""

from collections.abc import Iterator, Mapping
from contextlib import contextmanager
import json
import os
from pathlib import Path
import shutil
import stat
import tempfile

from subagent_roles import Role, subagent_root


def _load_role_provider(path: Path) -> tuple[dict[str, object], dict[str, object]]:
    try:
        with path.open(encoding="utf-8") as file:
            config = json.load(file)
    except (OSError, json.JSONDecodeError) as error:
        raise ValueError(f"Unable to read provider config {path}: {error}") from error

    if not isinstance(config, dict):
        raise ValueError(f"Provider config {path} must contain a JSON object")
    providers = config.get("providers")
    if not isinstance(providers, list) or len(providers) != 1:
        raise ValueError(
            f"Provider config {path} must contain exactly one provider "
            "for this role's endpoint secrets"
        )
    provider = providers[0]
    if not isinstance(provider, dict):
        raise ValueError(f"Provider entry in {path} must be a JSON object")
    if not isinstance(provider.get("name"), str) or not provider["name"]:
        raise ValueError(f"Provider entry in {path} must have a non-empty 'name'")
    if "baseUrl" in provider or "apiKey" in provider:
        raise ValueError(
            f"Remove baseUrl and apiKey from {path}; provide them using runtime secrets"
        )
    return config, provider


def _resolve_endpoint_credentials(
    role: Role,
    environ: Mapping[str, str],
) -> tuple[str | None, str | None]:
    base_url = (
        environ.get(role.base_url_secret)
        or environ.get("COPILOT_PROVIDER_BASE_URL")
        or None
    )
    api_key = (
        environ.get(role.api_key_secret)
        or environ.get("COPILOT_PROVIDER_API_KEY")
        or None
    )
    return base_url, api_key


def _require_memory_filesystem() -> Path:
    memory_root = Path("/dev/shm")
    if not memory_root.is_dir() or not os.access(memory_root, os.W_OK | os.X_OK):
        raise RuntimeError(
            "A writable /dev/shm is required for memory-only provider configs"
        )
    try:
        mounts = Path("/proc/mounts").read_text(encoding="utf-8").splitlines()
    except OSError as error:
        raise RuntimeError("Unable to verify that /dev/shm is memory-backed") from error

    for line in mounts:
        fields = line.split()
        if (
            len(fields) >= 3
            and fields[1].replace("\\040", " ") == str(memory_root)
            and fields[2] == "tmpfs"
        ):
            return memory_root
    raise RuntimeError(
        "/dev/shm must be mounted as tmpfs for memory-only provider configs"
    )


@contextmanager
def temporary_provider_config(
    project_root: str,
    role: Role,
    environ: Mapping[str, str] | None = None,
) -> Iterator[Path]:
    """Yield a role-specific config with secrets added in a read-only tmpfs file."""
    source_env = os.environ if environ is None else environ
    provider_path = (
        subagent_root(project_root) / role.value / "template" / "providers.json"
    )
    config, provider = _load_role_provider(provider_path)
    base_url, api_key = _resolve_endpoint_credentials(role, source_env)
    if base_url:
        provider["baseUrl"] = base_url
    if api_key:
        provider["apiKey"] = api_key

    temporary_directory = Path(
        tempfile.mkdtemp(
            prefix=f"uvcorny-{role.value}-", dir=_require_memory_filesystem()
        )
    )
    runtime_path = temporary_directory / "providers.json"
    try:
        with runtime_path.open("x", encoding="utf-8") as file:
            json.dump(config, file, separators=(",", ":"))
            file.write("\n")
        runtime_path.chmod(stat.S_IRUSR)
        temporary_directory.chmod(stat.S_IRUSR | stat.S_IXUSR)
        yield runtime_path
    finally:
        temporary_directory.chmod(stat.S_IRUSR | stat.S_IWUSR | stat.S_IXUSR)
        shutil.rmtree(temporary_directory)
