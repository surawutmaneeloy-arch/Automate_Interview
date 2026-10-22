*** Settings ***
Documentation       Page object (process keywords) of https://login.yahoo.com/account/create: every keyword is one
...                 test step built from the Yahoo common keywords. The page is only used to validate the form -
...                 the registration is never completed.
Resource            ../Common_keyword/yahoo_common.resource


*** Variables ***
${REQUIRED_MESSAGE}     Please fill out this field.


*** Keywords ***
Open Create Account Page
    Open Yahoo Create Account Page

Fill Registration Form
    [Arguments]    ${first}    ${last}    ${username}    ${password}    ${month}    ${day}    ${year}
    Fill Value If Given    ${YH_FIRST_NAME}    ${first}
    Fill Value If Given    ${YH_LAST_NAME}    ${last}
    Fill Value If Given    ${YH_USERNAME}    ${username}
    Fill Value If Given    ${YH_PASSWORD}    ${password}
    Type Value If Given    ${YH_DOB_MONTH}    ${month}
    Type Value If Given    ${YH_DOB_DAY}    ${day}
    Type Value If Given    ${YH_DOB_YEAR}    ${year}

Verify Filled Values
    [Arguments]    ${first}    ${last}    ${username}    ${password}    ${month}    ${day}    ${year}
    ${shown}=    Create List
    FOR    ${locator}    IN    ${YH_FIRST_NAME}    ${YH_LAST_NAME}    ${YH_USERNAME}    ${YH_PASSWORD}
    ...    ${YH_DOB_MONTH}    ${YH_DOB_DAY}    ${YH_DOB_YEAR}
        ${value}=    Read Field Value    ${locator}
        Append To List    ${shown}    ${value}
    END
    ${expected}=    Create List    ${first}    ${last}    ${username}    ${password}    ${month}    ${day}    ${year}
    Verify Text Equals    ${shown}    ${expected}

Verify Field Error Message
    [Documentation]    Checks the message shown at the given field; ``*`` accepts any non-empty message.
    [Arguments]    ${field}    ${expected}
    ${locator}=    Get From Dictionary    ${YH_ERROR_BY_FIELD}    ${field}
    ${status}    ${message}=    Run Keyword And Ignore Error    Wait For Error Text    ${locator}    ${expected}
    ${actual}=    Read Field Error Text    ${locator}
    IF    not $actual
        ${others}=    List Visible Error Messages
        VAR    ${actual}    No error message at ${field} (messages on the page: ${{ $others or 'none' }})
    END
    VAR    ${STEP_ACTUAL}    ${actual}    scope=TEST
    IF    "${status}" == "FAIL"    Fail    Expected error [${expected}] at ${field} but was [${actual}]

Verify Required Fields Are Flagged
    [Documentation]    Empty submit is stopped by the browser: every required input reports "Please fill out this field."
    ${messages}=    Create List
    FOR    ${locator}    IN    ${YH_FIRST_NAME}    ${YH_LAST_NAME}    ${YH_USERNAME}    ${YH_PASSWORD}
    ...    ${YH_DOB_MONTH}    ${YH_DOB_DAY}    ${YH_DOB_YEAR}
        ${message}=    Read Required Message Of    ${locator}
        Append To List    ${messages}    ${message}
    END
    ${expected}=    Evaluate    [$REQUIRED_MESSAGE] * 7
    Verify Text Equals    ${messages}    ${expected}

Verify No Field Error Is Shown
    ${count}=    Count Visible Error Messages
    ${valid}=    Read Form Validity
    ${listed}=    List Visible Error Messages
    VAR    ${STEP_ACTUAL}    error messages shown: ${count} (${listed}), form valid: ${valid}    scope=TEST
    Should Be Equal As Integers    ${count}    0    ${count} error message(s) are displayed
    Should Be True    ${valid}    The form is not valid

Verify Password Is Strong And Accepted
    Wait For Password Strength    Strong
    ${strength}=    Read Password Strength
    ${error}=    Read Field Error Text    ${YH_ERR_PASSWORD}
    VAR    ${STEP_ACTUAL}    strength: '${strength}', password error: '${error}'    scope=TEST
    Should Be Empty    ${error}    Password error is displayed: ${error}

Click Next And Verify Required Fields
    Click Next Button
    Verify Required Fields Are Flagged

Click Next And Verify Error
    [Arguments]    ${field}    ${expected}
    Click Next Button
    Verify Field Error Message    ${field}    ${expected}

Open Legal Link And Verify Page
    [Arguments]    ${locator}    ${expected_url_part}
    Click Legal Link    ${locator}
    ${url}=    Get Url
    VAR    ${STEP_ACTUAL}    ${url}    scope=TEST
    Get Url    *=    ${expected_url_part}

Capture Yahoo Evidence
    [Documentation]    Picture of the registration card; falls back to the whole viewport on other pages (Terms/Privacy).
    [Arguments]    ${step_no}
    ${base}=    Evidence Path    ${step_no}
    ${region_status}    ${region}=    Run Keyword And Ignore Error    Evaluate JavaScript    ${NONE}    ${YH_CARD_REGION_JS}
    ${crop}=    Set Variable If    "${region_status}" == "PASS"    ${region}    ${NONE}
    ${status}    ${path}=    Run Keyword And Ignore Error
    ...    Take Screenshot    ${base}    crop=${crop}    fileType=jpeg    quality=80
    IF    "${status}" == "FAIL"    RETURN    ${EMPTY}
    RETURN    ${path}
