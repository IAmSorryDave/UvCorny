
from pkgutil import walk_packages
from importlib import import_module
from pathlib import Path

# Get the current package's path
package_path = Path(__file__).parent

# Discover and import all modules recursively
for importer, modname, ispkg in walk_packages(
    path=[str(package_path)],
    prefix=__name__ + '.'
):
    try:
        import_module(modname)
    except ImportError as e:
        print(f"Failed to import {modname}: {e}")
