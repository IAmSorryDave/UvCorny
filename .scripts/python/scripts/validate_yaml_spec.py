from pathlib import Path
import sys

import yaml


SPECIFICATION_PATH = Path(__file__).resolve().parents[3] / "specification.yml"


def validate_yaml_spec():
    """Validate the syntax of the project specification YAML file."""

    try:
        with SPECIFICATION_PATH.open(encoding="utf-8") as specification:
            yaml.safe_load(specification)
    except FileNotFoundError:
        print(f"Specification file not found: {SPECIFICATION_PATH}", file=sys.stderr)
        return 1
    except OSError as error:
        print(f"Could not read specification file: {error}", file=sys.stderr)
        return 1
    except UnicodeError as error:
        print(f"Specification file is not valid UTF-8: {error}", file=sys.stderr)
        return 1
    except yaml.YAMLError as error:
        print(f"Invalid YAML in {SPECIFICATION_PATH}: {error}", file=sys.stderr)
        return 1

    print(f"Validated YAML syntax: {SPECIFICATION_PATH}")
    return 0


if __name__ == "__main__":
    raise SystemExit(validate_yaml_spec())
