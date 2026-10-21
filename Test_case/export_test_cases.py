"""Export Test_case/test_cases.md to Test_case/test_cases.xlsx."""
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "Common_keyword"))

from ReportExporter import write_xlsx  # noqa: E402
from TestCaseParser import COLUMNS, HEADERS, parse_test_cases  # noqa: E402


def main():
    rows = [[row[c] for c in COLUMNS] for row in parse_test_cases()]
    target = ROOT / "Test_case" / "test_cases.xlsx"
    write_xlsx(target, {"Test Cases": (HEADERS, rows)})
    print(f"{len(rows)} test cases exported to {target}")


if __name__ == "__main__":
    main()
