from enum import Enum
import pytest


class ProjectEnvironmentVariable(str, Enum):
    UV_LINK_MODE = "UV_LINK_MODE"
    LICENSE_TYPE = "LICENSE_TYPE"
    UV_PROJECT_TYPE = "UV_PROJECT_TYPE"
    IMPORT_STYLE = "IMPORT_STYLE"
    PYTHON_VERSION = "PYTHON_VERSION"


class ImportStyle(str, Enum):
    PACKAGE = "package"
    SUBPACKAGE = "subpackage"
    STAR = "star"


@pytest.fixture
def project_import_style():
    from os import environ

    import_style = environ.get(
        ProjectEnvironmentVariable.IMPORT_STYLE, ImportStyle.PACKAGE
    )
    try:
        return ImportStyle(import_style)
    except ValueError as error:
        raise ValueError(
            f"Unsupported {ProjectEnvironmentVariable.IMPORT_STYLE} {import_style!r}. "
            f"Choose one of: {', '.join(style.value for style in ImportStyle)}."
        ) from error


@pytest.fixture
def adaptive_importer(project_name, project_import_style):
    from importlib import import_module

    def adaptive_import(module_name=None, object_name=None, mandatory_import=False):
        importer = import_module if mandatory_import else pytest.importorskip

        if project_import_style is ImportStyle.STAR:
            module = importer(project_name)
            if object_name is not None:
                return getattr(module, object_name)
            return module

        if module_name is None:
            module = importer(project_name)
        else:
            module = importer(f"{project_name}.{module_name}")
        if object_name is not None:
            return getattr(module, object_name)
        return module

    return adaptive_import


@pytest.fixture
def feature_name():
    from pathlib import Path
    return Path(__file__).parent.name

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
