<Goals>
- Implement every in-scope feature in `specification.yml`, so that each object matches its declared details.
- Make all tests in `tests/` pass without modifying them.
- Document how to use the package in `README.md.jinja`.
</Goals>

<StepsToFollow>
1. Read `pyproject.toml`. Derive the import package name from the `[project]` name by replacing hyphens with underscores. This name is the root of the source tree.
2. Read `specification.yml`. Note `package.import_style`, which defaults to `subpackage` when absent. Select the features whose `status` is `accepted`, `in_progress`, or `done`. Do not implement `proposed` or `deprecated` features.
3. Read the test modules in `tests/` for each in-scope feature. Treat them as the definition of correct behavior. If a test contradicts the specification, stop and report the conflict.
4. For each test module `tests/<feature_slug>/test_<object_leaf>.py`, implement the object in `src/<import_name>/<feature_slug>/<object_leaf>.py`. Each source module defines one object, and its file name is the test module's name without the `test_` prefix. Match the object's `kind` and every detail in the spec exactly.
5. Run `pytest` in `tests/` and save the full output to `.subagents/implementation/logs/<current_git_branch>/pytest`.
6. Read that log and fix the implementation for each failing test. Repeat until every in-scope test passes. If a failure can only be fixed by editing a protected file, changing a test, or changing the specification, stop and report it instead of working around it.
7. When all in-scope tests pass, tell the user.
8. If in-scope tests exist, update `README.md.jinja` with detailed usage instructions. Cover installation, the import form for the active `import_style`, and one usage example for each in-scope feature.
</StepsToFollow>

<ImportStyleRules>
- `package`: Attribute access such as `package.subpackage.object` must work.
- `subpackage`: `from package.subpackage import object` must work, and importing the package root must not eagerly load its submodules.
- `star`: Public objects must be listed in the root `__all__`, and `from package import *` must expose them.
- You may edit `_loader.py` only to implement the behavior required by `IMPORT_STYLE`. Make no other changes to it.
- Do not edit `__init__.py`. If an import style requires changes there, stop and report it.
</ImportStyleRules>

<BuildInstructions>
- Make changes only inside `src/**`, plus the import-style changes to `_loader.py` described above. Do not edit `tests/`, `specification.yml`, `pyproject.toml`, `__init__.py`, or `conftest.py`.
- Each feature directory under `src/<import_name>/` maps one-to-one to the matching subdirectory under `tests/`.
- Each source module defines exactly one object and maps one-to-one to a test module.
- If an object's `name` in the specification does not match the import path that the source layout produces, stop and report the mismatch before writing the module.
- Do not add behavior that the specification does not state. If a feature needs detail the spec lacks, report it.
- In `README.md.jinja`, preserve all existing formatting, Jinja tags, and placeholders. Add content only in the sections the template already defines.
- Use emoji sparingly and professionally in `README.md.jinja` and in your report to the user. Do not use emoji in code, identifiers, docstrings, or log files.
- Your final report must list the features implemented, the test results, any features skipped, and every conflict or blocked item.
</BuildInstructions>
