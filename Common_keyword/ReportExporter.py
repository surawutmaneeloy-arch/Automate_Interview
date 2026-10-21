"""Shared helpers of the reports: JSONL records, bug grouping (bug_triage.json), markdown/Excel tables."""
import json
from collections import OrderedDict
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


# ------------------------------------------- test case table (md / xlsx deliverable)
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
    wb.close()


# ------------------------------------------------------------- bug grouping
def sev_rank(sev):
    return SEVERITY_ORDER.index(sev) if sev in SEVERITY_ORDER else len(SEVERITY_ORDER)


def tc_num(tc_id):
    digits = "".join(ch for ch in tc_id if ch.isdigit())
    return int(digits) if digits else 0


def _load_triage():
    if TRIAGE_FILE.exists():
        return json.loads(TRIAGE_FILE.read_text(encoding="utf-8"))
    return {}


def group_bugs(defects):
    """[(build, symptom, member defects)]. Groups come from bug_triage.json, leftovers are grouped automatically."""
    triage = _load_triage()
    by_build = OrderedDict()
    for d in sorted(defects, key=lambda x: (int(x["build"]), tc_num(x["tc_id"]))):
        by_build.setdefault(str(d["build"]), []).append(d)
    result = []
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
        result += [(build, symptom, members) for symptom, members in groups]
    return result
