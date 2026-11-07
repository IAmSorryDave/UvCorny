import pytest


@pytest.fixture
def project_directory_path():
    from pathlib import Path

    return Path(__file__).parent.parent


@pytest.fixture
def project_configuration(project_directory_path):
    from tomllib import load

    with open(project_directory_path / "pyproject.toml", "rb") as f:
        configuration = load(f)
    return configuration


@pytest.fixture
def project_metadata(project_configuration):
    return project_configuration.get("project")


@pytest.fixture
def project_name(project_metadata):
    return project_metadata.get("name")
