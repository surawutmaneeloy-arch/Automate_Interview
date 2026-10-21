*** Settings ***
Documentation       Process keywords of the Basic Calculator. One process keyword = one test step, built by
...                 combining the calculator common keywords (Common_keyword/calculator_common.resource).
Resource            ../Common_keyword/calculator_common.resource


*** Variables ***
${CALCULATOR_REGION_JS}    () => { const s = document.getElementById('selectBuild'); window.scrollTo(0, s.getBoundingClientRect().top + window.scrollY - 75); const a = s.getBoundingClientRect(); const r = document.getElementById('resetForm').getBoundingClientRect(); const c = document.querySelector('#main-body .container').getBoundingClientRect(); const y = Math.max(0, a.top - 8); return {x: Math.max(0, c.left), y: y, width: Math.min(c.width, 640, window.innerWidth), height: Math.min(window.innerHeight - y, r.bottom - y + 8)}; }


*** Keywords ***
Open Calculator With Build
    [Arguments]    ${build}
    Open Calculator Page
    Select Build    ${build}

Enter Calculation Data
    [Arguments]    ${operation}    ${first}    ${second}    ${integers}
    Select Operation    ${operation}
    Enter First Number    ${first}
    Enter Second Number    ${second}
    IF    "${integers}" == "Yes"    Tick Integers Only
    ${shown_operation}=    Read Selected Operation
    ${shown_first}=    Read First Number
    ${shown_second}=    Read Second Number
    Verify Text Equals
    ...    operation='${shown_operation}' | first='${shown_first}' | second='${shown_second}'
    ...    operation='${operation}' | first='${first}' | second='${second}'

Click Calculate And Verify Result
    [Arguments]    ${expected_answer}    ${expected_error}
    Click Calculate Button
    ${actual}=    Read Answer And Error
    Wait For Calculation To Finish
    Verify Text Equals    ${actual}    answer='${expected_answer}' | error='${expected_error}'

Click Calculate And Verify Output Shown
    Click Calculate Button
    ${actual}=    Read Answer And Error
    Wait For Calculation To Finish
    VAR    ${STEP_ACTUAL}    ${actual}    scope=TEST
    Should Not Be Equal    ${actual}    answer='' | error=''    Neither an answer nor an error message is shown

Click Clear And Verify Reset
    Click Clear Button
    ${actual}=    Read Answer And Error    include_checkbox=${TRUE}
    Verify Text Equals    ${actual}    answer='' | error='' | integers_checked=False

Tick Integers Only And Verify Answer
    [Arguments]    ${expected_answer}    ${expected_error}
    Tick Integers Only
    ${actual}=    Read Answer And Error
    Verify Text Equals    ${actual}    answer='${expected_answer}' | error='${expected_error}'

Verify Integers Only State After Selecting Operation
    [Arguments]    ${operation}    ${expected_state}
    Select Operation    ${operation}
    ${state}=    Read Integers Only State
    Verify Text Equals    integers_checkbox=${state}    integers_checkbox=${expected_state}

Verify Clear Button State
    [Arguments]    ${expected_state}
    ${state}=    Read Clear Button State
    Verify Text Equals    clear_button=${state}    clear_button=${expected_state}

Read Answer And Error
    [Arguments]    ${include_checkbox}=${FALSE}
    ${answer}=    Read Answer
    ${error}=    Read Error Message
    ${actual}=    Set Variable    answer='${answer}' | error='${error}'
    IF    ${include_checkbox}
        ${checked}=    Read Integers Only Checked
        ${actual}=    Set Variable    ${actual} | integers_checked=${checked}
    END
    RETURN    ${actual}

Capture Calculator Evidence
    [Documentation]    Picture of the calculator area (Build selector down to the Clear button).
    [Arguments]    ${step_no}
    ${base}=    Evidence Path    ${step_no}
    ${region_status}    ${region}=    Run Keyword And Ignore Error    Evaluate JavaScript    ${NONE}    ${CALCULATOR_REGION_JS}
    ${crop}=    Set Variable If    "${region_status}" == "PASS"    ${region}    ${NONE}
    ${status}    ${path}=    Run Keyword And Ignore Error
    ...    Take Screenshot    ${base}    crop=${crop}    fileType=jpeg    quality=80
    IF    "${status}" == "FAIL"    RETURN    ${EMPTY}
    RETURN    ${path}