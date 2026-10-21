"""Robot library: records every test step (with expected result and evidence picture) and logs a defect per failed test.

Layout under ${OUTPUT DIR}:  <suite>/<group>/results.jsonl | defects.jsonl | evidence/*.jpeg
``Export Suite Reports`` turns the records into HTML; Chromium prints the HTML to PDF (see report.resource).
"""
import re
import shutil
from collections import OrderedDict
from datetime import datetime
from pathlib import Path

from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn

import PdfReport
import ReportExporter as exporter

CONSOLIDATED_SUITES = {"Calculator"}  # suites whose defects are grouped by bug_triage.json across builds


def _safe(text):
    return re.sub(r"[^A-Za-z0-9_.-]+", "_", str(text)).strip("_")


@library(scope="GLOBAL", auto_keywords=False)
class TestRecorder:
    def __init__(self):
        self.current = None
        self.started = {}  # (suite, group) -> directory, reset once per run

    # ----------------------------------------------------------- helpers
    @staticmethod
    def _output_dir():
        return Path(BuiltIn().get_variable_value("${OUTPUT DIR}"))

    def _group_dir(self, suite, group):
        base = self._output_dir() / suite
        return base / group if group else base

    @staticmethod
    def _rel(path, base):
        try:
            return Path(path).resolve().relative_to(Path(base).resolve()).as_posix()
        except ValueError:
            return str(path)

    # ------------------------------------------------------------ record
    @keyword("Start Test Record")
    def start_test_record(self, suite, group, tc_id, name, test_data, precondition, severity="", meta=None,
                          group_label=""):
        """Begin the record of the running test. ``test_data`` is an ordered dict (label -> value)."""
        group_dir = self._group_dir(suite, group)
        if (suite, group) not in self.started:
            for file in ("results.jsonl", "defects.jsonl"):
                (group_dir / file).unlink(missing_ok=True)
            shutil.rmtree(group_dir / "evidence", ignore_errors=True)
            self.started[(suite, group)] = group_dir
        (group_dir / "evidence").mkdir(parents=True, exist_ok=True)
        self.current = {
            "suite": suite, "group": group, "group_label": group_label, "tc_id": tc_id, "name": name,
            "test_data": [[str(k), str(v)] for k, v in dict(test_data).items()],
            "precondition": precondition, "severity": severity, "meta": dict(meta or {}),
            "steps": [], "_dir": group_dir, "_suite_dir": self._output_dir() / suite,
        }

    @keyword("Evidence Path")
    def evidence_path(self, step_no):
        """Absolute file name (without extension) for the picture of a step."""
        c = self.current
        return str(c["_dir"] / "evidence" / f"{_safe(c['tc_id'])}_step{step_no}")

    @keyword("Add Step Record")
    def add_step_record(self, description, expected, status, actual="", picture="", evidence_text=""):
        c = self.current
        c["steps"].append({
            "no": len(c["steps"]) + 1, "description": description, "expected": expected, "status": status,
            "actual": actual, "evidence_text": evidence_text,
            "picture": self._rel(picture, c["_suite_dir"]) if picture else "",
        })

    @keyword("Finish Test Record")
    def finish_test_record(self, status, message="", expected="", actual=""):
        """Store the result; for FAIL also log a defect that points at the picture of the failed step."""
        c = self.current
        if c is None:
            return
        self.current = None
        message = str(message)
        if status == "FAIL" and message.startswith("Setup failed"):
            status = "ERROR"  # environment problem, not a product defect
        failed = next((s for s in c["steps"] if s["status"] == "FAIL"), None)
        expected = expected or (failed["expected"] if failed else "")
        if not actual and status != "PASS":
            actual = (failed["actual"] if failed else "") or (message.splitlines()[0] if message else "")
        now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        steps_text = "\n".join(f"{s['no']}. {s['description']}" for s in c["steps"])
        meta = c["meta"]
        record = {
            "suite": c["suite"], "group": c["group"], "tc_id": c["tc_id"], "name": c["name"],
            "test_data": c["test_data"], "precondition": c["precondition"], "severity": c["severity"],
            "status": status, "message": message, "expected": expected, "actual": actual, "steps": c["steps"],
            "timestamp": now, **meta,
        }
        exporter.append_jsonl(c["_dir"] / "results.jsonl", record)
        if status != "FAIL":
            return
        group_label = c["group_label"] or c["group"]
        picture = failed["picture"] if failed else ""
        exporter.append_jsonl(c["_dir"] / "defects.jsonl", {
            "id": f"DEF-{_safe(group_label or c['suite'])}-{c['tc_id']}", "suite": c["suite"], "group": c["group"],
            "tc_id": c["tc_id"], "title": f"[{group_label}] {c['name']}" if group_label else c["name"],
            "severity": c["severity"], "status": "Open",
            "input": meta.get("input", "; ".join(f"{k}={v}" for k, v in c["test_data"])),
            "expected": expected, "actual": actual, "message": message, "steps": steps_text, "evidence": picture, "detected_at": now,
            **{k: v for k, v in meta.items() if k != "input"},
        })

    # ------------------------------------------------------------ export
    @keyword("Export Suite Reports")
    def export_suite_reports(self, suite, title):
        """Write the report HTML and return [html, html_uri, pdf, landscape] rows to print as PDF."""
        suite_dir = self._output_dir() / suite
        jobs = []
        started = sorted((g, d) for (s, g), d in self.started.items() if s == suite)
        if suite in CONSOLIDATED_SUITES:  # a partial run (--include build-9) still refreshes every build's report
            started = [(d.name, d) for d in sorted(suite_dir.glob("Build_*"), key=lambda p: int(p.name.split("_")[1]))]
        for group, directory in started:
            results = exporter.read_jsonl(directory / "results.jsonl")
            if not results:
                continue
            label = exporter.build_label(group.split("_")[-1]) if group else ""
            html = directory / "Test_Report.html"
            html.write_text(PdfReport.render_test_report(results, title, label, directory, suite_dir), encoding="utf-8")
            jobs.append([str(html), html.as_uri(), str(directory / "Test_Report.pdf"), False])

        if suite in CONSOLIDATED_SUITES:
            by_build = OrderedDict()
            defects = []
            for d in sorted(suite_dir.glob("Build_*"), key=lambda p: int(p.name.split("_")[1])):
                by_build[d.name.split("_")[1]] = exporter.read_jsonl(d / "results.jsonl")
                defects += exporter.read_jsonl(d / "defects.jsonl")
            rows = PdfReport.grouped_defect_rows(defects)
            if by_build:
                html = suite_dir / "Test_Result_Summary.html"
                html.write_text(PdfReport.render_summary_report(by_build, title), encoding="utf-8")
                jobs.append([str(html), html.as_uri(), str(suite_dir / "Test_Result_Summary.pdf"), True])
        else:
            defects = exporter.read_jsonl(suite_dir / "defects.jsonl")
            rows = PdfReport.single_defect_rows(defects)
        if jobs:
            html = suite_dir / "Defect_Report.html"
            html.write_text(PdfReport.render_defect_report(rows, title, len(defects), suite_dir), encoding="utf-8")
            jobs.append([str(html), html.as_uri(), str(suite_dir / "Defect_Report.pdf"), True])
        return jobs
