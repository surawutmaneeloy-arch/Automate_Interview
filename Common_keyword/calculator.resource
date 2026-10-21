*** Settings ***
Library     Browser    auto_closing_level=MANUAL
Library     Collections
Library     DefectLogger.py
Resource    ../Element_Locator/calculator_locators.resource


*** Variables ***
${BASE_URL}       https://testsheepnz.github.io/BasicCalculator.html
${BUILD}          0
${HEADLESS}       True
${TIMEOUT}        5s
${NAV_TIMEOUT}    30s
${EMPTY_TOKEN}    (empty)


*** Keywords ***
Start Calculator Suite
    Reset Run Log
    Set Browser Timeout    ${TIMEOUT}
    New Browser    chromium    headless=${HEADLESS}

Finish Calculator Suite
    Export Build Reports
    Close Browser    ALL

Open Calculator
    New Context
    Set Browser Timeout    ${NAV_TIMEOUT}
    Wait Until Keyword Succeeds    3x    2s    New Page    ${BASE_URL}    wait_until=domcontentloaded
    Set Browser Timeout    ${TIMEOUT}
    Select Options By    ${LOC_BUILD_SELECT}    value    ${BUILD}

Log Result And Defect
    [Documentation]    Test Teardown: store the result and auto-log a defect when the test failed.
    ${case}=    Get Variable Value    ${CASE}    ${EMPTY}
    ${expected}=    Get Variable Value    ${EXPECTED_TEXT}    N/A
    ${actual}=    Get Variable Value    ${ACTUAL}    N/A (no result captured - see message)
    ${screenshot}=    Set Variable    ${EMPTY}
    IF    "${TEST STATUS}" == "FAIL"
        ${tc_id}=    Evaluate    $case.get('tc_id', 'TC') if $case else 'TC'
        ${shot_status}    ${shot}=    Run Keyword And Ignore Error    Take Screenshot    ${tc_id}_B${BUILD}
        IF    "${shot_status}" == "PASS"    VAR    ${screenshot}    ${shot}
    END
    Record Test Result    ${case}    ${expected}    ${actual}    ${TEST STATUS}    ${TEST MESSAGE}    ${screenshot}
    Run Keyword And Ignore Error    Close Context    CURRENT

Run Calculator Case
    [Arguments]    ${tc_id}    ${type}    ${category}    ${operation}    ${first}    ${second}
    ...    ${integers}    ${expected}    ${expected_error}    ${severity}
    ${first}=    Cell Value    ${first}
    ${second}=    Cell Value    ${second}
    ${expected}=    Cell Value    ${expected}
    ${expected_error}=    Cell Value    ${expected_error}
    ${case}=    Create Dictionary    tc_id=${tc_id}    type=${type}    category=${category}
    ...    operation=${operation}    first=${first}    second=${second}    integers=${integers}
    ...    severity=${severity}
    Set Test Variable    ${CASE}    ${case}
    IF    "${type}" == "INT_STATE"
        Set Test Variable    ${EXPECTED_TEXT}    integers_checkbox=${expected}
    ELSE IF    "${type}" == "CLEAR_STATE"
        Set Test Variable    ${EXPECTED_TEXT}    clear_button=${expected}
    ELSE IF    "${type}" == "CLEAR"
        Set Test Variable    ${EXPECTED_TEXT}    answer='' | error='' | integers_checked=False
    ELSE
        Set Test Variable    ${EXPECTED_TEXT}    answer='${expected}' | error='${expected_error}'
    END
    IF    "${type}" == "CALC"
        Enter Calculation And Calculate    ${operation}    ${first}    ${second}    ${integers}
        Read Answer And Error
    ELSE IF    "${type}" == "CLEAR"
        Enter Calculation And Calculate    ${operation}    ${first}    ${second}    ${integers}
        Click    ${LOC_CLEAR_BUTTON}
        Read Answer And Error    include_checkbox=${TRUE}
    ELSE IF    "${type}" == "INT_TOGGLE"
        Enter Calculation And Calculate    ${operation}    ${first}    ${second}    ${integers}
        Check Checkbox    ${LOC_INTEGERS_ONLY}
        Read Answer And Error
    ELSE IF    "${type}" == "INT_STATE"
        Select Options By    ${LOC_OPERATION}    label    ${operation}
        ${disabled}=    Get Property    ${LOC_INTEGERS_ONLY}    disabled
        ${state}=    Set Variable If    ${disabled}    disabled    enabled
        Set Test Variable    ${ACTUAL}    integers_checkbox=${state}
    ELSE IF    "${type}" == "CLEAR_STATE"
        ${disabled}=    Get Property    ${LOC_CLEAR_BUTTON}    disabled
        ${state}=    Set Variable If    ${disabled}    disabled    enabled
        Set Test Variable    ${ACTUAL}    clear_button=${state}
    ELSE
        Fail    Unknown test case type '${type}'
    END
    Should Be Equal    ${ACTUAL}    ${EXPECTED_TEXT}    Expected [${EXPECTED_TEXT}] but was [${ACTUAL}]

Cell Value
    [Arguments]    ${cell}
    IF    "${cell}" == "${EMPTY_TOKEN}"    RETURN    ${EMPTY}
    RETURN    ${cell}

Enter Calculation And Calculate
    [Arguments]    ${operation}    ${first}    ${second}    ${integers}
    Select Options By    ${LOC_OPERATION}    label    ${operation}
    Fill Text    ${LOC_FIRST_NUMBER}    ${first}
    Fill Text    ${LOC_SECOND_NUMBER}    ${second}
    IF    "${integers}" == "Yes"    Check Checkbox    ${LOC_INTEGERS_ONLY}
    Click    ${LOC_CALCULATE_BUTTON}

Read Answer And Error
    [Arguments]    ${include_checkbox}=${FALSE}
    ${answer}=    Get Property    ${LOC_ANSWER}    value
    ${error}=    Get Text    ${LOC_ERROR_MESSAGE}
    ${actual}=    Set Variable    answer='${answer}' | error='${error}'
    IF    ${include_checkbox}
        ${checked}=    Get Checkbox State    ${LOC_INTEGERS_ONLY}
        ${actual}=    Set Variable    ${actual} | integers_checked=${checked}
    END
    Set Test Variable    ${ACTUAL}    ${actual}
