# UvCorny 🌽
UvCorny is a GitHub template that accelerates Python development with automated, secure releases to both TestPyPI and PyPI.
The template organizes an Alpine Linux Dev container, GitHub Actions/Codespaces, pre-commit, pytest, ruff, and UV into one seemless interface.
It's intended for Black Box - Test Driven Development.

## Why Should You Care❓
Software development is changing rapidly. The author wanted to create a framework that could acomplish the following:

- Leverge software agents without ceading total control to the machines. With GitHub moving to usage based billing (https://github.blog/news-insights/company-news/github-copilot-is-moving-to-usage-based-billing/) it's never been more important to keep your software agents on track.
- Streamline Python package deployment. In the author's opinion, the easier it is to off load AI capabilites to software, the less risk AI poses.

If UvCorny made your day easier, please consider staring the project, it costs you nothing. It's production required vast amounts of time and attention to detail.

## Quickstart 🚀

1. If you intend to ship a package to pypi, be sure to create accounts on https://test.pypi.org and https://pypi.org. Before you write a line of code, REGISTER YOUR PACKAGE for trusted publishing in both indicies. This will save you headaches. The namespace is not claimed until you publish your first release. It's good thing UvCorny deployment is automated...
2. Click on the green use this template box in the top right corner.
3. Open a Codespace on the development branch to get started. Before you do so, configure your .env variables and container image (see below) on the development branch. This will automatically setup your project. Push the changes back to the development branch. Then create experiment branches off the development branch. As you merge those changes into development, your projects sementic versioning will increment minor and dev. Write only fixtures and test sets on experiment branches. When you merge changes to the features branch your agent should have all it needs to implement new features, while perserving any old ones. 

### Recommended Development Path 🚗
```
nth test set branch
    ↓ (merge new tests / fixtures)
    ↓ (increment minor) 
development branch             
    ↓ (merge changes)                                                          
    ↓ (increment alpha)                                                        
features branch ← (push new feature) ← (write implementation with AI)          
    ↓ (tests pass)
    ↓ (increment beta)
beta branch
    ↓ 
spawns stable branch, the nth beta
    ↓ (merge changes)
    ↓ (increment release canidate)
candidate branch → (spawns release canidate branch) → Auto-Deploy to TestPyPI → Deploy to PyPI → (merge changes) → main
    ↑            → → (spawns hotfix branch)
(increment patch)            ↓
    ↑                        ↓
(merge changes)              ↓
    ↑                        ↓
hotfix branch ← (merge new patch if necessary)
```

### Default Run Arguments 🏃‍♀️

In .devcontainer/.env -

- ```LICENSE_TYPE``` : MIT (See a list of valid licenses and identifiers here 👉 https://spdx.org/licenses/)
- ```UV_LINK_MODE``` : symlink ( This setting is the least noisy link mode when working in a codespace. If required, adapt this setting to your needs. )
- ```UV_PROJECT_TYPE``` : --lib ( Must be one of --app, --lib, --package. See https://docs.astral.sh/uv/concepts/projects/init/#libraries for more on project setup)

### Dev Container Dockerfile 🐳

```dockerfile
ARG PYTHON_VERSION=3.14
ARG IMAGE=ghcr.io/astral-sh/uv:python${PYTHON_VERSION}-alpine

FROM $IMAGE
```
See https://docs.astral.sh/uv/guides/integration/docker/ for a list of available alpine images.

### Dev Container ENVIRONMENTAL VARIABLES ❎

The Alpine UV image does not have git configured by default.
While git is installed automatically you still need to set your... 

- DEVELOPER : Your GitHub username.
- DEVELOPER_EMAIL : Your Github email. ( You may want to consider making your email private. See: https://github.com/settings/emails )

in your Codespace secret store for git to work properly.

### pre-commit Hooks 🪝

By default, UvCorny calls official sync, lock, and export Astral hooks.
Offical Ruff hooks are also built in for formatting and code style standardization.

Two custom hooks are added by defualt.

- Cristopher Meissner's pytest-pre-commit (https://github.com/christophmeissner/pytest-pre-commit) is modified to allow the pytest hook to
a. Pass on the absence of tests.
b. On codespace creation, a script appends the '-r' flag and absolute path of the exported requirements.txt to the additional_dependencies pytest hook attribute. This has the net effect of recreating your projects dependencies in an isolated test enviroment upon runing the pytest hook.
  
- A custom hook which automatially updates your README.md title and description according to the title and description in the pyproject.toml. Thus you should not edit your README.md directly but rather the README.md.jinja file this hook relies on.

If you are not familar with pre-commit, any files modified by hooks will cause the hook to fail and block the commit. This ensures you double check any modifications before commitng to them. 
By combining these hooks together, you can reduce the need to add these steps to your CI/CD workflows.

You are free to modify the pre-commit configuration to your liking.
However if you choose to do so, do not remove the pytest hook. No tests are required of you, but removing this hook will cause UvCorny to break.

Furthermore, do not edit the pre-commit configuration in a codespace! This also risks breaking UvCorny.
Any modifications to the configuration should be made from the web editor.

### Creating Pytests 🧪

Tests should be writen before code. 
UvCorny automatically generates a conftest.py file which furnishes project metadata fixtures.

```python
import pytest


@pytest.fixture
def project_directory_path():
    from pathlib import Path

    return Path(__file__).parent.parent


@pytest.fixture
def project_configuration(project_directory_path):
    from tomllib import load

    with open(project_directory_path / "pyproject.toml", "rb") as f:
        configuration = load(f)
    return configuration


@pytest.fixture
def project_metadata(project_configuration):
    return project_configuration.get("project")


@pytest.fixture
def project_name(project_metadata):
    return project_metadata.get("name")

```

With these fixtures you could write a test called 'test_main.py'

```python
import pytest
from pathlib import Path


@pytest.fixture
def main_module_label(project_name):
    return f"{project_name}.{Path(__file__).parent.name}.main"


@pytest.fixture
def main_fn(main_module_label):
    return pytest.importorskip(main_module_label)


def test_main(main_fn):
    assert main_fn() is None

```

Your main function may not even exist, but that's the point!
Wrting this test tells your software agent a main function should exist and it's return value should be 'None'.
Nor do you need to implement this feature right away, you can delay it's implementation untill you have merged your tests into the feature branch.
This can be acomplished by leveraging pytest's importorskip fuction, as seen in the example above.

When implementing a new feature, create a new test set folder like so...
```markdown
\tests
   |
\new-feature-folder
   |
__init__.py
test_1_needed_to_implement_feature.py
test_2_needed_to_implement_feature.py
...
```

Copilot is prompted to create features like so...
```markdown
\src
   |
\your-cool-package
   |
__init__.py
_loader.py
\your-new-feature
  ...
```

This ensures a one to one mapping between test sets and features.

### Prompts 💬

There are two defualt prompts under ```.github/prompts/```.
These add relevant context to CoPilot specific to UvCorny.
Add or subtract as needed.

### Why Not Configure GitHub Actions to Automatically Setup Your Project When Cloning the Template❓

GitHub does not support users defining ENV variables for Actions and Codespaces on project creation, which is why I have given you the opportunity to modify the devcontainer .env and Dockerfile on the development branch.
That would be a nice feature though, cough cough GitHub.
Let me know if you find a work around. 

### Acknowledgments 🙏

Thank you to all the open source authors that made this project posssible.
I know first hand how hard it is to keep things moving.

####
