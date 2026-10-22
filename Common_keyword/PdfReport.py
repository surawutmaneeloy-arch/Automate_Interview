"""Build the HTML of the PDF test report and defect report (Chromium prints it to PDF)."""
import os
from datetime import datetime
from html import escape
from pathlib import Path
from urllib.parse import quote

import ReportExporter as exporter

CSS = """
body { font-family: 'Segoe UI', Arial, sans-serif; font-size: 11px; color: #222; margin: 0; }
h1 { font-size: 20px; margin: 0 0 4px; color: #1F4E78; }
h2 { font-size: 13px; margin: 0; }
.meta { color: #555; margin-bottom: 10px; }
table { border-collapse: collapse; width: 100%; }
th, td { border: 1px solid #9aa5b1; padding: 4px 6px; vertical-align: top; text-align: left; }
th { background: #1F4E78; color: #fff; font-weight: 600; }
.summary { width: auto; margin-bottom: 10px; }
.summary td, .summary th { text-align: center; padding: 3px 14px; }
.tc { margin: 0 0 14px; break-inside: avoid; }
.tc .hdr th { width: 105px; background: #dde6f0; color: #1F4E78; }
.tc .hdr td.status { width: 90px; text-align: center; font-weight: 700; font-size: 13px; }
.steps th { text-align: center; }
.steps tr { break-inside: avoid; }
.steps td.no { width: 36px; text-align: center; font-weight: 700; }
.steps td.st { width: 52px; text-align: center; font-weight: 700; }
.steps td.step { width: 20%; }
.steps td.pic { width: 46%; text-align: center; }
.steps td.exp { width: 26%; }
.steps img { max-width: 100%; max-height: 330px; border: 1px solid #bbb; }
.evidence { text-align: left; font-family: Consolas, monospace; font-size: 9px; white-space: pre-wrap; word-break: break-all; }
.PASS { color: #1b7a2f; } .FAIL { color: #c0182d; } .ERROR { color: #b86e00; }
td.PASS, td.FAIL, td.ERROR { background: #f5f7fa; }
.actual { margin-top: 5px; padding-top: 4px; border-top: 1px dashed #bbb; }
.defects td.pic { width: 30%; text-align: center; }
.defects img { max-width: 100%; max-height: 300px; border: 1px solid #bbb; }
.defects td { font-size: 10px; }
.small { color: #666; font-size: 9px; }
.matrix th, .matrix td { padding: 2px 4px; font-size: 9px; }
"""


def _e(value):
    return escape(str(value)).replace("\n", "<br>")


def _img(suite_dir, rel, html_dir):
    src = quote(Path(os.path.relpath(Path(suite_dir) / rel, html_dir)).as_posix())
    return f'<img src="{src}" alt="evidence">'


def _page(title, body):
    return f"<!DOCTYPE html><html><head><meta charset='utf-8'><title>{_e(title)}</title><style>{CSS}</style></head><body>{body}</body></html>"


# --------------------------------------------------------------- test report
def render_test_report(results, title, label, html_dir, suite_dir):
    counts = {s: sum(1 for r in results if r["status"] == s) for s in ("PASS", "FAIL", "ERROR")}
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    heading = f"{title} - {label}" if label else title
    parts = [f"<h1>Test Report: {_e(heading)}</h1><div class='meta'>Generated {now}</div>",
             "<table class='summary'><tr><th>Total</th><th>Passed</th><th>Failed</th><th>Error</th><th>Pass rate</th></tr>"
             f"<tr><td>{len(results)}</td><td class='PASS'>{counts['PASS']}</td><td class='FAIL'>{counts['FAIL']}</td>"
             f"<td class='ERROR'>{counts['ERROR']}</td><td>{counts['PASS'] / len(results) * 100:.1f}%</td></tr></table>"]
    for r in results:
        data = "<br>".join(f"<b>{_e(k)}</b>: {_e(v) if v != '' else '(empty)'}" for k, v in r["test_data"])
        parts.append(
            "<div class='tc'><table class='hdr'>"
            f"<tr><th>Test case name</th><td>{_e(r['name'])}</td>"
            f"<th>Total status</th><td class='status {r['status']}'>{r['status']}</td></tr>"
            f"<tr><th>Test data</th><td colspan='3'>{data}</td></tr>"
            f"<tr><th>Pre-condition</th><td colspan='3'>{_e(r['precondition'])}</td></tr></table>"
            "<table class='steps'><tr><th>No.</th><th>Test status</th><th>Test step</th><th>Picture</th><th>Expected</th></tr>")
        for s in r["steps"]:
            if s["picture"]:
                picture = _img(suite_dir, s["picture"], html_dir)
            else:
                picture = f"<div class='evidence'>{_e(s['evidence_text'] or 'No picture (API test)')}</div>"
            actual = f"<div class='actual {s['status']}'><b>Actual:</b> {_e(s['actual'])}</div>" if s["actual"] else ""
            parts.append(
                f"<tr><td class='no'>{s['no']}</td><td class='st {s['status']}'>{s['status']}</td>"
                f"<td class='step'>{_e(s['description'])}</td><td class='pic'>{picture}</td>"
                f"<td class='exp'>{_e(s['expected'])}{actual}</td></tr>")
        if not r["steps"]:
            parts.append(f"<tr><td colspan='5' class='{r['status']}'>No step executed: {_e(r['message'])}</td></tr>")
        parts.append("</table></div>")
    return _page(heading, "".join(parts))


