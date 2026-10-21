*** Settings ***
Documentation       Common keywords of the Yahoo create account page: one keyword = one atomic action or read on the page.
...                 They only wrap Common_keyword/common.resource with the Yahoo locators; no test logic here.
Resource            common.resource
Resource            ../Locator/yahoo_locators.resource


*** Variables ***
${YAHOO_URL}            https://login.yahoo.com/account/create


*** Keywords ***
Open Yahoo Create Account Page
    Open Page With Retry    ${YAHOO_URL}
    Wait For Elements State    ${YH_FIRST_NAME}    visible
    Wait For Function    ${YH_HYDRATED_JS}

Type Value If Given
    [Arguments]    ${locator}    ${value}
    IF    $value    Type Keys Into Field    ${locator}    ${value}

Click Next Button
    Click Element    ${YH_NEXT_BUTTON}

Press Tab In Last Field
    Press Keys    ${YH_DOB_YEAR}    Tab

Click Legal Link
    [Arguments]    ${locator}
    Click Element    ${locator}
    Switch Page    NEW

Read Required Message Of
    [Arguments]    ${locator}
    ${message}=    Evaluate JavaScript    ${locator}    (element) => element.validationMessage
    RETURN    ${message}

Read Field Error Text
    [Arguments]    ${locator}
    ${count}=    Get Element Count    ${locator}
    IF    ${count} == 0    RETURN    ${EMPTY}
    ${text}=    Read Element Text    ${locator}
    RETURN    ${text}

Wait For Error Text
    [Documentation]    Waits for the message; ``*`` accepts any non-empty message. Spaces are normalised.
    [Arguments]    ${locator}    ${expected}
    ${previous}=    Set Browser Timeout    15s
    TRY
        IF    "${expected}" == "*"
            Get Text    ${locator}    validate    len(value.strip()) > 0
        ELSE
            Get Text    ${locator}    validate    "${expected}" in " ".join(value.split())
        END
    FINALLY
        Set Browser Timeout    ${previous}
    END

Count Visible Error Messages
    ${count}=    Evaluate JavaScript    ${NONE}    ${YH_COUNT_ERRORS_JS}
    RETURN    ${count}

List Visible Error Messages
    ${listed}=    Evaluate JavaScript    ${NONE}    ${YH_LIST_ERRORS_JS}
    RETURN    ${listed}

Read Form Validity
    ${valid}=    Evaluate JavaScript    ${NONE}    () => document.getElementById('challenge-form').checkValidity()
    RETURN    ${valid}

Read Password Strength
    ${strength}=    Read Element Text    ${YH_PASSWORD_STRENGTH}
    RETURN    ${strength}

Wait For Password Strength
    [Arguments]    ${expected}
    Get Text    ${YH_PASSWORD_STRENGTH}    *=    ${expected}
