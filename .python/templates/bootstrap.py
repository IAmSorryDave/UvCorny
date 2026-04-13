from pkgutil import walk_packages
from importlib import import_module
from pathlib import Path

# Discover and import all modules recursively
for importer, module_label, this_is_a_package in walk_packages(
    path=[str(Path(__file__).parent)],
    prefix=__name__ + '.'
):
    try:
        module = import_module(module_label)
        # Import all public objects from the module into this namespace
        for attribute_label in dir(module):
            if not attribute_label.startswith('_'):
                globals()[attribute_label] = getattr(module, attribute_label)
    except ImportError as e:
        print(f"Failed to import {module_label}: {e}")

del import_module, Path, walk_packages
