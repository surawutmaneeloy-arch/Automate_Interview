# AGENTS.md - master guide for AI assistants

Read this file first. It explains what every folder/file is and the rules to follow when changing the project.
Human-facing instructions (install, run, findings) are in `README.md`; the original goals are in `Todos.md`.

## 1. Project purpose

Interview assignment implemented with **Robot Framework + Browser (Playwright) + RequestsLibrary**.

| Task | Source requirement (`Requirement/`) | Folder run |
|---|---|---|
| Ex. 2 - Basic Calculator, data-driven, Prototype + Build 1-9 | `ข้อ2_Workshop_Calculator.docx`, `req.md` | `Test_case_robot/Calculator/` |
| Ex. 3 - Yahoo "Create account" UI validation | `ข้อ3-4_การบ้าน_UI_API.docx` | `Test_case_robot/Yahoo/` |
| Ex. 4 - FakeRESTApi `Books`/`Authors` API | `ข้อ3-4_การบ้าน_UI_API.docx` | `Test_case_robot/API/` |

Deliverables ("สิ่งที่ต้องส่ง"): test case table, source code (Git), run report, bug summary table;
for Ex. 3-4 also README, HTML test report, bug/observation summary, optional CI.

## 2. Layered structure (same template for every project)

A test is built bottom-up. A layer may only use keywords of the same or a lower layer.

```
Locator/               1. locators only (no keywords)
Common_keyword/        2. common keywords: atomic actions/reads of ONE page or API (+ shared helpers, Python libs)
Process_keyword/       3. process keywords: common keywords combined into ONE test step (action + verification)
Test_case_robot/       4. test case robot: per project folder = the runnable .robot files (suite settings + test cases),
                          the test case keywords that turn one test case's data into steps, and the test data file
```

| Folder / file | Role |
|---|---|
| `Locator/calculator_locators.resource`, `yahoo_locators.resource` | Locator variables (`${LOC_*}`, `${YH_*}`) and the small JS snippets used for evidence/hydration. `main_page.html` = saved calculator page used to find locators |
| `Common_keyword/common.resource` | Shared Browser wrappers (`Type Into Field`, `Click Element`, `Read Field Value` ...), **`Run Test Step`** (step runner), `Capture Page Evidence`, `Begin/End Test Record` |
| `Common_keyword/calculator_common.resource`, `yahoo_common.resource`, `api_common.resource` | Project-level common keywords (one atomic action/read each) |
| `Common_keyword/report.resource` | `Export Pdf Reports`: prints the generated HTML to PDF with headless Chromium |
| `Common_keyword/TestRecorder.py` | Robot library: records steps/results/defects as JSONL, evidence paths, builds report jobs |
| `Common_keyword/PdfReport.py` | Builds the HTML of the test report (header + steps table) and defect report |
| `Common_keyword/ReportExporter.py` | Shared report helpers (JSONL, md/xlsx table of the test case table) and bug grouping (`bug_triage.json`) for the calculator |
| `Common_keyword/SchemaValidator.py`, `api_schemas/*.json` | JSON schema check for API responses |
| `Common_keyword/bug_triage.json` | Human-written bug symptoms per build (maps failed TCs to one bug) |
| `Process_keyword/*.resource` | Step-level keywords (`calculator_process`, `yahoo_create_account_page` = Page Object, `api_process`) + `Capture ... Evidence` keywords |
| `Test_case_robot/<Project>/` | One folder per project (`Calculator/`, `Yahoo/`, `API/`) = **the folder that is run** (`robot.toml` paths). Holds: the `.robot` files that list the test cases (Yahoo/API: `__init__.robot` = suite setup/teardown, `positive`, data-driven `negative`), `<x>_test_case.resource` (the test case keywords: `Prepare ... Test`, `Run ... Test Case`, `Finish ... Test`, suite start/finish) and `<x>_test_data.py` = Robot **variable file** with the test data |
| `Test_case_robot/Calculator/calculator_test_data.py` | One dict per calculator test case (`TC01 = dict(type=..., operation=..., first=..., expected=...)`) |
| `Test_case_robot/Calculator/calculator_data_driven.robot` | Lists every calculator test case (name, documentation, tags) and passes its dict to the template keyword `Run Calculator Test Case` |
| `Test_case/test_cases.md`, `test_cases.xlsx` | Human-readable calculator test case table (Ex. 2 part 1), **exported** from `calculator_test_data.py` by `python Test_case/export_test_cases.py` |
| `Test_Result/` | Generated output - never edit by hand (see section 5) |
| `robot.toml` | RobotCode/Robot config: paths, output dir, variables (`HEADLESS`, `BUILD`, `API_BASE_URL`), profiles |
| `requirements.txt` | Python dependencies. `package.json` only belongs to the Playwright tooling used by `rfbrowser` |
| `.github/workflows/tests.yml` | Optional CI: install, `rfbrowser init`, `robotcode robot`, upload `Test_Result` |

