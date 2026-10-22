*** Settings ***
Documentation       Test case keywords: migrate one test case record (a dict of calculator_test_data.py, passed as an
...                 argument by the test case robot file) into the steps of a test case by combining process keywords.
Resource            ../../Common_keyword/common.resource
Resource            ../../Common_keyword/report.resource
Resource            ../../Process_keyword/calculator_process.resource


*** Variables ***
${REPORT_SUITE}     Calculator


*** Keywords ***
Start Calculator Suite
    Set Suite Variable    ${CAPTURE_KEYWORD}    Capture Calculator Evidence
    Start Browser Session

Finish Calculator Suite
    Stop Browser Session
    Export Pdf Reports    ${REPORT_SUITE}    Basic Calculator

Prepare Calculator Test
    [Documentation]    Pre-condition: the calculator is open on the build given by ${BUILD}.
    [Arguments]    ${tc_id}    ${case}
    ${label}=    Set Variable If    "${BUILD}" == "0"    Prototype    Build ${BUILD}
    IF    "${case}[type]" == "INT_STATE"
        ${data}=    Create Dictionary    Build=${label}    Operation=${case}[operation]
        ...    Expected checkbox state=${case}[expected]
        ${input}=    Set Variable    Operation: ${case}[operation]
    ELSE IF    "${case}[type]" == "CLEAR_STATE"
        ${data}=    Create Dictionary    Build=${label}    Expected Clear button state=${case}[expected]
        ${input}=    Set Variable    Fresh page (no calculation)
    ELSE
        ${data}=    Create Dictionary    Build=${label}    Operation=${case}[operation]
        ...    First number=${case}[first]    Second number=${case}[second]    Integers only=${case}[integers]
        ...    Expected result=${case}[expected]    Expected error=${case}[expected_error]
        ${input}=    Set Variable
        ...    ${case}[operation]: First='${case}[first]', Second='${case}[second]', Integers only=${case}[integers]
    END
    ${meta}=    Create Dictionary    build=${BUILD}    type=${case}[type]    category=${case}[category]
    ...    operation=${case}[operation]    first=${case}[first]    second=${case}[second]
    ...    integers=${case}[integers]    input=${input}
    Begin Test Record    ${REPORT_SUITE}    Build_${BUILD}    ${tc_id}    ${data}
    ...    Browser is open and ${BASE_URL} is loaded with ${label} selected in the Build dropdown
    ...    ${case}[severity]    ${meta}    ${label}
    ${status}    ${message}=    Run Keyword And Ignore Error
    ...    Wait Until Keyword Succeeds    3x    2s    Open Calculator For Test
    IF    "${status}" == "FAIL"    Fail    Setup failed: ${message}

Open Calculator For Test
    Open New Context
    TRY
        Open Calculator With Build    ${BUILD}
    EXCEPT    AS    ${error}
        Close Current Context
        Fail    ${error}
    END

Run Calculator Test Case
    [Documentation]    Template keyword: ${case} is one record of calculator_test_data.py.
    [Arguments]    ${case}
    ${tc_id}=    Evaluate    $TEST_NAME.split()[0]
    Prepare Calculator Test    ${tc_id}    ${case}
    ${type}=    Set Variable    ${case}[type]
    ${operation}=    Set Variable    ${case}[operation]
    ${first}=    Set Variable    ${case}[first]
    ${second}=    Set Variable    ${case}[second]
    ${integers}=    Set Variable    ${case}[integers]
    ${expected}=    Set Variable    ${case}[expected]
    ${expected_error}=    Set Variable    ${case}[expected_error]
    ${tick}=    Set Variable If    "${integers}" == "Yes"    ${SPACE}and tick 'Integers only'    ${EMPTY}
    ${enter_step}=    Set Variable
    ...    Select Operation '${operation}', enter First number '${first}' and Second number '${second}'${tick}
    ${enter_expected}=    Set Variable    The selected operation and the entered values are displayed in the fields
    ${result_expected}=    Describe Expected Result    ${expected}    ${expected_error}
    IF    "${type}" == "CALC"
        VAR    ${EXPECTED_TEXT}    answer='${expected}' | error='${expected_error}'    scope=TEST
        Run Test Step    ${enter_step}    ${enter_expected}
        ...    Enter Calculation Data    ${operation}    ${first}    ${second}    ${integers}
        Run Test Step    Click Calculate    ${result_expected}
        ...    Click Calculate And Verify Result    ${expected}    ${expected_error}
    ELSE IF    "${type}" == "CLEAR"
        VAR    ${EXPECTED_TEXT}    answer='' | error='' | integers_checked=False    scope=TEST
        Run Test Step    ${enter_step}    ${enter_expected}
        ...    Enter Calculation Data    ${operation}    ${first}    ${second}    ${integers}
        Run Test Step    Click Calculate    An answer or an error message is displayed
        ...    Click Calculate And Verify Output Shown
        Run Test Step    Click Clear
        ...    Answer field and error message are empty and 'Integers only' is not ticked
        ...    Click Clear And Verify Reset
    ELSE IF    "${type}" == "INT_TOGGLE"
        VAR    ${EXPECTED_TEXT}    answer='${expected}' | error='${expected_error}'    scope=TEST
        Run Test Step    ${enter_step}    ${enter_expected}
        ...    Enter Calculation Data    ${operation}    ${first}    ${second}    ${integers}
        Run Test Step    Click Calculate    An answer or an error message is displayed
        ...    Click Calculate And Verify Output Shown
        Run Test Step    Tick 'Integers only' after the calculation    ${result_expected}
        ...    Tick Integers Only And Verify Answer    ${expected}    ${expected_error}
    ELSE IF    "${type}" == "INT_STATE"
        VAR    ${EXPECTED_TEXT}    integers_checkbox=${expected}    scope=TEST
        Run Test Step    Select Operation '${operation}'    'Integers only' checkbox is ${expected}
        ...    Verify Integers Only State After Selecting Operation    ${operation}    ${expected}
    ELSE IF    "${type}" == "CLEAR_STATE"
        VAR    ${EXPECTED_TEXT}    clear_button=${expected}    scope=TEST
        Run Test Step    Look at the Clear button on the freshly opened page    Clear button is ${expected}
        ...    Verify Clear Button State    ${expected}
    ELSE
        Fail    Unknown test case type '${type}'
    END

Finish Calculator Test
    [Documentation]    Test Teardown: store the result (and a defect when the test failed), then close the context.
    ${expected}=    Get Variable Value    ${EXPECTED_TEXT}    ${EMPTY}
    ${actual}=    Get Variable Value    ${STEP_ACTUAL}    ${EMPTY}
    End Test Record    ${expected}    ${actual}
    Close Current Context

Describe Expected Result
    [Arguments]    ${answer}    ${error}
    IF    $error
        RETURN    Error message "${error}" is displayed and the Answer field is empty
    END
    RETURN    Answer field shows "${answer}" and no error message is displayed
