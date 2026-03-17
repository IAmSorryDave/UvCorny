if [ ! -f "pyproject.toml" ]; then
  if [ -f "LICENSE" ]; then rm LICENSE fi
  if [ -f "README.md" ]; then rm README.md fi
  if [ -f ".gitignore" ]; then rm .gitignore fi
fi

uv init $UV_PROJECT_TYPE .

uv tool install toml-cli && echo "TOML CLI added as UV tool."

uv add --dev pytest && echo "Pytest Installed as Development Dependency"

mkdir tests && touch tests/test_main.py
echo "import pytest" >> tests/test_main.py
echo "from $(toml get --toml-path pyproject.toml project.name) import main" >> tests/test_main.py
echo "def test_main():"  >> tests/test_main.py
echo "  assert main() == None" >> tests/test_main.py

uv add --dev ruff && echo "Ruff Installed as Development Dependency"
uv run ruff format tests
uv run pytest tests/test_main.py::test_main
echo "Project Configured."