## 3. Hard rules (from `Todos.md` and the assignment)

1. **No Python runner.** Tests are started only with Robot (`robotcode robot` / `robot`), never with a `.py` script.
   Python is allowed only as Robot libraries/variable files inside `Common_keyword/` and `Test_case_robot/`.
2. **Every step captures a picture at its expected result** (pass or fail). Do it only through `Run Test Step`;
   a suite chooses the capture keyword with `${CAPTURE_KEYWORD}` (`Capture Page/Calculator/Yahoo/Api Evidence`).
   API tests have no picture; the request/response text is shown instead.
3. **Test report = PDF.** Header: test case name, test data, pre-condition, total status.
   Rows: test status, test step, picture (between step and expected), expected.
4. **Defect report = PDF table:** defect description, ref. test case, expected, actual, picture of actual result.
5. **Expected results come from the data or a correct calculation - never from reading the page.**
6. **No hard waits** (`Sleep`, `waitForTimeout`). Use Playwright auto-waiting, assertion retries (`Get Text ... validate ...`),
   `Wait For Elements State/Function`. Bounded retries (`Wait Until Keyword Succeeds`) only for page loads.
7. **Never complete a Yahoo registration** and never bypass CAPTCHA/phone verification. Only invalid or unsubmitted data;
   every negative row must contain something Yahoo rejects (e.g. a taken username). Valid data is typed but never submitted with Next.
8. Base URLs are configuration (`API_BASE_URL` in `robot.toml`), not hard-coded in tests.
9. Page Object Model for Yahoo: locators in `Locator/`, interactions in `Process_keyword/yahoo_create_account_page.resource`.
10. **Data-driven = every test case is visible in a `.robot` file** (`Test Template` + one test per case) and its data is
    passed as arguments (inline row or a record of the `<x>_test_data.py` file). Never hard-code test data inside a keyword,
    never generate tests invisibly (no pre-run modifier), never copy-paste a test per row or per build.
11. The build under test is the variable `${BUILD}` (0 = Prototype, 1-9); the same test cases run against every build.

## 4. How a test runs (data flow)

```
Test_case_robot/<P>/*.robot (test case + data as argument)
  -> template/test case keyword (Prepare = Begin Test Record + pre-condition, then the steps)
  -> Run Test Step "<step>" "<expected>" <process keyword> args
        -> process keyword (common keywords + verification, sets ${STEP_ACTUAL})
        -> ${CAPTURE_KEYWORD} saves Test_Result/<suite>/<group>/evidence/<TC>_step<n>.jpeg
        -> Add Step Record
  -> Test Teardown: Finish Test Record (writes results.jsonl, and defects.jsonl when FAIL)
Suite Teardown: Export Pdf Reports -> Test_Report.pdf per group + Defect_Report.pdf
```

- A failed step stops the test; the failing step's picture becomes the defect picture.
- A message starting with `Setup failed` is stored as `ERROR` (environment problem), not as a defect.
- Variables shared between steps are **test-scoped** (`VAR ... scope=TEST`): `${STEP_NO}`, `${STEP_ACTUAL}`,
  `${STEP_EVIDENCE}`, `${EXPECTED_TEXT}`. Suite-level overrides in a parent suite need `children=${TRUE}`.
- Calculator: test name starts with the TC id (`TC01 Add [2, 3] int=No (CALC)`); tags = type, category, operation,
  `severity-<x>`, `TC<nn>`, `build-<n>`. Reports go to `Test_Result/Calculator/Build_<n>/` (one PDF per build) and
  the defect report groups the bugs of all builds found on disk (`bug_triage.json`).

## 5. Commands

