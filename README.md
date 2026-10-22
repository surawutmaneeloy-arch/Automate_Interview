# Interview assignment - Robot Framework test automation

Automated tests built with **Robot Framework + Browser library (Playwright) + RequestsLibrary**:

| Task | What is tested | Folder that is run |
|---|---|---|
| Ex. 2 | Basic Calculator (https://testsheepnz.github.io/BasicCalculator.html): 64 data-driven test cases, Prototype + Build 1-9 | `Test_case_robot/Calculator/` |
| Ex. 3 | Yahoo "Create account" page validation (https://login.yahoo.com/account/create), UI | `Test_case_robot/Yahoo/` |
| Ex. 4 | FakeRESTApi `Books` / `Authors` (https://fakerestapi.azurewebsites.net), API | `Test_case_robot/API/` |

Requirement documents are in `Requirement/` (`ข้อ2_Workshop_Calculator.docx`, `ข้อ3-4_การบ้าน_UI_API.docx`, `req.md`).
The goals of the work are in `Todos.md`. **AI assistants: read `AGENTS.md` first** (rules, structure, how to extend).

## 1. Deliverables ("สิ่งที่ต้องส่ง")

| Required | Where |
|---|---|
| Ex. 2 - test case table (part 1) | `Test_case/test_cases.md` and `Test_case/test_cases.xlsx` (64 cases, exported from the test data) |
| Ex. 2 - source code | this repository |
| Ex. 2 - run report | `Test_Result/Calculator/Build_<0-9>/Test_Report.pdf` (one per build) |
| Ex. 2 - bug summary table (part 3) | section 8 below and `Test_Result/Calculator/Defect_Report.pdf` |
| Ex. 3-4 - Git repository with commits and branches | this repository (work on a feature branch, merged into `main`) |
| Ex. 3-4 - README: install, run, tools, AI usage | this file (sections 2, 3, 10) |
| Ex. 3-4 - HTML test report (Ex. 3 and Ex. 4) | `Test_Result/Robot/Yahoo_API/report.html` + `log.html` (Robot Framework HTML report of both tasks, see section 3) |
| Ex. 3-4 - PDF test report / defect report | `Test_Result/Yahoo_UI/` and `Test_Result/FakeRest_API/` (`Test_Report.pdf`, `Defect_Report.pdf`) |
| Ex. 3-4 - bug / observation summary | sections 8 and 9 below |
| Ex. 3-4 - optional CI | `.github/workflows/tests.yml` |

## 2. Install

Requirements: Python 3.12 or 3.13 (recommended), Node.js 18+ (used by the Browser library), internet access.

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
rfbrowser init chromium
```

Python 3.14 note: `rfbrowser init` and the interpreter exit crash with a Windows access violation (a Python 3.14.x problem in
`logging`/grpc). Tests still run and results are correct (only the exit code of the Python process is odd). If you must use 3.14,
pin `robotframework==7.4.2 robotframework-browser==20.4.0 grpcio==1.83.0 grpcio-tools==1.83.0` and install the browser with:

```powershell
python -c "import logging,sys,runpy; logging.logThreads=False; logging.logProcesses=False; logging.logMultiprocessing=False; logging.logAsyncioTasks=False; sys.argv=['rfbrowser','init','chromium']; runpy.run_module('Browser.entry', run_name='__main__')"
```

## 3. Run

Tests are started **only with Robot** (`robotcode robot`, a wrapper that reads `robot.toml`; plain `robot` works too if you pass the
options yourself). There is no Python runner script. Run from the project root:

```powershell
robotcode robot                                   # everything: calculator on Prototype (BUILD=0), Yahoo, API
robotcode --profile calculator robot              # calculator only   (profiles: calculator, yahoo, api; the option goes BEFORE "robot")
robotcode --profile yahoo robot                   # Yahoo UI only
robotcode --profile api robot                     # API only
robotcode robot --variable BUILD:3                # the same calculator test cases against Build 3 (0 = Prototype, 1-9 = builds)
robotcode robot --include TC01                    # one test case (also --test "YH-N0*", --include severity-Critical, --include negative)
robotcode robot --dryrun                          # parse/keyword check without opening a browser
```

All calculator builds (one run per build, outputs kept apart under `Test_Result/Robot/`):

```powershell
foreach ($b in 0..9) { robotcode --profile calculator robot --variable BUILD:$b -o Robot/Build_$b/output.xml -l Robot/Build_$b/log.html -r Robot/Build_$b/report.html }
```

Yahoo + API in one run, and a separate Robot HTML report per task from its output:

```powershell
robotcode robot -o Robot/Yahoo_API/output.xml -l Robot/Yahoo_API/log.html -r Robot/Yahoo_API/report.html Test_case_robot/API Test_case_robot/Yahoo
python -m robot.rebot --suite Yahoo -o NONE -l Test_Result/Robot/yahoo_log.html -r Test_Result/Robot/yahoo_report.html Test_Result/Robot/Yahoo_API/output.xml
python -m robot.rebot --suite API   -o NONE -l Test_Result/Robot/api_log.html   -r Test_Result/Robot/api_report.html   Test_Result/Robot/Yahoo_API/output.xml
```

Refresh the calculator test case table (md + xlsx) after changing the test data:

```powershell
python Test_case/export_test_cases.py
```

Configuration is in `robot.toml` (`HEADLESS`, `BUILD`, `API_BASE_URL`, profiles). Override on the command line, e.g.
`--variable HEADLESS:False` to watch the browser or `--variable API_BASE_URL:https://other-host`.
Failing tests are expected: they are the bugs found in Builds 1-9 and the findings on the public sites (sections 8-9).
A calculator run takes about 3-4 minutes per build (Build 9 longer: its elements are missing, so steps time out).
The results are repeatable: the same test cases give the same pass/fail per build every run (Prototype 64/64; Builds 1-9 fail
8, 21, 4, 7, 1, 3, 41, 28, 60). Each build folder under `Test_Result/Calculator/` is replaced by the latest run of that build, and the
summary reads all build folders, so **let every build run to the end** - a run that is stopped or loses the browser leaves test cases
with status `ERROR`, and the summary then shows that build as `INCOMPLETE` (executed < 64) instead of PASS/FAIL. Re-run that build.

## 4. Project structure (same template for every project)

A test is built bottom-up; a layer may only use keywords of the same or a lower layer.

```
Locator/               1. locators only
Common_keyword/        2. common keywords: atomic actions/reads of one page or API (+ shared helpers, Python libraries)
Process_keyword/       3. process keywords: common keywords combined into ONE test step (action + verification)
Test_case_robot/       4. test case robot: the .robot files that are run + test case keywords + test data file, one folder per task
```

| Path | Role |
|---|---|
| `Locator/calculator_locators.resource`, `yahoo_locators.resource` | Locator variables; `main_page.html` is the saved calculator page used to find them |
| `Common_keyword/common.resource` | Shared Browser wrappers, **`Run Test Step`** (runs a step, takes the picture at the expected result, records it), `Capture Page Evidence`, `Begin/End Test Record` |
| `Common_keyword/calculator_common.resource`, `yahoo_common.resource`, `api_common.resource` | One atomic action/read per keyword for each task |
| `Common_keyword/report.resource` | `Export Pdf Reports`: prints the generated HTML to PDF with headless Chromium |
| `Common_keyword/TestRecorder.py` | Robot library: records steps, results and defects (JSONL), evidence paths, builds the report jobs |
| `Common_keyword/PdfReport.py` | Builds the HTML of the test report and the defect report |
| `Common_keyword/ReportExporter.py`, `bug_triage.json` | Shared report helpers (JSONL records, table export of the test case table) and the bug grouping of the calculator (failed test cases -> one bug symptom per build) |
| `Common_keyword/SchemaValidator.py`, `api_schemas/*.json` | JSON schema validation of API responses |
| `Process_keyword/calculator_process.resource`, `yahoo_create_account_page.resource` (Page Object), `api_process.resource` | Step-level keywords + `Capture ... Evidence` keywords |
| `Test_case_robot/Calculator/` | `calculator_data_driven.robot` (the 64 test cases), `calculator_test_data.py` (test data), `calculator_test_case.resource` (test case keywords) |
| `Test_case_robot/Yahoo/` | `__init__.robot` (suite setup/teardown), `positive.robot`, `negative.robot` (data-driven table), `yahoo_test_case.resource`, `yahoo_test_data.py` |
| `Test_case_robot/API/` | `__init__.robot`, `books_positive.robot`, `books_negative.robot` (data-driven table), `api_test_case.resource`, `api_test_data.py` |
| `Test_case/` | `test_cases.md` / `test_cases.xlsx` = the calculator test case table, `export_test_cases.py` generates them |
| `Test_Result/` | Generated output (see section 6) |
| `Requirement/` | The assignment documents |
| `robot.toml`, `requirements.txt`, `.github/workflows/tests.yml` | Config, dependencies, optional CI |
| `AGENTS.md` | Master guide for AI assistants |

## 5. How the tests work

**Data-driven.** Every test case is visible in a `.robot` file and receives its test data as an argument:

- Calculator: `calculator_test_data.py` holds one dict per case (`TC01 = dict(type="CALC", operation="Add", first="2", second="3", expected="5", ...)`).
  `calculator_data_driven.robot` lists the 64 tests (`Test Template`), each one passes its dict: `TC01 Add [2, 3] int=No (CALC)` -> `${TC01}`.
  The build under test is the variable `${BUILD}`: the same test set runs against every build without copying code.
  Expected values come from the data (mathematical rules), never from the page.
- Yahoo / API negative tests: one row of the table in `negative.robot` / `books_negative.robot` = one test; shared values live in `*_test_data.py`.
- Calculator test case types: `CALC` (calculate), `CLEAR` (calculate then Clear), `INT_TOGGLE` (tick "Integers only" after calculating),
  `INT_STATE` (checkbox enabled/disabled per operation), `CLEAR_STATE` (Clear button on a fresh page).

**Step runner.** A test case keyword prepares the record (test data, pre-condition), then calls
`Run Test Step  <step text>  <expected text>  <process keyword>  <args>` for each step. After the keyword
(pass or fail) a picture is taken at the expected result and the step is recorded with its status. A failed step stops the test
and its picture becomes the picture of the defect. Yahoo/API: a message starting with `Setup failed` is stored as `ERROR`, not as a defect.

**Rules** (details in `AGENTS.md`): no hard waits (`Sleep`) - Playwright auto-waiting and assertion retries only; base URLs are configuration;
Yahoo registration is never completed (every negative row contains something Yahoo rejects, valid data is typed but never submitted).

## 6. Reports (output in `Test_Result/`, regenerated at every run)

| File | Content |
|---|---|
| `Calculator/Build_<n>/Test_Report.pdf` | **Test report.** Per test case: header (test case name, test data, pre-condition, total status) and a steps table (test status, test step, picture, expected; actual for failed steps) |
| `Calculator/Defect_Report.pdf` | **Defect report** (Builds 1-9, one row per bug symptom): description, ref. test cases, expected, actual, picture of the actual result |
| `Calculator/Test_Result_Summary.pdf` | **Result summary** of all builds: executed / passed / failed / error count and last run time per build (`INCOMPLETE` when a build was not fully executed) and a test case x build matrix |
| `Yahoo_UI/`, `FakeRest_API/` | `Test_Report.pdf` and `Defect_Report.pdf` of Ex. 3 and Ex. 4 (API steps: the picture shows the request, status and response body) |
| `Robot/.../report.html`, `log.html`, `output.xml` | Standard Robot Framework HTML report/log |
| `*/evidence/*.jpeg`, `results.jsonl`, `defects.jsonl` | Pictures and raw records the PDFs are built from |

## 7. Test cases

- **Calculator (64):** see `Test_case/test_cases.md` (technique and rationale per case: normal values, boundaries, invalid input, Integers only, Clear).
  Assumptions made where the requirement is silent are listed in the same file.
- **Yahoo (21):** positive YH-P01..P04 (valid data shows no error, strong password, Terms and Privacy links open), negative YH-N01..N17
  (empty form, taken username, invalid characters / too short / too long username, short / weak / same-as-username / same-as-name password,
  31 Feb, future year, under-age, month 13, numeric / special-character names). See `Test_case_robot/Yahoo/*.robot`.
- **API (16):** positive API-P01..P07 (GET list, GET by id, POST, PUT, DELETE, authors of a book, created book can be read back),
  negative API-N01..N09. Status code, response body and JSON schema are checked. See `Test_case_robot/API/*.robot`.

## 8. Bug summary

### Ex. 2 - Basic Calculator, Builds 1-9 (Prototype passes all 64 test cases)

| Build | Bug symptom | Input (example) | Expected | Actual | Severity | Failed TCs |
|---|---|---|---|---|---|---|
| Build 1 | No numeric validation - text input is accepted and the answer shows NaN instead of the 'Number x is not a number' error | Add: First='abc', Second='1', Integers only=No | answer='' \| error='Number 1 is not a number' | answer='NaN' \| error='' | High | 8 |
| Build 2 | Add and Concatenate are swapped - Add joins the text (2 + 3 = 23) and ignores Integers only | Add: First='2', Second='3', Integers only=No | answer='5' \| error='' | answer='23' \| error='' | Critical | 16 |
| Build 2 | Add and Concatenate are swapped - Concatenate adds the numbers / returns NaN for text | Concatenate: First='abc', Second='def', Integers only=No | answer='abcdef' \| error='' | answer='' \| error='Number 1 is not a number' | Critical | 5 |
| Build 3 | Concatenate validates the inputs as numbers - text cannot be concatenated | Concatenate: First='abc', Second='def', Integers only=No | answer='abcdef' \| error='' | answer='' \| error='Number 1 is not a number' | Critical | 3 |
| Build 3 | Integers only checkbox stays enabled when Concatenate is selected | Operation: Concatenate | integers_checkbox=disabled | integers_checkbox=enabled | High | 1 |
| Build 4 | Answer is always rounded to an integer even when Integers only is not ticked | Add: First='1.5', Second='2.25', Integers only=No | answer='3.75' \| error='' | answer='3' \| error='' | Critical | 5 |
| Build 4 | Integers only checkbox is locked (disabled) for Add / Divide | Operation: Add | integers_checkbox=enabled | integers_checkbox=disabled | Medium | 2 |
| Build 5 | Clear button is disabled on a fresh page | Fresh page (no calculation) | clear_button=enabled | clear_button=disabled | Medium | 1 |
| Build 6 | Divide by zero is not checked - Infinity / NaN is shown instead of the error message | Divide: First='5', Second='0', Integers only=No | answer='' \| error='Divide by zero error!' | answer='Infinity' \| error='' | Critical | 3 |
| Build 7 | First operand uses the previous answer instead of First number field (first calculation uses empty/0) | Add: First='2', Second='3', Integers only=No | answer='5' \| error='' | answer='3' \| error='' | Critical | 41 |
| Build 8 | First and Second number are swapped - order-dependent operations give wrong results and the validation message names the wrong field | Subtract: First='5', Second='3', Integers only=No | answer='2' \| error='' | answer='-2' \| error='' | Critical | 28 |
| Build 9 | Second number field and Calculate button vanish - no calculation can be performed | Add: First='2', Second='3', Integers only=No | answer='5' \| error='' | Step failed: TimeoutError: locator.fill: Timeout 5000ms exceeded. | Critical | 60 |

Build 0 (Prototype): 64 / 64 passed. Failed test cases per build: 8, 21, 4, 7, 1, 3, 41, 28, 60 (Builds 1-9, 173 in total). Full list per test case: `Test_Result/Calculator/Test_Result_Summary.pdf`; with pictures: `Defect_Report.pdf`.

### Ex. 3 - Yahoo create account (public production site, results can change)

| Test | Input | Expected | Actual | Assessment |
|---|---|---|---|---|
| YH-N15 | First name `1234` | Error at First name | No error at the field | Observation / probable bug: names with only digits are accepted |
| YH-N16 | First name `@#$%` | Error at First name | No error at the field | Observation / probable bug: special characters accepted |
| YH-N17 | Last name `5678^&*` | Error at Last name | No error at the field | Observation / probable bug: digits and special characters accepted |

All other Yahoo tests pass: required-field check, taken username, invalid / short / long username, password rules, date of birth rules
(31 Feb, future year, month 13, under-age rejection page) and the Terms / Privacy links.
Observations about the page itself: the form is silently reset if the input is typed before the React page is hydrated, and the form is
ignored when Chromium reports itself as automated (`navigator.webdriver`) - the tests wait for hydration and start Chromium with
`--disable-blink-features=AutomationControlled`. Stale error messages stay in the DOM (collapsed), so only visible messages are counted.

### Ex. 4 - FakeRESTApi

Negative cases: the expected status is defined by REST conventions (400 bad input, 404 missing resource, 405 unsupported method).

| Test | Request | Expected | Actual | Bug? |
|---|---|---|---|---|
| API-N01 | GET /api/v1/Books/99999 | 404 | 404 | matches |
| API-N02 | GET /api/v1/Books/abc | 400 | 400 | matches |
| API-N03 | POST /api/v1/Books, empty body | 400 | 400 | matches |
| API-N04 | POST, malformed JSON | 400 | 400 | matches |
| API-N05 | POST, `pageCount: "abc"` | 400 | 400 | matches |
| API-N06 | PATCH /api/v1/Books/1 | 405 | 405 | matches |
| API-N07 | DELETE /api/v1/Books (collection) | 405 | 405 | matches |
| API-N08 | PUT /api/v1/Books/99999 | 404 | **200** | **Yes** - updating a book that does not exist should not succeed |
| API-N09 | DELETE /api/v1/Books/99999 | 404 | **200** | **Yes** - deleting a book that does not exist should not succeed |

Suspicious behaviour (observation):

- API-P07: a book created with `POST /api/v1/Books` (id 201) is **not** returned by `GET /api/v1/Books/201` (404). The service is a mock that
  does not persist writes, so POST/PUT/DELETE only echo the request. Not a bug of a mock, but a real API must persist - recorded as an observation.
- All positive cases (GET list / by id, POST, PUT, DELETE, authors of a book) pass the status, body and schema checks.

## 9. What must not be automated on production (Yahoo) and how to fix it

- **Completing a registration / submitting valid data:** creates real accounts, triggers phone/SMS verification and CAPTCHA, and gets the IP blocked.
  Tests only type valid data and only submit data that Yahoo rejects.
- **Username availability checks against the live database:** the "taken username" test depends on a real account (`admin`) and leaks lookups
  to the production service. Fix: run against a staging environment or a test double of the availability service.
- **CAPTCHA / bot detection:** the page reacts to automation (reset form, ignored input). Do not bypass it; fix by using a test environment
  with the protection switched off or a test token agreed with the owner.
- **Results depend on a third-party site:** messages and rules can change, so a failing test is a finding, not a reason to weaken an assertion.

## 10. Tools and AI usage

- Tools: Robot Framework 7, Browser library (Playwright/Chromium), RequestsLibrary, jsonschema, xlsxwriter, RobotCode (VS Code extension and CLI).
- AI (GitHub Copilot) was used to design the folder template, write the keywords, the report generators (HTML printed to PDF with Chromium),
  the test data and this documentation, and to run the tests and analyse failures. Locators, expected results (maths rules, REST conventions)
  and the test case design were checked against the requirement documents and the pages. `AGENTS.md` lets another AI continue the work.

## 11. How to continue / extend

See `AGENTS.md` section 6. In short: a new calculator case = a `TCnn = dict(...)` in `calculator_test_data.py` + a test in
`calculator_data_driven.robot` + `python Test_case/export_test_cases.py`; a new Yahoo / API negative case = a row in the table;
a new bug symptom = `Common_keyword/bug_triage.json`. Before finishing a change run `robotcode robot --dryrun` and the affected profile
and check the PDFs in `Test_Result/`.

## 12. Git

Work on a feature branch and merge into `main`:

```powershell
git switch -c feature/<name>
git add -A ; git commit -m "<message>"
git switch main ; git merge feature/<name>
```

`.gitignore` excludes `.venv`, `node_modules`, `__pycache__` and the Playwright logs. The repository link is to be added after pushing.
