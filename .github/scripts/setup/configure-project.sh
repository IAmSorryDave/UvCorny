if [ ! -f "pyproject.toml" ]; then
  if [ -f "LICENSE" ]; then rm LICENSE ; fi
  if [ -f "README.md" ]; then rm README.md ; fi
fi

uv init $UV_PROJECT_TYPE .

uv tool install toml-cli && echo "TOML CLI added as UV tool."

uv run toml set --toml-path pyproject.toml project.license $LICENSE_TYPE

apk add wget

if [ "$LICENSE_TYPE" = "MIT" ]; then
  wget -O LICENSE https://raw.githubusercontent.com/IAmSorryDave/UvCorny/refs/heads/Setup/LICENSE
else
  wget -O LICENSE https://www.apache.org/licenses/LICENSE-2.0.txt
fi

apk del wget

touch requirements.txt

uv add --dev pytest && echo "Pytest Installed as Development Dependency"

mkdir tests && touch tests/test_main.py
echo "import pytest" >> tests/test_main.py
echo "from $(toml get --toml-path pyproject.toml project.name) import main" >> tests/test_main.py
echo "def test_main():"  >> tests/test_main.py
echo "  assert main() == None" >> tests/test_main.py
echo "Testing directory configured."

uv add --dev ruff && echo "Ruff Installed as Development Dependency"
uv run ruff format tests

echo "Project configured."
