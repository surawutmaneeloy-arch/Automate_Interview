"""Export the calculator test cases (Test_case_robot/Calculator/calculator_test_data.py) to
Test_case/test_cases.xlsx and refresh the table in Test_case/test_cases.md."""
import importlib.util
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "Common_keyword"))

from ReportExporter import md_table, write_xlsx  # noqa: E402

DATA_FILE = ROOT / "Test_case_robot" / "Calculator" / "calculator_test_data.py"
HEADERS = ["TC ID", "Type", "Category", "Operation", "First number", "Second number", "Integers only",
           "Expected result", "Expected error", "Severity", "Technique / Rationale"]
FIELDS = ["type", "category", "operation", "first", "second", "integers", "expected", "expected_error", "severity",
          "technique"]
TABLE_HEADING = "## Test Case Table"


def load_cases():
    spec = importlib.util.spec_from_file_location("calculator_test_data", DATA_FILE)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    names = sorted((n for n in vars(module) if re.fullmatch(r"TC\d+", n)), key=lambda n: int(n[2:]))
    return [[name] + [getattr(module, name)[f] or "(empty)" for f in FIELDS] for name in names]


def main():
    rows = load_cases()
    write_xlsx(ROOT / "Test_case" / "test_cases.xlsx", {"Test Cases": (HEADERS, rows)})
    md_file = ROOT / "Test_case" / "test_cases.md"
    head = md_file.read_text(encoding="utf-8").split(TABLE_HEADING)[0]
    md_file.write_text(f"{head}{TABLE_HEADING}\n\n{md_table(HEADERS, rows)}\n", encoding="utf-8")
    print(f"{len(rows)} test cases exported to Test_case/test_cases.xlsx and test_cases.md")


if __name__ == "__main__":
    main()
