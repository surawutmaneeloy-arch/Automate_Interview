"""Pre-run modifier: expands the template test into one Robot test per row of Test_case/test_cases.md."""
from robot.api import SuiteVisitor

from TestCaseParser import parse_test_cases

KEYWORD = "Run Calculator Case"
ARG_FIELDS = [
    "tc_id", "type", "category", "operation", "first", "second",
    "integers", "expected", "expected_error", "severity",
]


class DataDrivenModifier(SuiteVisitor):
    def __init__(self, path=None):
        self.rows = parse_test_cases(path)

    def start_suite(self, suite):
        if not suite.tests:
            return
        suite.tests.clear()
        for row in self.rows:
            name = f"{row['tc_id']} {row['operation']} [{row['first']}, {row['second']}] int={row['integers']} ({row['type']})"
            test = suite.tests.create(
                name=name,
                doc=row["technique"],
                tags=[row["type"], row["category"], row["operation"], f"severity-{row['severity']}"],
            )
            test.setup.config(name="Open Calculator")
            test.teardown.config(name="Log Result And Defect")
            test.body.create_keyword(name=KEYWORD, args=[row[f] for f in ARG_FIELDS])
