#!/bin/sh

IMPORT_STYLE=${IMPORT_STYLE:-package}

case "$IMPORT_STYLE" in
  package|subpackage|star) ;;
  *)
    echo "Invalid IMPORT_STYLE '$IMPORT_STYLE'. Choose package, subpackage, or star." >&2
    exit 1
    ;;
esac

# The absence of a TOML file indicates a project needs to be initialized.
if [ ! -f "pyproject.toml" ]; then

  echo "Configuring project."

  if [ -f "LICENSE" ]; then rm LICENSE ; fi
  if [ -f ".gitignore" ]; then rm .gitignore ; fi

  uv init $UV_PROJECT_TYPE . && uvx --from toml-cli toml set --toml-path pyproject.toml project.license $LICENSE_TYPE
  PACKAGE_NAME=$(uvx --from toml-cli toml get --toml-path pyproject.toml project.name | tr '-' '_')
  printf '\n[tool.%s]\nimport_style = "%s"\n' "$PACKAGE_NAME" "$IMPORT_STYLE" >> pyproject.toml

  uv version 0.0.0

  case "$UV_PROJECT_TYPE" in '--lib' | '--package')

    rm src/$(uvx --from toml-cli toml get --toml-path pyproject.toml project.name )/__init__.py && cp .scripts/python/templates/__init__.py src/$(uvx --from toml-cli toml get --toml-path pyproject.toml project.name )/ && cp .scripts/python/templates/_loader.py src/$(uvx --from toml-cli toml get --toml-path pyproject.toml project.name )/  # The default UV init file is pretty useless. Tagging in custom __init__.py.
    sed -i "s/^IMPORT_STYLE = .*/IMPORT_STYLE = \"$IMPORT_STYLE\"/" src/$(uvx --from toml-cli toml get --toml-path pyproject.toml project.name )/_loader.py

  esac

  uvx easyignore python

  echo "Project configured."

else # It's presence indicates you are resuming work on an existing project that uses uvcorny.

  uv init ; fi
