import importlib
import importlib.metadata
import pathlib
import pkgutil
from tomllib import load

__all__ = []

# Get the parent package name.
parent_package = __name__.rsplit(".", 1)[0]
package_dir = pathlib.Path(__file__).parent

# Discover and import all modules recursively.
for _importer, module_label, _is_package in pkgutil.walk_packages(
    path=[str(package_dir)], prefix=f"{parent_package}."
):
    if module_label == __name__ or module_label.startswith(f"{parent_package}._"):
        continue

    try:
        module = importlib.import_module(module_label)
    except ImportError:
        continue

    if hasattr(module, "__all__"):
        module_variable_list = module.__all__
    else:
        module_variable_list = [
            attribute_label
            for attribute_label in dir(module)
            if not attribute_label.startswith("_")
        ]

    for attribute_label in module_variable_list:
        if str(attribute_label).startswith("_"):
            continue
        globals()[attribute_label] = getattr(module, attribute_label)
        if attribute_label not in __all__:
            __all__.append(attribute_label)

# Grab __version__ from installed metadata if available, otherwise from pyproject.
try:
    __version__ = importlib.metadata.version(package_dir.stem)
except importlib.metadata.PackageNotFoundError:
    project_toml = package_dir.parent / "pyproject.toml"
    try:
        with project_toml.open("rb") as configuration_file:
            configuration = load(configuration_file)
        __version__ = configuration.get("project", {}).get("version", "0.0.0")
    except FileNotFoundError, OSError, TypeError, ValueError:
        __version__ = "0.0.0"

if "__version__" not in __all__:
    __all__.append("__version__")
