# UvCorny 🌽
UvCorny is a GitHub template that accelerates Python development with automated, secure releases to both TestPyPI and PyPI.
The template organizes an Alpine Linux Dev container, GitHub Actions/Codespaces, pre-commit, pytest, ruff, and UV into one seemless interface.
It's intended for Black Box, Agentic - Test Driven Development.

## Why Should You Care❓
Software development is changing rapidly. The author wanted to create a framework that could acomplish the following:

- Leverge software agents without ceading total control to the machines.
- With GitHub moving to usage based billing (https://github.blog/news-insights/company-news/github-copilot-is-moving-to-usage-based-billing/) it's never been more important to keep your software agents on track.
- Streamline Python package deployment. In the author's opinion, the easier it is to off load AI capabilites to software, the less risk AI poses.

If UvCorny made your day easier, please consider staring the project, it costs you nothing. It's production required vast amounts of time and attention to detail.

## Quickstart 🚀

1. If you intend to ship a package to pypi, be sure to create accounts on https://test.pypi.org and https://pypi.org. Before you write a line of code, REGISTER YOUR PACKAGE for trusted publishing in both indicies. This will save you headaches. When registering trusted publishing declare pypi-release.yml as your release workflow for PyPi and the candidate.yml workflow for TestPyPi.  The namespace is not claimed until you publish your first release. It's good thing UvCorny deployment is automated...
2. Click on the green use this template box in the top right corner. Do not clone the branch structure.
3. Open a Codespace on the development branch to get started. Before you do so, configure your .env variables and container image (see ONBOARDING.md) on the development branch. This will automatically setup your project. Push the changes back to the development branch.
4. Create “test set” branches off the development branch. As you merge those changes into development, your projects sementic versioning will increment minor and dev. Write only fixtures and test sets on “test set” branches. When you merge changes to the features branch your agent should have all it needs to implement new features, while perserving any old ones. 


### Why Not Configure GitHub Actions to Automatically Setup Your Project When Cloning the Template❓

GitHub does not support users defining ENV variables for Actions and Codespaces on project creation, which is why I have given you the opportunity to modify the devcontainer .env and Dockerfile on the development branch.
That would be a nice feature though, cough cough GitHub.
Let me know if you find a work around. 

### Acknowledgments 🙏

Thank you to all the open source authors that made this project posssible.
I know first hand how hard it is to keep things moving.
