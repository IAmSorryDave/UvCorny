import pkgutil
import importlib
import importlib.metadata
import pathlib

__all__ = list()

# Get the parent package name
parent_package = __name__.rsplit(".", 1)[0]
package_dir = pathlib.Path(__file__).parent

# Discover and import all modules recursively
for importer, module_label, this_is_a_package in pkgutil.walk_packages(
    path=[str(package_dir)], prefix=parent_package + "."
):
    # Skip the _loader module itself to avoid circular imports
    if module_label == __name__:
        continue

    try:
        module = importlib.import_module(module_label)
        if hasattr(module, "__all__"):
            module_variable_list = (
                module.__all__
            )  # Import only __all__ objects from the module into this namespace
        else:
            module_variable_list = dir(
                module
            )  # Import all public objects from the module into this namespace
        for attribute_label in module_variable_list:
            if not attribute_label.startswith("_"):
                globals()[attribute_label] = getattr(module, attribute_label)
                __all__.append(attribute_label)
    except ImportError as e:
        print(f"Failed to import {module_label}: {e}")

# Grab __version__
__version__ = importlib.metadata.version(pathlib.Path(__file__).parent.stem)
__all__.append("__version__")
