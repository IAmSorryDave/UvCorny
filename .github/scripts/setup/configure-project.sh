
uv tool install toml-cli && echo "TOML CLI added as UV tool."

if [ ! -f "pyproject.toml" ]; then
  uv init $UV_PROJECT_TYPE . --force
  uv run toml set --toml-path pyproject.toml project.license $LICENSE_TYPE
fi


# apk add wget

#if [ "$LICENSE_TYPE" = "MIT" ]; then
#  wget -O LICENSE https://raw.githubusercontent.com/IAmSorryDave/UvCorny/refs/heads/Setup/LICENSE
# else
#  wget -O LICENSE https://www.apache.org/licenses/LICENSE-2.0.txt
#fi

# apk del wget

if [ ! -f "requirements.txt" ]; then
  touch requirements.txt && uv add -r requirements.txt
fi

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
