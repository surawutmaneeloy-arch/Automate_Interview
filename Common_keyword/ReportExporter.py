"""Export test results and defects (per build and consolidated) to Markdown and Excel."""
import json
from collections import OrderedDict
from datetime import datetime
from pathlib import Path

import xlsxwriter

SEVERITY_ORDER = ["Critical", "High", "Medium", "Low"]
TRIAGE_FILE = Path(__file__).resolve().parent / "bug_triage.json"


def build_label(build):
    return "Prototype" if str(build) == "0" else f"Build {build}"


# ---------------------------------------------------------------- io helpers
def read_jsonl(path):
    path = Path(path)
    if not path.exists():
        return []
    return [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines() if line.strip()]


def append_jsonl(path, record):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8") as fh:
        fh.write(json.dumps(record, ensure_ascii=False) + "\n")


def _cell(value):
    return str(value).replace("|", "\\|").replace("\r", "").replace("\n", "<br>")


def md_table(headers, rows):
    lines = ["| " + " | ".join(headers) + " |", "|" + "|".join("---" for _ in headers) + "|"]
    lines += ["| " + " | ".join(_cell(c) for c in row) + " |" for row in rows]
    return "\n".join(lines)


def write_xlsx(path, sheets):
    wb = xlsxwriter.Workbook(str(path))
    head = wb.add_format({"bold": True, "font_color": "white", "bg_color": "#1F4E78", "border": 1, "valign": "top"})
    body = wb.add_format({"text_wrap": True, "valign": "top", "border": 1})
    fmt_pass = wb.add_format({"bg_color": "#C6EFCE"})
    fmt_fail = wb.add_format({"bg_color": "#FFC7CE"})
    for name, (headers, rows) in sheets.items():
        ws = wb.add_worksheet(name)
        for c, header in enumerate(headers):
            ws.write_string(0, c, str(header), head)
            longest = max([len(str(header))] + [len(str(r[c]).split("\n")[0]) for r in rows])
            ws.set_column(c, c, min(max(longest + 2, 8), 60))
        for r, row in enumerate(rows, start=1):
            for c, value in enumerate(row):
                ws.write_string(r, c, str(value), body)
        ws.freeze_panes(1, 0)
        if rows:
            ws.autofilter(0, 0, len(rows), len(headers) - 1)
            last = (len(rows), len(headers) - 1)
            ws.conditional_format(1, 0, *last, {"type": "cell", "criteria": "==", "value": '"PASS"', "format": fmt_pass})
            ws.conditional_format(1, 0, *last, {"type": "cell", "criteria": "==", "value": '"FAIL"', "format": fmt_fail})
    wb.close()


def _write(path, text):
    Path(path).write_text(text, encoding="utf-8")


# ----------------------------------------------------------- table builders
RESULT_HEADERS = ["Build", "TC ID", "Type", "Category", "Operation", "First number", "Second number",
                  "Integers only", "Expected", "Actual", "Status", "Severity", "Message"]
DEFECT_HEADERS = ["Defect ID", "Build", "TC ID", "Title", "Severity", "Status", "Input", "Expected",
                  "Actual", "Steps to reproduce", "Evidence", "Detected at"]


def result_row(r):
    return [build_label(r["build"]), r["tc_id"], r["type"], r["category"], r["operation"], r["first"],
            r["second"], r["integers"], r["expected"], r["actual"], r["status"], r["severity"], r["message"]]


def defect_row(d):
    return [d["id"], build_label(d["build"]), d["tc_id"], d["title"], d["severity"], d["status"],
            d["input"], d["expected"], d["actual"], d["steps"], d["evidence"], d["detected_at"]]


def _sev_rank(sev):
    return SEVERITY_ORDER.index(sev) if sev in SEVERITY_ORDER else len(SEVERITY_ORDER)


def _tc_num(tc_id):
    digits = "".join(ch for ch in tc_id if ch.isdigit())
    return int(digits) if digits else 0


def _summary_counts(results):
    total = len(results)
    passed = sum(1 for r in results if r["status"] == "PASS")
    failed = total - passed
    rate = f"{passed / total * 100:.1f}%" if total else "n/a"
    return total, passed, failed, rate


# ------------------------------------------------------------- bug summary
def _load_triage():
    if TRIAGE_FILE.exists():
        return json.loads(TRIAGE_FILE.read_text(encoding="utf-8"))
    return {}


def build_bug_summary(defects):
    """One row per (build, symptom group). Groups come from bug_triage.json, leftovers are grouped automatically."""
    triage = _load_triage()
    by_build = OrderedDict()
    for d in sorted(defects, key=lambda x: (int(x["build"]), _tc_num(x["tc_id"]))):
        by_build.setdefault(str(d["build"]), []).append(d)
    rows = []
    for build, items in by_build.items():
        remaining = list(items)
        groups = []
        for group in triage.get(build, []):
            members = list(remaining) if group["tcs"] == "*" else [d for d in remaining if d["tc_id"] in group["tcs"]]
            if members:
                groups.append((group["symptom"], members))
                remaining = [d for d in remaining if d not in members]
        auto = OrderedDict()
        for d in remaining:
            auto.setdefault((d["type"], d["operation"]), []).append(d)
        for (typ, op), members in auto.items():
            groups.append((f"{typ} / {op}: actual result differs from expected (not triaged)", members))
        for symptom, members in groups:
            first = members[0]
            severity = min((m["severity"] for m in members), key=_sev_rank)
            rows.append([build_label(build), symptom, first["input"], first["expected"], first["actual"],
                         severity, len(members), ", ".join(m["tc_id"] for m in members)])
    return rows


