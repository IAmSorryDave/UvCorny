# UvCorny 🌽
A UV Project Management Template for Python.

## Quickstart

Clone this template and work with UV out of the ( alpine ) box.
Creating a Codespace will automatically set up your project in the working directory.

### Default Run Arguments

In .devcontainer/.env -

- ```LICENSE_TYPE``` : MIT (See a list of valid licenses and identifiers here 👉 https://spdx.org/licenses/)
- ```UV_LINK_MODE``` : symlink
- ```UV_PROJECT_TYPE``` : --package

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

### Included Development Dependencies

- Pytest
- Ruff

####
