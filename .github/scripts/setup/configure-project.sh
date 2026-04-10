
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

  mkdir tests && cp .python/test_main.py tests/

  uv add --dev pytest && echo "Pytest Installed as Development Dependency" && uv add --dev ruff && echo "Ruff Installed as Development Dependency"

  if [ $UV_PROJECT_TYPE == '--package' ]; then

    rm "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py" && cp .python/__init__.py src/$(toml get --toml-path pyproject.toml project.name )/  # The default UV init file is pretty useless. Tagging in custom __init__.py file.

    echo "from importlib.metadata import version" >> "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py"

    echo "__version__ = version('$(toml get --toml-path pyproject.toml project.name )')" >> "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py"

    echo "del version" >> "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py"
    
    uv run ruff format "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py"; fi # Format and ensure single quotes are replaced by double quotes.

  uvx easyignore python

  uv tool uninstall toml-cli && echo "TOML CLI removed as UV tool." 

  echo "Project configured."

else

  uv init

  uv add -r requirements.txt

  uv add --dev pytest && echo "Pytest Installed as Development Dependency" && uv add --dev ruff && echo "Ruff Installed as Development Dependency"

  echo "Project configured." ; fi
