
# These files should be refreshed on every pull / push.
if [ -f "README.md" ]; then rm README.md ; fi 
if [ -f "requirements.txt"]; then rm requirements.txt ; fi

# The absence of a TOML file indicates a project needs to be initialized.
if [ ! -f "pyproject.toml" ]; then

  echo "Configuring project."

  if [ -f "LICENSE" ]; then rm LICENSE ; fi
  if [ -f ".gitignore" ]; then rm .gitignore ; fi

  uv tool install toml-cli && echo "TOML CLI added as UV tool."
  
  uv init $UV_PROJECT_TYPE . && uv run toml set --toml-path pyproject.toml project.license $LICENSE_TYPE

  uv add --dev -r requirements-dev.txt

  case "$UV_PROJECT_TYPE" in '--lib' | '--package')

    rm "src/$(toml get --toml-path pyproject.toml project.name )/__init__.py" && cp .python/templates/__init__.py src/$(toml get --toml-path pyproject.toml project.name )/  # The default UV init file is pretty useless. Tagging in custom __init__.py.

  esac
    
  uvx easyignore python

  uv tool uninstall toml-cli && echo "TOML CLI removed as UV tool." 

  echo "Project configured."

else # It's presence indicates you are resuming work on an existing projec that uses uvcorny.

  uv init

  echo "Project configured." 

fi

uv run pre-commit install
