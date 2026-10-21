"""Robot library: JSON schema validation for API responses."""
import json
from pathlib import Path

from jsonschema import Draft7Validator

SCHEMA_DIR = Path(__file__).resolve().parent / "api_schemas"


def schema_errors(data, schema_file):
    """Return the schema violations of ``data`` (an object or an array of objects) as a list of messages."""
    schema = json.loads((SCHEMA_DIR / schema_file).read_text(encoding="utf-8"))
    validator = Draft7Validator(schema)
    if isinstance(data, list):
        return [f"item {i}: {e.message}" for i, item in enumerate(data) for e in validator.iter_errors(item)]
    return [e.message for e in validator.iter_errors(data)]
