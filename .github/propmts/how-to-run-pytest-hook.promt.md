---
name: how-to-run-pytest-hook.md
description: How to run the pytest test hook for this project.
---

<!-- Tip: Use /create-prompt in chat to generate content with agent assistance -->

The pytest hook can be run in one of two ways.

1. ```pre-commit run pytest --all-files``` Runs all tests whether or not files have changed. Use this command to evaluate what tests need to pass in order to implement features.

2. Commiting changed files. The pytest hook will be invoked automatically when commiting changes. You do not need to run a seperate command when commiting changes.
