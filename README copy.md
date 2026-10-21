# Basic Calculator - Data-driven test (Robot Framework + Browser library)

## Setup
```
pip install -r requirements.txt
rfbrowser init
```

## Run
```
python run_tests.py                    # Prototype + Build 1-9, merged report, Excel/MD export
python run_tests.py --builds 0 --open  # Prototype only, open the report
python -m robotcode.cli robot -v BUILD:3 -d Test_Result/Build_3   # one build via robot.toml
```

## Layout
| Folder / file | Purpose |
|---|---|
| `Requirement/req.md`, `Locator/main_page.html` | Interview requirement and page source (locators) |
| `Test_case/test_cases.md` | Test cases = data source of the automation. `export_test_cases.py` creates `test_cases.xlsx` |
| `Element_Locator/` | Locators |
| `Common_keyword/` | Keywords, data-driven modifier, defect logger, report exporter, `bug_triage.json` |
| `Test_script/calculator_data_driven.robot` | One suite; one test per row of the test case table; `BUILD` variable selects the build |
| `Test_Result/` | `report.html`/`log.html` (merged), `Test_Result_Summary.*`, `Defect_Report.*`, per build `Build_N/` |

Defects are logged automatically in Test Teardown (`Log Result And Defect`) for every failed test and exported in Suite Teardown / at the end of `run_tests.py`.
