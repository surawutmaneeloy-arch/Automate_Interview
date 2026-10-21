*** Settings ***
Documentation       Common keywords of the Basic Calculator page: one keyword = one atomic action or read on the page.
...                 They only wrap Common_keyword/common.resource with the calculator locators; no test logic here.
Resource            common.resource
Resource            ../Locator/calculator_locators.resource


*** Variables ***
${BASE_URL}     https://testsheepnz.github.io/BasicCalculator.html


*** Keywords ***
Open Calculator Page
    Open Page With Retry    ${BASE_URL}

Select Build
    [Arguments]    ${build}
    Choose Option By Value    ${LOC_BUILD_SELECT}    ${build}

Select Operation
    [Arguments]    ${operation}
    Choose Option By Label    ${LOC_OPERATION}    ${operation}

Enter First Number
    [Arguments]    ${value}
    Type Into Field    ${LOC_FIRST_NUMBER}    ${value}

Enter Second Number
    [Arguments]    ${value}
    Type Into Field    ${LOC_SECOND_NUMBER}    ${value}

Tick Integers Only
    Tick Checkbox    ${LOC_INTEGERS_ONLY}

Click Calculate Button
    Click Element    ${LOC_CALCULATE_BUTTON}

Click Clear Button
    Click Element    ${LOC_CLEAR_BUTTON}

Read Selected Operation
    ${label}=    Read Selected Label    ${LOC_OPERATION}
    RETURN    ${label}

Read First Number
    ${value}=    Read Field Value    ${LOC_FIRST_NUMBER}
    RETURN    ${value}

Read Second Number
    ${value}=    Read Field Value    ${LOC_SECOND_NUMBER}
    RETURN    ${value}

Read Answer
    ${value}=    Read Field Value    ${LOC_ANSWER}
    RETURN    ${value}

Read Error Message
    ${text}=    Read Element Text    ${LOC_ERROR_MESSAGE}
    RETURN    ${text}

Read Integers Only Checked
    ${checked}=    Get Checkbox State    ${LOC_INTEGERS_ONLY}
    RETURN    ${checked}

Read Integers Only State
    ${state}=    Read Element Enabled State    ${LOC_INTEGERS_ONLY}
    RETURN    ${state}

Read Clear Button State
    ${state}=    Read Element Enabled State    ${LOC_CLEAR_BUTTON}
    RETURN    ${state}

Wait For Calculation To Finish
    [Documentation]    The page shows "Calculating ..." for up to one second; the divide-by-zero path never leaves it.
    Run Keyword And Ignore Error    Wait For Elements State    ${LOC_CALCULATING_FORM}    hidden    timeout=1500ms
