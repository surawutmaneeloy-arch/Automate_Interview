*** Settings ***
Documentation       Test case keywords for the Yahoo registration page: each keyword is one test (or one row of the
...                 data-driven negative table) written as steps built from the page object keywords.
...                 All test data arrives as arguments from the test script (Test_script/yahoo_create_account).
Resource            ../../Common_keyword/common.resource
Resource            ../../Common_keyword/report.resource
Resource            ../../Process_keyword/yahoo_create_account_page.resource


*** Variables ***
${REPORT_SUITE}         Yahoo_UI


*** Keywords ***
Start Yahoo Suite
    Set Suite Variable    ${CAPTURE_KEYWORD}    Capture Yahoo Evidence    children=${TRUE}
    Set Suite Variable    &{VIEWPORT}    width=1000    height=1100    children=${TRUE}
    Start Browser Session

Finish Yahoo Suite
    Stop Browser Session
    Export Pdf Reports    ${REPORT_SUITE}    Yahoo Create Account (UI)

Prepare Yahoo Test
    [Documentation]    Pre-condition shared by all tests: the registration page is open and ready for input.
    [Arguments]    ${data}    ${severity}
    ${tc_id}=    Evaluate    $TEST_NAME.split()[0]
    Begin Test Record    ${REPORT_SUITE}    ${EMPTY}    ${tc_id}    ${data}
    ...    Browser is open at ${YAHOO_URL} and the registration form is loaded and ready    ${severity}
    ${status}    ${message}=    Run Keyword And Ignore Error    Open Yahoo Page
    IF    "${status}" == "FAIL"    Fail    Setup failed: ${message}

Open Yahoo Page
    Open New Context
    Open Create Account Page

Finish Yahoo Test
    ${expected}=    Get Variable Value    ${EXPECTED_TEXT}    ${EMPTY}
    ${actual}=    Get Variable Value    ${STEP_ACTUAL}    ${EMPTY}
    End Test Record    ${expected}    ${actual}
    Close Current Context

Registration Data
    [Arguments]    ${first}    ${last}    ${username}    ${password}    ${month}    ${day}    ${year}
    ${data}=    Create Dictionary    First name=${first}    Last name=${last}    Username=${username}
    ...    Password=${password}    Date of birth (MM/DD/YYYY)=${month}/${day}/${year}
    RETURN    ${data}

Form Step Text
    [Arguments]    ${first}    ${last}    ${username}    ${password}    ${month}    ${day}    ${year}
    RETURN    Enter First name '${first}', Last name '${last}', Username '${username}', Password '${password}', date of birth ${month}/${day}/${year}

# ---------------------------------------------------------------- positive
Valid Data Shows No Error
    [Arguments]    ${first}    ${last}    ${username}    ${password}    ${month}    ${day}    ${year}    ${severity}
    ${data}=    Registration Data    ${first}    ${last}    ${username}    ${password}    ${month}    ${day}    ${year}
    Prepare Yahoo Test    ${data}    ${severity}
    VAR    ${EXPECTED_TEXT}    no error message and a valid form    scope=TEST
    ${step}=    Form Step Text    ${first}    ${last}    ${username}    ${password}    ${month}    ${day}    ${year}
    Run Test Step    ${step}    All entered values are displayed in the form
    ...    Fill And Verify Registration Form    ${first}    ${last}    ${username}    ${password}    ${month}
    ...    ${day}    ${year}
    Run Test Step    Move the focus out of the last field (the form is not submitted)
    ...    No error message is displayed and the form is valid
    ...    Verify No Field Error Is Shown

Strong Password Is Accepted
    [Arguments]    ${password}    ${severity}
    ${data}=    Registration Data    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${password}    ${EMPTY}    ${EMPTY}    ${EMPTY}
    Prepare Yahoo Test    ${data}    ${severity}
    VAR    ${EXPECTED_TEXT}    strength Strong, no password error    scope=TEST
    Run Test Step    Enter the strong password '${password}'
    ...    The password field shows the value
    ...    Type Keys Into Field    ${YH_PASSWORD}    ${password}
    Run Test Step    Observe the password strength indicator
    ...    Strength is "Strong" and no warning is shown at the password field
    ...    Verify Password Is Strong And Accepted

Legal Link Opens
    [Arguments]    ${link_name}    ${locator}    ${url_part}    ${severity}
    ${data}=    Create Dictionary    Link=${link_name}    Expected URL contains=${url_part}
    Prepare Yahoo Test    ${data}    ${severity}
    VAR    ${EXPECTED_TEXT}    ${link_name} page opens (${url_part})    scope=TEST
    Run Test Step    Click the '${link_name}' link
    ...    A new tab opens with the ${link_name} page (URL contains ${url_part})
    ...    Open Legal Link And Verify Page    ${locator}    ${url_part}

# ---------------------------------------------------------------- negative (data-driven template)
Empty Form Is Rejected
    [Arguments]    ${severity}
    ${data}=    Registration Data    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}    ${EMPTY}
    Prepare Yahoo Test    ${data}    ${severity}
    VAR    ${EXPECTED_TEXT}    every required field reports '${REQUIRED_MESSAGE}'    scope=TEST
    Run Test Step    Click Next without entering anything
    ...    Every required field reports "${REQUIRED_MESSAGE}"
    ...    Click Next And Verify Required Fields

Invalid Registration Data Shows Error
    [Arguments]    ${first}    ${last}    ${username}    ${password}    ${month}    ${day}    ${year}
    ...    ${error_field}    ${expected_error}    ${severity}
    ${data}=    Registration Data    ${first}    ${last}    ${username}    ${password}    ${month}    ${day}    ${year}
    Set To Dictionary    ${data}    Expected error field=${error_field}    Expected error=${expected_error}
    Prepare Yahoo Test    ${data}    ${severity}
    ${shown_error}=    Set Variable If    "${expected_error}" == "*"    any error message    "${expected_error}"
    VAR    ${EXPECTED_TEXT}    ${error_field} error: ${shown_error}    scope=TEST
    ${step}=    Form Step Text    ${first}    ${last}    ${username}    ${password}    ${month}    ${day}    ${year}
    Run Test Step    ${step}    All entered values are displayed in the form
    ...    Fill And Verify Registration Form    ${first}    ${last}    ${username}    ${password}    ${month}
    ...    ${day}    ${year}
    Run Test Step    Click Next
    ...    ${error_field} field shows ${shown_error}
    ...    Click Next And Verify Error    ${error_field}    ${expected_error}

Fill And Verify Registration Form
    [Arguments]    ${first}    ${last}    ${username}    ${password}    ${month}    ${day}    ${year}
    Fill Registration Form    ${first}    ${last}    ${username}    ${password}    ${month}    ${day}    ${year}
    Verify Filled Values    ${first}    ${last}    ${username}    ${password}    ${month}    ${day}    ${year}