# ------------------------------------------------------------ result summary
def render_summary_report(results_by_build, title):
    """Summary of all builds: pass/fail count per build and a test case x build matrix."""
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    builds = [b for b, rows in results_by_build.items() if rows]
    expected_total = max((len(rows) for rows in results_by_build.values()), default=0)
    parts = [f"<h1>Test Result Summary: {_e(title)}</h1><div class='meta'>Generated {now}</div>",
             "<table class='summary'><tr><th>Build</th><th>Executed</th><th>Passed</th><th>Failed</th><th>Error</th>"
             "<th>Pass rate</th><th>Last run</th><th>Result</th></tr>"]
    for b in builds:
        rows = results_by_build[b]
        total = len(rows)
        passed = sum(1 for r in rows if r["status"] == "PASS")
        failed = sum(1 for r in rows if r["status"] == "FAIL")
        errors = total - passed - failed
        last_run = max((r["timestamp"] for r in rows), default="")
        result = "PASS" if passed == expected_total else "FAIL"
        if errors or total < expected_total:  # an interrupted run or an environment problem: do not trust the counts
            result = "INCOMPLETE"
        css = "ERROR" if result == "INCOMPLETE" else result
        parts.append(f"<tr><td>{_e(exporter.build_label(b))}</td><td>{total} / {expected_total}</td>"
                     f"<td class='PASS'>{passed}</td><td class='FAIL'>{failed}</td><td class='ERROR'>{errors}</td>"
                     f"<td>{passed / total * 100:.1f}%</td><td>{_e(last_run)}</td>"
                     f"<td class='{css}'><b>{result}</b></td></tr>")
    parts.append("</table><h2>Test case x build</h2><table class='matrix'><tr><th>TC</th><th>Type</th><th>Operation</th>"
                 "<th>First</th><th>Second</th><th>Int.</th><th>Severity</th>"
                 + "".join(f"<th>{_e(exporter.build_label(b))}</th>" for b in builds) + "</tr>")
    cases = {}
    for b in builds:
        for r in results_by_build[b]:
            cases.setdefault(r["tc_id"], r)
    for tc_id in sorted(cases, key=exporter.tc_num):
        c = cases[tc_id]
        cells = ""
        for b in builds:
            status = next((r["status"] for r in results_by_build[b] if r["tc_id"] == tc_id), "-")
            cells += f"<td class='{status}' style='text-align:center'><b>{status}</b></td>"
        parts.append(f"<tr><td>{_e(tc_id)}</td><td>{_e(c['type'])}</td><td>{_e(c['operation'])}</td>"
                     f"<td>{_e(c['first'])}</td><td>{_e(c['second'])}</td><td>{_e(c['integers'])}</td>"
                     f"<td>{_e(c['severity'])}</td>{cells}</tr>")
    parts.append("</table>")
    return _page(f"Test Result Summary - {title}", "".join(parts))


# ------------------------------------------------------------ defect report
def grouped_defect_rows(defects):
    """Calculator: one row per (build, bug symptom) - symptoms come from bug_triage.json."""
    rows = []
    for index, (build, symptom, members) in enumerate(exporter.group_bugs(defects), start=1):
        first = members[0]
        evidence = next((m["evidence"] for m in members if m.get("evidence")), "")
        rows.append({
            "id": f"BUG-{index:02d}", "build": exporter.build_label(build),
            "severity": min((m["severity"] for m in members), key=exporter.sev_rank),
            "description": f"{symptom}\n(example input: {first['input']})",
            "refs": ", ".join(m["tc_id"] for m in members) + f"\n({len(members)} failed test cases)",
            "expected": first["expected"], "actual": first["actual"], "picture": evidence,
        })
    return rows


def single_defect_rows(defects):
    return [{
        "id": d["id"], "build": d.get("group", ""), "severity": d.get("severity", ""),
        "description": d["title"], "refs": d["tc_id"], "expected": d["expected"], "actual": d["actual"],
        "picture": d.get("evidence", ""),
    } for d in defects]


def render_defect_report(rows, title, defect_count, suite_dir):
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    parts = [f"<h1>Defect Report: {_e(title)}</h1>",
             f"<div class='meta'>Generated {now} | Bugs: {len(rows)} | Failed test cases (defect log): {defect_count}</div>"]
    if not rows:
        parts.append("<p>No defects found.</p>")
        return _page(f"Defect Report - {title}", "".join(parts))
    parts.append("<table class='defects'><tr><th>ID</th><th>Build</th><th>Severity</th><th>Defect description</th>"
                 "<th>Ref. test case</th><th>Expected result</th><th>Actual result</th><th>Picture of actual result</th></tr>")
    for r in rows:
        picture = _img(suite_dir, r["picture"], suite_dir) if r["picture"] else "-"
        parts.append(
            f"<tr><td>{_e(r['id'])}</td><td>{_e(r['build'])}</td><td>{_e(r['severity'])}</td>"
            f"<td>{_e(r['description'])}</td><td>{_e(r['refs'])}</td><td>{_e(r['expected'])}</td>"
            f"<td>{_e(r['actual'])}</td><td class='pic'>{picture}</td></tr>")
    parts.append("</table>")
    return _page(f"Defect Report - {title}", "".join(parts))

