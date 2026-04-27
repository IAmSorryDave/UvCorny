# UvCorny 🌽
UvCorny is a GitHub template that accelerates Python package development with automated, secure releases to both TestPyPI and PyPI.
The template combines Alpine Linux, GitHub Actions/Codespaces, pre-commit, and UV into one seemless interface.
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

### Step-by-Step: From Fixture to Production

1. Create Fixtures (fixtures branch)
- Develop test fixtures and mock data structures
- Document expected data formats
- Commit to `fixtures` branch
      
2. Write Tests (tests branch)
- Merge new `fixtures` from fixtures branch
- Write test cases using those fixtures
- Keep tests aligned with the contract you want features to fulfill
- Commit to `tests` branch

3. Implement Features (features branch)
- Merge tests from `tests` branch
- Use AI tools (GitHub Copilot, Claude, etc.) to generate feature implementations
- AI can see your tests and generate code that satisfies them
- All features ship on passing tests
- Commit to `features` branch
  
4. Release (development branch)
- Merge your feature branch into `development`
- CI/CD pipeline automatically:
    - Runs full test suite
    - Creates a release candidate
    - Deploys to TestPyPI for validation
    - Deploys to PyPI for production release

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
