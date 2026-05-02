# UvCorny 🌽
UvCorny is a GitHub template that accelerates Python package development with automated, secure releases to both TestPyPI and PyPI.
The template combines Alpine Linux, GitHub Actions/Codespaces, pre-commit, and UV into one seemless interface.
It's intended for AI - Test Driven Development. 

## Quickstart

1. If you intend to ship a package to pypi, be sure to create accounts on https://test.pypi.org and https://pypi.org. Before you write a line of code, REGISTER YOUR PACKAGE for trusted publishing in both indicies. This will save you headaches.
2. Click on the green use this template box in the top right corner. Be sure to clone the entire branch structure. You are of course welcome to clone only the main branch. However, this doing so does not garentee UvCorny's GitHub Actions workflows will work as intended. Please consult .github/workflows when structuring your branches.
3. Opening a Codespace on any branch will automatically setup your project.

### Recommended Development Path
```
development branch
    ↓ (new tests / fixtures)
features branch → (write implementation with AI)
    ↓ (new feature) → spawns potential beta
                            ↓                     
                        beta-nth branch
                            ↓ (merge)
                        canidate branch → spawns potential release canidate → TestPyPI → PyPI
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
- ```UV_LINK_MODE``` : symlink ( This setting is the least noisy link mode when working in a codespace. If required, adapt this setting to your needs. )
- ```UV_PROJECT_TYPE``` : --lib ( Must be one of --app, --lib, --package. See https://docs.astral.sh/uv/concepts/projects/init/#libraries for more on project setup)

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
- DEVELOPER_EMAIL : Your Github email. ( You may want to consider making your email private. See: https://github.com/settings/emails )

in your Codespace secret store for git to work properly.

### pre-commit Hooks

By default, UvCorny calls official sync, lock, and export Astral hooks.
Offical Ruff hooks are also built in for formatting and code style standardization.

Two custom hooks are added by defualt.

- Cristopher Meissner's pytest-pre-commit (https://github.com/christophmeissner/pytest-pre-commit) is modified to allow the pytest hook to pass on the absence of tests. This let's you add fixtures and features independently of tests. By default this hook is disabled when pushing to the test branch, which is necessary if there's no data to test against. Finally there's a .sh/scripts/append_requirements.sh script which on codespace creation, appends the '-r' flag and absolute path of the exported requirements.txt to the additional_dependencies pytest hook attribute. This has the net effect of recreating your projects dependencies in an isolated test enviroment upon runing the pytest hook.
  
- A custom hook which automatially updates your README.md title and description according to the title and description in the pyproject.toml. Thus you should not edit your README.md directly but rather the README.md.jinja file.

If you are not familar with pre-commit, any files modified by hooks will cause the hook to fail and block the commit. This ensures you double check any modifications before commitng to them. 
By combining these hooks together, you can reduce the need to add these steps to your CI/CD workflows.

You are free to modify the pre-commit configuration to your liking.
However if you choose to do so, do not remove the pytest hook. No tests are required of you, but removing this hook will cause UvCorny to break.
Furthermore, do not edit the pre-commit configuration in a codespace! This also risks breaking UvCorny.
Any modifications to the configuration should be made from the web editor.

### Creating Pytests

```
import pytest


@pytest.fixture
def resilient_import():
    try:
        from uvcornyalpha import my_object

        return my_object
    except Exception:
        return None  # or some default mock object


def test_with_fallback(resilient_import):
    if resilient_import is None:
        pytest.skip("Import unavailable")
    assert resilient_import == "foo"
```

####
