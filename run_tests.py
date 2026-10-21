"""Run the data-driven calculator suite for one or more builds, merge the reports and export results/defects.

Usage:
    python run_tests.py                 # Prototype + Build 1-9
    python run_tests.py --builds 0      # Prototype only
    python run_tests.py --builds 0 3 5 --jobs 2 --headed --open
"""
import argparse
import shutil
import subprocess
import sys
import webbrowser
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

ROOT = Path(__file__).resolve().parent
RESULT = ROOT / "Test_Result"
sys.path.insert(0, str(ROOT / "Common_keyword"))

from ReportExporter import build_label, export_consolidated  # noqa: E402


def run_build(build, headed):
    out = RESULT / f"Build_{build}"
    shutil.rmtree(out, ignore_errors=True)
    cmd = [sys.executable, "-m", "robotcode.cli", "robot", "-d", str(out), "--name", build_label(build),
           "-v", f"BUILD:{build}", "-v", f"HEADLESS:{not headed}"]
    proc = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True)
    (RESULT / f"Build_{build}_console.txt").write_text(proc.stdout + proc.stderr, encoding="utf-8")
    summary = [line for line in proc.stdout.splitlines() if " tests, " in line][-1:] or ["(no summary - see console file)"]
    print(f"{build_label(build):<10} {summary[0].strip()}", flush=True)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--builds", nargs="+", type=int, default=list(range(10)))
    parser.add_argument("--jobs", type=int, default=4, help="builds executed in parallel")
    parser.add_argument("--headed", action="store_true", help="show the browser")
    parser.add_argument("--open", action="store_true", help="open the merged Robot report")
    args = parser.parse_args()

    RESULT.mkdir(exist_ok=True)
    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        list(pool.map(lambda b: run_build(b, args.headed), args.builds))

    outputs = [str(RESULT / f"Build_{b}" / "output.xml") for b in sorted(args.builds)
               if (RESULT / f"Build_{b}" / "output.xml").exists()]
    subprocess.run([sys.executable, "-m", "robot.rebot", "--name", "Basic Calculator", "-d", str(RESULT),
                    "-o", "output.xml", "-l", "log.html", "-r", "report.html", *outputs],
                   cwd=ROOT, capture_output=True)
    export_consolidated(RESULT)
    print(f"Report: {RESULT / 'report.html'}")
    if args.open:
        webbrowser.open((RESULT / "report.html").as_uri())


if __name__ == "__main__":
    main()
