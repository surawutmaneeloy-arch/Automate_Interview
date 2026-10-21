"""Parse the test case table in Test_case/test_cases.md."""
from pathlib import Path

DEFAULT_FILE = Path(__file__).resolve().parent.parent / "Test_case" / "test_cases.md"

COLUMNS = [
    "tc_id", "type", "category", "operation", "first", "second",
    "integers", "expected", "expected_error", "severity", "technique",
]

HEADERS = [
    "TC ID", "Type", "Category", "Operation", "First number", "Second number",
    "Integers only", "Expected result", "Expected error", "Severity", "Technique / Rationale",
]


def parse_test_cases(path=None):
    path = Path(path) if path else DEFAULT_FILE
    rows = []
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line.startswith("|"):
            continue
        cells = [c.strip() for c in line.strip("|").split("|")]
        if cells[0] == "TC ID" or set(cells[0]) <= set("-: "):
            continue
        if len(cells) != len(COLUMNS):
            raise ValueError(f"Bad test case row ({len(cells)} columns): {line}")
        rows.append(dict(zip(COLUMNS, cells)))
    return rows
