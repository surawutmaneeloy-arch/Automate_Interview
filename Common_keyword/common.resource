*** Settings ***
Documentation       Common keywords: thin wrappers around the Browser library plus the step runner that records
...                 every test step with its expected result and a picture taken at the expected result.
Library             Browser    auto_closing_level=MANUAL
Library             Collections
Library             OperatingSystem
Library             TestRecorder.py


*** Variables ***
${HEADLESS}             True
${TIMEOUT}              5s
${NAV_TIMEOUT}          30s
${EMPTY_TOKEN}          (empty)
&{VIEWPORT}             width=1000    height=800
${CAPTURE_KEYWORD}      Capture Page Evidence
${STEP_NO}              0
${STEP_ACTUAL}          ${EMPTY}
${STEP_EVIDENCE}        ${EMPTY}


*** Keywords ***
# ------------------------------------------------------------------ browser session
Start Browser Session
    Set Browser Timeout    ${TIMEOUT}
    New Browser    chromium    headless=${HEADLESS}    args=["--disable-blink-features=AutomationControlled"]

Stop Browser Session
    Close Browser    ALL

Open New Context
    New Context    viewport=${VIEWPORT}    locale=en-US

Close Current Context
    Run Keyword And Ignore Error    Close Context    CURRENT

Open Page With Retry
    [Arguments]    ${url}
    Set Browser Timeout    ${NAV_TIMEOUT}
    Wait Until Keyword Succeeds    3x    2s    New Page    ${url}    wait_until=domcontentloaded
    Set Browser Timeout    ${TIMEOUT}

# ------------------------------------------------------------------ element actions
Type Into Field
    [Arguments]    ${locator}    ${value}
    Fill Text    ${locator}    ${value}

Type Keys Into Field
    [Arguments]    ${locator}    ${value}
    Type Text    ${locator}    ${value}    delay=20ms

Click Element
    [Arguments]    ${locator}
    Click    ${locator}

Choose Option By Label
    [Arguments]    ${locator}    ${label}
    Select Options By    ${locator}    label    ${label}

Choose Option By Value
    [Arguments]    ${locator}    ${value}
    Select Options By    ${locator}    value    ${value}

Tick Checkbox
    [Arguments]    ${locator}
    Check Checkbox    ${locator}

Read Field Value
    [Arguments]    ${locator}
    ${value}=    Get Property    ${locator}    value
    RETURN    ${value}

Read Element Text
    [Arguments]    ${locator}
    ${text}=    Get Text    ${locator}
    RETURN    ${text}

Read Selected Label
    [Arguments]    ${locator}
    ${label}=    Get Selected Options    ${locator}    label
    RETURN    ${label}[0]

Read Element Enabled State
    [Arguments]    ${locator}
    ${disabled}=    Get Property    ${locator}    disabled
    ${state}=    Set Variable If    ${disabled}    disabled    enabled
    RETURN    ${state}

# ------------------------------------------------------------------ verification
Verify Text Equals
    [Documentation]    Keeps the observed value in ${STEP_ACTUAL} so the report shows it next to the expected result.
    [Arguments]    ${actual}    ${expected}
    VAR    ${STEP_ACTUAL}    ${actual}    scope=TEST
    Should Be Equal As Strings    ${actual}    ${expected}    Expected [${expected}] but was [${actual}]

Verify Text Contains
    [Arguments]    ${actual}    ${expected}
    VAR    ${STEP_ACTUAL}    ${actual}    scope=TEST
    Should Contain    ${actual}    ${expected}    Expected text containing [${expected}] but was [${actual}]

# ------------------------------------------------------------------ steps with evidence
Begin Test Record
    [Arguments]    ${suite}    ${group}    ${tc_id}    ${data}    ${precondition}    ${severity}=    ${meta}=${NONE}
    ...    ${group_label}=
    VAR    ${STEP_NO}    0    scope=TEST
    Start Test Record    ${suite}    ${group}    ${tc_id}    ${TEST NAME}    ${data}    ${precondition}    ${severity}
    ...    ${meta}    ${group_label}

End Test Record
    [Arguments]    ${expected}=${EMPTY}    ${actual}=${EMPTY}
    Finish Test Record    ${TEST STATUS}    ${TEST MESSAGE}    ${expected}    ${actual}

Run Test Step
    [Documentation]    Runs a step keyword, takes the evidence at the expected result (pass or fail), records the step
    ...    and fails the test when the step failed.
    [Arguments]    ${description}    ${expected}    ${keyword}    @{args}
    VAR    ${STEP_NO}    ${{ ${STEP_NO} + 1 }}    scope=TEST
    VAR    ${STEP_ACTUAL}    ${EMPTY}    scope=TEST
    VAR    ${STEP_EVIDENCE}    ${EMPTY}    scope=TEST
    ${status}    ${message}=    Run Keyword And Ignore Error    ${keyword}    @{args}
    ${picture}=    Run Keyword    ${CAPTURE_KEYWORD}    ${STEP_NO}
    IF    "${status}" == "FAIL" and not $STEP_ACTUAL
        ${first_line}=    Evaluate    $message.strip().splitlines()[0] if $message.strip() else 'no message'
        VAR    ${STEP_ACTUAL}    Step failed: ${first_line}    scope=TEST
    END
    Add Step Record    ${description}    ${expected}    ${status}    ${STEP_ACTUAL}    ${picture}    ${STEP_EVIDENCE}
    IF    "${status}" == "FAIL"    Fail    ${message}

Capture Page Evidence
    [Arguments]    ${step_no}
    ${base}=    Evidence Path    ${step_no}
    ${status}    ${path}=    Run Keyword And Ignore Error    Take Screenshot    ${base}    fileType=jpeg    quality=80
    IF    "${status}" == "FAIL"    RETURN    ${EMPTY}
    RETURN    ${path}
