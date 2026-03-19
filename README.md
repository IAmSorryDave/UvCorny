# UvCorny 🌽
A UV Project Management Template for Python.

## Quickstart

Clone this template and work with UV out of the ( alpine ) box.
Creating a Codespace will automatically set up your project in the working directory with UV.

### Default Build Arguments

In .devcontainer/Dockerfile -

- LICENSE : MIT (See a list of valid licenses and identifiers here 👉 https://spdx.org/licenses/)
- LINK_MODE : symlink
- PROJECT_TYPE : --package
- PYTHON_VERSION : 3.12

### ENVIRONMENTAL VARIABLES

The Alpine UV image does not have git configured by default.
While git is installed automatically you still need to set your... 

- DEVELOPER : Your GitHub username.
- DEVELOPER_EMAIL : Your Github email.

in your Codespace secret store for git to work properly.

### Included Development Dependencies

- Pytest
- Ruff

####
