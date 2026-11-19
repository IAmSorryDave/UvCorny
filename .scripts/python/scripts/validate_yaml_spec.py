from pathlib import Path
import sys
import tempfile

import yaml


PROJECT_ROOT = Path(__file__).resolve().parents[3]
FEATURES_PATH = PROJECT_ROOT / "requirements" / "features"
AGGREGATE_PATH = PROJECT_ROOT / "requirements" / "aggregate" / "specification.yml"
IMPORT_STYLES = {"package", "subpackage", "star"}


def _read_feature_spec(path: Path) -> dict:
    try:
        with path.open(encoding="utf-8") as specification:
            data = yaml.safe_load(specification)
    except OSError as error:
        raise ValueError(f"Could not read {path}: {error}") from error
    except UnicodeError as error:
        raise ValueError(f"{path} is not valid UTF-8: {error}") from error
    except yaml.YAMLError as error:
        raise ValueError(f"Invalid YAML in {path}: {error}") from error

    if not isinstance(data, dict):
        raise ValueError(f"{path} must contain a YAML mapping")

    package = data.get("package")
    if (
        not isinstance(package, dict)
        or not isinstance(package.get("import_style"), str)
        or package["import_style"] not in IMPORT_STYLES
    ):
        raise ValueError(
            f"{path} must define package.import_style as one of "
            f"{', '.join(sorted(IMPORT_STYLES))}"
        )

    features = data.get("features")
    if not isinstance(features, list) or len(features) != 1:
        raise ValueError(f"{path} must contain exactly one feature in 'features'")

    feature = features[0]
    if not isinstance(feature, dict):
        raise ValueError(f"The feature in {path} must be a YAML mapping")
    slug = feature.get("slug")
    if not isinstance(slug, str) or not slug:
        raise ValueError(f"The feature in {path} must have a non-empty slug")
    if slug != path.parent.name:
        raise ValueError(
            f"Feature slug {slug!r} in {path} must match its directory name"
        )
    if not isinstance(feature.get("requirements"), list):
        raise ValueError(f"The feature in {path} must have a requirements list")

    for key in ("open_questions", "blocking"):
        if key in data and not isinstance(data[key], list):
            raise ValueError(f"{key} in {path} must be a list")
    for question in data.get("open_questions", []):
        if not isinstance(question, dict) or not isinstance(question.get("id"), str):
            raise ValueError(f"Each open question in {path} must have a string id")
    for requirement in feature["requirements"]:
        if not isinstance(requirement, dict) or not isinstance(
            requirement.get("id"), str
        ):
            raise ValueError(f"Each requirement in {path} must have a string id")
    if any(not isinstance(item, str) for item in data.get("blocking", [])):
        raise ValueError(f"Each blocking entry in {path} must be a string")

    return data


def _merge_feature_specs(specifications: list[tuple[Path, dict]]) -> dict:
    aggregate = {
        "package": specifications[0][1]["package"],
        "features": [],
        "open_questions": [],
        "blocking": [],
    }
    feature_slugs = set()
    requirement_ids = set()
    question_ids = set()
    blocking_ids = set()

    for path, specification in specifications:
        if specification["package"] != aggregate["package"]:
            raise ValueError(f"Package settings in {path} differ from other features")

        feature = specification["features"][0]
        if feature["slug"] in feature_slugs:
            raise ValueError(f"Duplicate feature slug {feature['slug']!r} in {path}")
        feature_slugs.add(feature["slug"])

        for requirement in feature["requirements"]:
            requirement_id = requirement["id"]
            if requirement_id in requirement_ids:
                raise ValueError(
                    f"Duplicate requirement id {requirement_id!r} in {path}"
                )
            requirement_ids.add(requirement_id)

        for question in specification.get("open_questions", []):
            question_id = question["id"]
            if question_id in question_ids:
                raise ValueError(
                    f"Duplicate open question id {question_id!r} in {path}"
                )
            question_ids.add(question_id)

        aggregate["features"].append(feature)
        aggregate["open_questions"].extend(specification.get("open_questions", []))
        for requirement_id in specification.get("blocking", []):
            if requirement_id not in blocking_ids:
                aggregate["blocking"].append(requirement_id)
                blocking_ids.add(requirement_id)

    return aggregate


def _write_aggregate(aggregate: dict) -> None:
    AGGREGATE_PATH.parent.mkdir(parents=True, exist_ok=True)
    temporary_path = None
    try:
        with tempfile.NamedTemporaryFile(
            mode="w",
            encoding="utf-8",
            dir=AGGREGATE_PATH.parent,
            delete=False,
        ) as temporary_file:
            temporary_path = Path(temporary_file.name)
            yaml.safe_dump(
                aggregate, temporary_file, sort_keys=False, allow_unicode=True
            )
        temporary_path.replace(AGGREGATE_PATH)
    finally:
        if temporary_path is not None:
            temporary_path.unlink(missing_ok=True)


def validate_yaml_spec() -> int:
    """Validate feature specification YAML and regenerate its aggregate."""

    feature_paths = sorted(FEATURES_PATH.glob("*/specification.yml"))
    if not feature_paths:
        print(f"No feature specification YAML files found in {FEATURES_PATH}")
        return 0

    try:
        specifications = [(path, _read_feature_spec(path)) for path in feature_paths]
        aggregate = _merge_feature_specs(specifications)
        _write_aggregate(aggregate)
    except (OSError, ValueError, yaml.YAMLError) as error:
        print(error, file=sys.stderr)
        return 1

    print(f"Validated {len(feature_paths)} feature specification(s).")
    print(f"Updated aggregate specification: {AGGREGATE_PATH}")
    return 0


if __name__ == "__main__":
    raise SystemExit(validate_yaml_spec())
