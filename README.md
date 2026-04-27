# UvCorny 🌽
UvCorny is a GitHub template that accelerates Python package development with automated, secure releases to both TestPyPI and PyPI.
The template combines Alpine Linux, GitHub Actions, pre-commit, and UV into one seemless interface.
It's intended for AI - Test Driven Development. 

## Quickstart

1. Click on the green use this template box in the top right corner. Be sure to clone the entire branch structure.
2. Opening a Codespace on any branch will automatically setup your project.

### Recommended Development Path
```
fixtures branch
    ↓ (new fixtures)
tests branch → (merge fixtures)
    ↓ (new tests)
features branch → (merge tests) → (write implementation with AI)
    ↓ (feature commit)
development branch → [CI/CD] → TestPyPI → PyPI
```

### Default Run Arguments

In .devcontainer/.env -

- ```LICENSE_TYPE``` : MIT (See a list of valid licenses and identifiers here 👉 https://spdx.org/licenses/)
- ```UV_LINK_MODE``` : symlink
- ```UV_PROJECT_TYPE``` : --lib

### Dockerfile

```
ARG PYTHON_VERSION=3.12
ARG IMAGE=ghcr.io/astral-sh/uv:python${PYTHON_VERSION}-alpine

FROM $IMAGE
```
See https://docs.astral.sh/uv/guides/integration/docker/ for a list of available alpine images.

### ENVIRONMENTAL VARIABLES

The Alpine UV image does not have git configured by default.
While git is installed automatically you still need to set your... 

- DEVELOPER : Your GitHub username.
- DEVELOPER_EMAIL : Your Github email.

in your Codespace secret store for git to work properly.

####
