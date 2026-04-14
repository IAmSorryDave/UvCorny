from importlib.metadata import version
from pkgutil import walk_packages
from importlib import import_module
from pathlib import Path
#from tomllib import load as load_toml_configuration

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

# def get_project_name(maxium_traversed_directories = 3) -> str:
#     """Get the project name by finding pyproject.toml and reading it."""
#     # Start from the current file's location and walk up
#     current_dir, traversed_directories = Path.cwd(), 0
    
#     while traversed_directories < maxium_traversed_directories:
#         traversed_directories += 1
#         pyproject = current_dir / "pyproject.toml"
        
#         if pyproject.exists():
#             with open(pyproject, "rb") as f:
#                 data = load_toml_configuration(f)
#                 project_metadata = data.get("project", None)
#                 if project_metadata:
#                     project_name = project_metadata.get("name", None)
#                     if project_name:
#                         return project_name
        
#         current_dir = current_dir.parent
    
#     raise FileNotFoundError(f"Could not find pyproject.toml within {maxium_traversed_directories} working and parent directories")

__version__ = version(Path.cwd().name.lower())

del import_module, Path, walk_packages, version
# Customize your definitions here-after.
