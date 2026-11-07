---
name: implement-feature
description: Use this prompt when implementing a feature defined in the tests folder.
---

<!-- Tip: Use /create-prompt in chat to generate content with agent assistance -->

Implement features defined by the tests in the ```tests``` folder. Read repository files as needed, but make changes only inside ```src/```. Do not create or modify files elsewhere. The only command you may run is ```bash main.bash``` from the repository root; use it to check your work and, if necessary, adjust the code in ```src/``` until all tests pass. Do not skip or fail tests. Alert the user once all tests are passing.
