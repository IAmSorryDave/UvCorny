from importlib.metadata import version
from pkgutil import walk_packages
from importlib import import_module
from pathlib import Path

__all__ = []

# Get the parent package name
parent_package = __name__.rsplit(".", 1)[0]
package_dir = Path(__file__).parent

# Discover and import all modules recursively
for importer, module_label, this_is_a_package in walk_packages(
    path=[str(package_dir)], prefix=parent_package + "."
):
    # Skip the _loader module itself to avoid circular imports
    if module_label == __name__:
        continue

    try:
        module = import_module(module_label)
        # Import all public objects from the module into this namespace
        for attribute_label in dir(module):
            if not attribute_label.startswith("_"):
                globals()[attribute_label] = getattr(module, attribute_label)
                __all__.append(attribute_label)
    except ImportError as e:
        print(f"Failed to import {module_label}: {e}")

# Grab __version__
__version__ = version(Path.cwd().name.lower())
__all__.append("__version__")

del import_module, Path, walk_packages, version
