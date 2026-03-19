
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
  
  uvx easyignore python

  mkdir tests && touch tests/test_main.py && echo "import pytest" >> tests/test_main.py && echo "from $(toml get --toml-path pyproject.toml project.name) import main" >> tests/test_main.py

  uv add --dev pytest && echo "Pytest Installed as Development Dependency" && uv add --dev ruff && echo "Ruff Installed as Development Dependency"

  uv tool uninstall toml-cli && echo "TOML CLI removed as UV tool."

  echo "Project configured."
  
fi
