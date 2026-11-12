"""Role names and role-specific runtime configuration."""

from enum import Enum
import os
from pathlib import Path


class Role(str, Enum):
    IMPLEMENTATION = "implementation"
    QA = "qa"
    PM = "pm"

    @property
    def base_url_secret(self) -> str:
        return f"{self.value.upper()}_SUBAGENT_PROVIDER_BASE_URL"

    @property
    def api_key_secret(self) -> str:
        return f"{self.value.upper()}_SUBAGENT_PROVIDER_API_KEY"

    @property
    def log_directories(self) -> tuple[str, ...]:
        if self is Role.PM:
            return "chat", "stream"
        if self is Role.IMPLEMENTATION:
            return "pytest", "stream"
        return "pytest", "stream"


PROVIDER_ENVIRONMENT_VARIABLES = (
    "COPILOT_PROVIDER_TYPE",
    "COPILOT_PROVIDER_BASE_URL",
    "COPILOT_PROVIDER_API_KEY",
    "COPILOT_PROVIDERS_CONFIGS",
    "LANGUAGE_MODEL_PROVIDER_TYPE",
    "LANGUAGE_MODEL_PROVIDER_BASE_URL",
    "LANGUAGE_MODEL_PROVIDER_API_KEY",
)


def subagent_root(project_root: str | os.PathLike[str]) -> Path:
    return Path(project_root).resolve() / ".subagents"