SUMMARY_HEADERS = ["Build", "Bug symptom", "Input", "Expected", "Actual", "Severity", "Failed TCs", "Impacted TC IDs"]


# ---------------------------------------------------------------- per build
def export_build_reports(build_dir):
    build_dir = Path(build_dir)
    results = read_jsonl(build_dir / "results.jsonl")
    defects = read_jsonl(build_dir / "defects.jsonl")
    if not results:
        return
    build = results[0]["build"]
    label = build_label(build)
    total, passed, failed, rate = _summary_counts(results)
    results.sort(key=lambda r: _tc_num(r["tc_id"]))
    defects.sort(key=lambda d: _tc_num(d["tc_id"]))
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    md = [f"# Test Result - {label}", "",
          f"- Executed: {now}", f"- Total: {total} | Passed: {passed} | Failed: {failed} | Pass rate: {rate}", "",
          "## Test results", "",
          md_table(RESULT_HEADERS[1:], [result_row(r)[1:] for r in results]), "",
          "## Defects (auto logged in test teardown)", ""]
    md.append(md_table(DEFECT_HEADERS, [defect_row(d) for d in defects]) if defects else "No defects.")
    _write(build_dir / "Test_Result.md", "\n".join(md) + "\n")
    write_xlsx(build_dir / "Test_Result.xlsx", {
        "Summary": (["Build", "Total", "Passed", "Failed", "Pass rate"], [[label, total, passed, failed, rate]]),
        "Test Results": (RESULT_HEADERS, [result_row(r) for r in results]),
        "Defects": (DEFECT_HEADERS, [defect_row(d) for d in defects]),
    })


# ------------------------------------------------------------- consolidated
def export_consolidated(result_root):
    result_root = Path(result_root)
    build_dirs = sorted(result_root.glob("Build_*"), key=lambda p: int(p.name.split("_")[1]))
    all_results, all_defects = [], []
    for d in build_dirs:
        all_results += read_jsonl(d / "results.jsonl")
        all_defects += read_jsonl(d / "defects.jsonl")
    if not all_results:
        return
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    builds = list(OrderedDict.fromkeys(str(r["build"]) for r in all_results))

    # ---- test result summary
    summary_rows = []
    for b in builds:
        subset = [r for r in all_results if str(r["build"]) == b]
        total, passed, failed, rate = _summary_counts(subset)
        summary_rows.append([build_label(b), total, passed, failed, rate, "PASS" if failed == 0 else "FAIL"])
    summary_headers = ["Build", "Total", "Passed", "Failed", "Pass rate", "Result"]

    cases = OrderedDict()
    for r in sorted(all_results, key=lambda x: _tc_num(x["tc_id"])):
        cases.setdefault(r["tc_id"], r)
    matrix_headers = ["TC ID", "Type", "Operation", "First number", "Second number", "Integers only", "Severity"] \
        + [build_label(b) for b in builds]
    matrix_rows = []
    for tc_id, case in cases.items():
        status = {str(r["build"]): r["status"] for r in all_results if r["tc_id"] == tc_id}
        matrix_rows.append([tc_id, case["type"], case["operation"], case["first"], case["second"],
                            case["integers"], case["severity"]] + [status.get(b, "-") for b in builds])

    all_results.sort(key=lambda r: (int(r["build"]), _tc_num(r["tc_id"])))
    md = ["# Test Result Summary - Basic Calculator", "", f"- Generated: {now}", "",
          "## Summary by build", "", md_table(summary_headers, summary_rows), "",
          "## Test case x build matrix", "", md_table(matrix_headers, matrix_rows), ""]
    _write(result_root / "Test_Result_Summary.md", "\n".join(md))
    write_xlsx(result_root / "Test_Result_Summary.xlsx", {
        "Summary": (summary_headers, summary_rows),
        "Matrix": (matrix_headers, matrix_rows),
        "All Results": (RESULT_HEADERS, [result_row(r) for r in all_results]),
    })

    # ---- defect report
    all_defects.sort(key=lambda d: (int(d["build"]), _tc_num(d["tc_id"])))
    bug_rows = build_bug_summary(all_defects)
    md = ["# Defect Report - Basic Calculator", "", f"- Generated: {now}",
          f"- Defects logged: {len(all_defects)} (one per failed test case) | Bug symptoms: {len(bug_rows)}", "",
          "## Bug summary (by build)", "", md_table(SUMMARY_HEADERS, bug_rows), "",
          "## Defect log (auto logged in test teardown)", "",
          md_table(DEFECT_HEADERS, [defect_row(d) for d in all_defects]) if all_defects else "No defects.", ""]
    _write(result_root / "Defect_Report.md", "\n".join(md))
    write_xlsx(result_root / "Defect_Report.xlsx", {
        "Bug Summary": (SUMMARY_HEADERS, bug_rows),
        "Defect Log": (DEFECT_HEADERS, [defect_row(d) for d in all_defects]),
    })


if __name__ == "__main__":
    import sys
    export_consolidated(sys.argv[1] if len(sys.argv) > 1 else Path(__file__).resolve().parent.parent / "Test_Result")
