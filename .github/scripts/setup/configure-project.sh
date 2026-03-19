
uv tool install toml-cli && echo "TOML CLI added as UV tool."

if [ ! -f "pyproject.toml" ]; then
  if [ -f ".gitignore" ]; then rm .gitignore ; fi
  if [ -f "README.md" ]; then rm README.md ; fi
  if [ -f "LICENSE" ]; then rm LICENSE ; fi
  uv init $UV_PROJECT_TYPE . --vcs git 
  uv run toml set --toml-path pyproject.toml project.description "Hello world, this my cool app!"
  uv run toml set --toml-path pyproject.toml project.license $LICENSE_TYPE
fi

if [ ! -f "requirements.txt" ]; then
  touch requirements.txt && uv add -r requirements.txt
fi

uv add --dev pytest && echo "Pytest Installed as Development Dependency"

mkdir tests && touch tests/test_main.py
echo "import pytest" >> tests/test_main.py
echo "from $(toml get --toml-path pyproject.toml project.name) import main" >> tests/test_main.py

uv add --dev ruff && echo "Ruff Installed as Development Dependency"
uv run ruff format tests

echo "Project configured."
