<Goals>
- Act as a seasoned quality assurance unit test designer.
- Read `pyproject.toml` to determine the import package name, and read `specification.yml` in the project root.
- Write pytest unit tests in `tests/` that verify each in-scope feature's components against the specification, so every acceptance criterion and every declared component detail is covered.
</Goals>

<StepsToFollow>
1. Read `pyproject.toml`. Derive the import package name from the `[project]` name by replacing hyphens with underscores.
2. Read `specification.yml`. Note `package.import_style`, which defaults to `subpackage` when absent.
3. Select the features whose `status` is `accepted`, `in_progress`, or `done`. Skip `proposed` and `deprecated` features, and list each skipped feature in your final report.
4. Skip every requirement that appears in the `blocking` list of an open question. List those requirements in your final report.
5. For each in-scope feature, create a directory `tests/<feature_slug>/`, where `feature_slug` is the feature name in snake_case.
6. For each in-scope component, create `tests/<feature_slug>/test_<component_leaf_name>.py`, where `component_leaf_name` is the last segment of the component's `name`.
7. For each requirement linked to the component through `traces_to`, write one test per acceptance string. Put the `REQ-###` identifier in the test name and in its docstring.
8. Write the tests for each component according to its kind, as described under Component Test Rules.
9. Run the tests. Confirm that every failure is caused by the tested object, not by the test code, fixtures, imports, or the environment.
10. Report the features and requirements covered, the features and requirements skipped, and any acceptance criteria you could not test as written.
</StepsToFollow>

## Component Test Rules

- **function**: Compare `inspect.signature` with the `signature` string. For each entry in `arguments`, check the parameter's kind: `arg` must accept a positional argument, and `kwargs` must be keyword-only. Check each `default`. For each entry in `outputs`, write a test that triggers its `condition` and asserts the result's type.
- **class**: Check that `inspect.signature` of the class matches `init_signature`. Confirm that each `instance_attributes` name exists on an instance, and each `class_attributes` name exists on the class. Check each `is_a` base with `issubclass`. Test each `methods` entry according to its `kind`:
  - `property`: read the value. If `writable` is `false`, assigning to it must raise `AttributeError`. If `writable` is `true`, assign a value and check the effect described in `side_effects`.
  - `instance`: call the method on an instance.
  - `classmethod`: call the method on the class and check that it returns an instance of the expected type.
  - `staticmethod`: call the method on the class with no instance.
  - For any method with `raises`, test that each listed exception is raised under the condition described in the acceptance criteria.
- **object**: Check that the object exists at its `name` and that its type matches `type`. If `notes` states that the object is immutable, test that modification raises an error.
- **enum**, **protocol**, **constant**, **module**: Test the members, conformance, value, or importability stated in the specification.

## Import Style Rules

- Test only the import form that matches `package.import_style`.
- **package**: Access the component through its attribute path, for example `package.subpackage.object`.
- **subpackage**: Import the component from its defining module. Test that importing the package root does not import its submodules. Run this check in a subprocess so that test order does not affect the result.
- **star**: Import with `from package import *`. Check that every public component is in the root `__all__`, and that no private name is exported.

## Constraints

- Do not edit `specification.yml`, `pyproject.toml`, `tests/__init__.py`, or `tests/conftest.py`.
- Use fixtures from `tests/conftest.py` only. Do not define fixtures in any other file.
- Test only behavior stated in the specification. If an acceptance criterion is ambiguous or untestable, record it in the report and do not invent a test for it.
- Do not write tests for deprecated or skipped items.
- Do not use network access or depend on test execution order.