```
pip install -r requirements.txt ; rfbrowser init chromium
robotcode robot                                   # everything, calculator on Prototype (BUILD=0)
robotcode --profile calculator robot              # profiles: calculator, yahoo, api  (profile option goes BEFORE "robot")
robotcode robot --variable BUILD:3                # calculator against Build 3 (the same test cases)
foreach ($b in 0..9) { robotcode --profile calculator robot --variable BUILD:$b -o Robot/Build_$b/output.xml -l Robot/Build_$b/log.html -r Robot/Build_$b/report.html }
robotcode robot --include TC01                    # one test case (also --test "YH-N0*", --include severity-Critical)
python -m robot.rebot --suite "Yahoo" -o NONE -l yahoo_log.html -r yahoo_report.html Test_Result/output.xml
```

Output (`Test_Result/`, regenerated every run, safe to delete):
`report.html`/`log.html`/`output.xml` (Robot), `Calculator/Build_N/Test_Report.pdf`, `Calculator/Defect_Report.pdf`,
`Calculator/Test_Result_Summary.pdf` (all builds), `Yahoo_UI/` and `FakeRest_API/` with `Test_Report.pdf` + `Defect_Report.pdf`,
`evidence/` pictures and `results.jsonl`/`defects.jsonl` (raw records).

## 6. How to extend (checklist)

- **New calculator test case:** add `TC65 = dict(...)` to `Test_case_robot/Calculator/calculator_test_data.py` and a test
  (name, `[Documentation]`, `[Tags]`, row `${TC65}`) to `calculator_data_driven.robot`; then
  `python Test_case/export_test_cases.py`. Types: `CALC`, `CLEAR`, `INT_TOGGLE`, `INT_STATE`, `CLEAR_STATE`
  (a new type needs a branch in `Run Calculator Test Case`). Empty value = `""`. Expected values come from maths rules.
- **New Yahoo negative case:** add a row in `Test_case_robot/Yahoo/negative.robot`
  (`first, last, username, password, mm, dd, yyyy, error field, expected message, severity`; `*` = any message;
  fields: `FIRST_NAME LAST_NAME USERNAME PASSWORD DOB PAGE`). Shared values live in `yahoo_test_data.py`.
- **New API case:** positive -> keyword in `api_test_case.resource` + test in `books_positive.robot`; negative -> row in `books_negative.robot`.
  Expected status follows REST conventions (400 bad input, 404 missing, 405 unsupported method). Payloads live in `api_test_data.py`.
- **New page/project:** create `Locator/<x>_locators`, `Common_keyword/<x>_common`, `Process_keyword/<x>_process`,
  `Test_case_robot/<X>/` (suite `.robot`, `<x>_test_case.resource`, data file), and a `Capture <X> Evidence` keyword; set
  `${CAPTURE_KEYWORD}` in the suite setup.
- **New bug symptom (calculator):** edit `Common_keyword/bug_triage.json` (build -> symptom + TC list or `"*"`).

## 7. Conventions and gotchas

- One keyword = one responsibility; names are Title Case sentences. Locators never appear in `Test_case_robot/`.
- Keep `.robot`/`.resource` files UTF-8 **without BOM** (a BOM breaks `robot.toml`). Cells are separated by 4 spaces; a single space stays inside the value.
- In Robot, `id=` as a leading word of an argument is read as a named argument - name arguments `locator`/`value`, not `id`.
- `${SUITE_NAME}` is a Robot built-in; use `${REPORT_SUITE}`.
- JS snippets in variable tables must be single-line with single spaces.
- Yahoo page: type with `Type Keys Into Field` (not `Fill Text`) and wait for React hydration (`${YH_HYDRATED_JS}`) before typing,
  otherwise Yahoo wipes the input. Chromium needs `--disable-blink-features=AutomationControlled` (set in `Start Browser Session`)
  or the form is silently ignored. Error messages have id `<input id>-error`; stale errors are collapsed, so count only visible ones.
- Calculator: the page shows "Calculating ..." for up to 1 s; divide-by-zero never leaves that state (by design of the page).
- Yahoo/API are public production systems: results can change. A failing test there is a finding to document in `README.md`, not a reason to weaken the assertion.
- Do not commit `Test_Result/**/evidence`, `node_modules`, `browser/`, `__pycache__`.
- Do not create extra documentation files unless asked; update `README.md` (human) or this file (AI) instead.
- Edit files with the editor tools; do not rewrite files with long PowerShell one-liners (a mangled command once emptied a file).

## 8. Before finishing a change

1. Run the affected suite/profile and check `Test_Result/<suite>/.../Test_Report.pdf` and `Defect_Report.pdf` open and look right.
2. Confirm no `[ ERROR ]`/`[ WARN ]` import messages in the console (`robotcode robot --dryrun` is a quick check).
3. Keep this file in sync when folders, keywords' roles, or rules change.
