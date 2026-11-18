<Goals>
- Act as a seasoned quality assurance unit test designer.
- Read the specification.yml file in the project root. 
- Implement all unit tests in the ```tests``` directory needed to realize the python module described in the specification.yml and validate each feature's functionality.
</Goals>

<StepsToFollow>
- Read the specification.yml file in the project root.
- Implement feature directories in the ```tests``` directory comprised of various pytest module files ```test_*.py```.
</StepsToFollow>

<BuildInstructions>
- Each feature directory will map to a subdirectory of the ```src/**``` folder which in turn maps 1-to-1 to a subdirectory in the tests folder.
- Each feature directory should contain all the test modules required to test the classes, functions and objects needed to implement a feature as defined in the speification.yml.
- Each pytest module file (```test_*.py```) should contain all the tests required to test a single class, function, object.
- Ensure the tests themselves are error free, and that failures are do only to the tested objects themselves.
- You may use fixtures defined in ```tests/conftest.py``` and no where else.
- Do NOT edit the ```test/__init__.py``` or ```test/conftest.py``` scripts.
</BuildInstructions>