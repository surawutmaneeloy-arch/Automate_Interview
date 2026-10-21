"""Robot library: records every test result and auto-logs a defect for each failed test (used in Test Teardown)."""
from datetime import datetime
from pathlib import Path

from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn

import ReportExporter as exporter


def _steps(case, build):
    steps = ["Open https://testsheepnz.github.io/BasicCalculator.html",
             f"Select Build = {exporter.build_label(build)}",
             f"Select Operation = {case.get('operation', '')}"]
    ctype = case.get("type", "CALC")
    if ctype in ("CALC", "CLEAR", "INT_TOGGLE"):
        steps.append(f"Enter First number = '{case.get('first', '')}', Second number = '{case.get('second', '')}'")
        if case.get("integers") == "Yes" and ctype != "INT_TOGGLE":
            steps.append("Tick 'Integers only'")
        steps.append("Click Calculate")
        if ctype == "INT_TOGGLE":
            steps.append("Tick 'Integers only'")
        if ctype == "CLEAR":
            steps.append("Click Clear")
    elif ctype == "CLEAR_STATE":
        steps = steps[:2] + ["Inspect the Clear button without calculating"]
    else:
        steps.append("Inspect the 'Integers only' checkbox")
    return "\n".join(f"{i}. {s}" for i, s in enumerate(steps, start=1))


@library(scope="GLOBAL", auto_keywords=False)
class DefectLogger:
    @keyword("Record Test Result")
    def record_test_result(self, case, expected, actual, status, message="", screenshot=""):
        """Append the result to results.jsonl and, when ``status`` is FAIL, log a defect to defects.jsonl."""
        builtin = BuiltIn()
        build = str(builtin.get_variable_value("${BUILD}", "0"))
        output_dir = Path(builtin.get_variable_value("${OUTPUT DIR}"))
        case = dict(case or {})
        if not case.get("tc_id"):
            case["tc_id"] = str(builtin.get_variable_value("${TEST NAME}", "TC?")).split(" ")[0]
        evidence = ""
        if screenshot:
            try:
                evidence = Path(screenshot).resolve().relative_to(output_dir.resolve()).as_posix()
            except ValueError:
                evidence = str(screenshot)
        now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        if str(actual).startswith("N/A"):
            lines = [ln.strip() for ln in str(message).splitlines() if ln.strip()]
            actual = f"Test could not read a result: {lines[0] if lines else 'no message'}"
        if status == "FAIL" and str(message).startswith("Setup failed"):
            status = "ERROR"  # environment/navigation problem, not a product defect
        label = exporter.build_label(build)
        field = {k: case.get(k, "") for k in ("type", "category", "operation", "first", "second", "integers", "severity")}

        exporter.append_jsonl(output_dir / "results.jsonl", {
            "build": build, "tc_id": case["tc_id"], **field, "expected": expected, "actual": actual,
            "status": status, "message": message, "timestamp": now,
        })
        if status != "FAIL":
            return
        shown_input = f"{field['operation']}: First='{field['first']}', Second='{field['second']}', Integers only={field['integers']}"
        if field["type"] == "INT_STATE":
            shown_input = f"Operation: {field['operation']}"
        elif field["type"] == "CLEAR_STATE":
            shown_input = "Fresh page (no calculation)"
        exporter.append_jsonl(output_dir / "defects.jsonl", {
            "id": f"DEF-B{build}-{case['tc_id']}", "build": build, "tc_id": case["tc_id"], **field,
            "title": f"[{label}] {case['tc_id']} {field['type']} {field['operation']}: expected result not met",
            "status": "Open", "input": shown_input, "expected": expected, "actual": actual,
            "message": message, "steps": _steps(case, build), "evidence": evidence, "detected_at": now,
        })

    @keyword("Reset Run Log")
    def reset_run_log(self):
        """Remove results/defects of a previous run in the same output directory (call in Suite Setup)."""
        output_dir = Path(BuiltIn().get_variable_value("${OUTPUT DIR}"))
        for name in ("results.jsonl", "defects.jsonl"):
            (output_dir / name).unlink(missing_ok=True)

    @keyword("Export Build Reports")
    def export_build_reports(self):
        """Write Test_Result.md/.xlsx for the current run (call in Suite Teardown)."""
        output_dir = BuiltIn().get_variable_value("${OUTPUT DIR}")
        exporter.export_build_reports(output_dir)
