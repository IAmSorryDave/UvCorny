
# These files should be refreshed on every pull / push.
if [ -f "README.md" ]; then rm README.md ; fi 
if [ -f "requirements.txt"]; then rm requirements.txt ; fi

uv add --dev -r requirements-dev.txt

uv run pre-commit install

if [ ! -f "pyproject.toml" ]; then

  echo "Configuring project."

  uv tool install toml-cli && echo "TOML CLI added as UV tool."

  if [ -f "LICENSE" ]; then rm LICENSE ; fi
  if [ -f ".gitignore" ]; then rm .gitignore ; fi
  
  uv init $UV_PROJECT_TYPE . && uv run toml set --toml-path pyproject.toml project.license $LICENSE_TYPE

  case "$UV_PROJECT_TYPE" in '--lib' | '--package')

    rm "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py" && cp .python/__init__.py src/$(toml get --toml-path pyproject.toml project.name )/  # The default UV init file is pretty useless. Tagging in custom __init__.py file.

    echo "from importlib.metadata import version" >> "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py"

    echo "__version__ = version('$(toml get --toml-path pyproject.toml project.name )')" >> "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py"

    echo "del version" >> "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py"
    
    uv run ruff format "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py" ;; # Format and ensure single quotes are replaced by double quotes.

  esac
    
  uvx easyignore python

  uv tool uninstall toml-cli && echo "TOML CLI removed as UV tool." 

  echo "Project configured."

else

  uv init

  echo "Project configured." ; fi
