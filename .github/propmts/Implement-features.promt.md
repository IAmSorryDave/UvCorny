---
name: implement-feature
description: Use this prompt when implementing a feature defined in the tests folder.
---

<!-- Tip: Use /create-prompt in chat to generate content with agent assistance -->

Implement all features which will pass all tests in the ```tests``` folder. Each feature subdirectory in the package directory should corespond to a directory in the ```tests``` folder. The code for each feature should be implemented in the corresponding subdirectory. You have permission to create those feature directories. Again all tests must pass, not skip or fail. After implementing all features, call ```main.bash``` to check your work and if necessary adjust the code to pass the tests. Repeat this last step as many times as necessary. Alert the user once all tests are passing.
