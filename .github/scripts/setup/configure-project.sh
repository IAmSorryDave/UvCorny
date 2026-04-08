
if [ ! -f "pyproject.toml" ]; then

  echo "Configuring project."

  uv tool install toml-cli && echo "TOML CLI added as UV tool."

  if [ -f "README.md" ]; then rm README.md ; fi
  if [ -f "LICENSE" ]; then rm LICENSE ; fi
  if [ -f ".gitignore" ]; then rm .gitignore ; fi
  
  uv init $UV_PROJECT_TYPE . && uv run toml set --toml-path pyproject.toml project.description "Hello world, this is my cool project." && uv run toml set --toml-path pyproject.toml project.license $LICENSE_TYPE

  if [ ! -f "requirements.txt" ]; then touch requirements.txt ; fi

  uv add -r requirements.txt

  echo "# $(toml get --toml-path pyproject.toml project.name ) " >> README.md && echo $(toml get --toml-path pyproject.toml project.description ) >> README.md

  mkdir tests && touch tests/test_main.py && echo "import pytest" >> tests/test_main.py && echo "from $(toml get --toml-path pyproject.toml project.name) import main" >> tests/test_main.py

  uv add --dev pytest && echo "Pytest Installed as Development Dependency" && uv add --dev ruff && echo "Ruff Installed as Development Dependency"

  if [ $UV_PROJECT_TYPE == '--package' ]; then

    echo "from importlib.metadata import version" >> "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py"

    echo "__version__ = version('$(toml get --toml-path pyproject.toml project.name )')" >> "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py"

    echo "del version" >> "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py"

    echo "from importlib import import_module" >> "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py"

    echo "from pathlib import Path" >> "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py"

    echo "from pathlib import Path" >> "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py"

    echo "for f in Path(__file__).parent.glob('*.py'):" >> "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py"

    echo "  module_name = f.stem" >> "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py"

    echo "  if (not module_name.startswith('_')) and (module_name not in globals()):" >> "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py"

    echo "    import_module(f'.{module_name}', __package__)" >> "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py"

    echo "  del f, module_name" >> "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py"

    echo "del import_module, Path" >> "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py" ; fi

  uvx easyignore python

  uv tool uninstall toml-cli && echo "TOML CLI removed as UV tool." 

  echo "Project configured."

else

  uv init

  uv add -r requirements.txt

  uv add --dev pytest && echo "Pytest Installed as Development Dependency" && uv add --dev ruff && echo "Ruff Installed as Development Dependency"

  echo "Project configured."
  
fi
