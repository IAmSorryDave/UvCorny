import pytest
import os  # Always import the os module at the top level. Doing otherwise will cause unexpected behavior.


@pytest.fixture
def curent_working_directory_path():
    from pathlib import Path

    return Path(os.getcwd())


@pytest.fixture
def project_configuration(curent_working_directory_path):
    from tomllib import load

    with open(curent_working_directory_path / "pyproject.toml", "rb") as f:
        configuration = load(f)
    return configuration


@pytest.fixture
def project_metadata(project_configuration):
    return project_configuration.get("project")


@pytest.fixture
def project_name(project_metadata):
    return project_metadata.get("name")
