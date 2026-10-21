*** Settings ***
Documentation       Process keywords of the FakeRESTApi Books/Authors resources: one keyword = one step
...                 (send a request and check the response) built from the common API keywords.
Resource            ../Common_keyword/common.resource
Resource            ../Common_keyword/api_common.resource


*** Keywords ***
Send Request And Verify Status
    [Arguments]    ${method}    ${path}    ${body}    ${expected_status}
    Send Api Request    ${method}    ${path}    ${body}
    Verify Response Status    ${expected_status}

Verify Books List Is Valid
    Verify Response Is Non Empty List
    Verify Response Json Schema    book.json

Verify Book Is Valid And Has Id
    [Arguments]    ${book_id}
    Verify Response Field Equals    id    ${book_id}
    Verify Response Json Schema    book.json

Verify Authors Belong To Book
    [Arguments]    ${book_id}
    Verify Response Is Non Empty List
    Verify Every Item Field Equals    idBook    ${book_id}
    Verify Response Json Schema    author.json

Verify Response Is Not A Book
    [Documentation]    An error response must not look like a successful book resource.
    Show Response As Evidence
    ${is_json}=    Run Keyword And Return Status    Evaluate    $RESPONSE.json()
    IF    not ${is_json}
        VAR    ${STEP_ACTUAL}    non-JSON body: '${RESPONSE.text}'    scope=TEST
        RETURN
    END
    ${data}=    Evaluate    $RESPONSE.json()
    ${errors}=    Schema Errors    ${data}    book.json
    VAR    ${STEP_ACTUAL}    body: ${RESPONSE.text}    scope=TEST
    Should Not Be Empty    ${errors}    The error response contains a complete book resource

Verify Echoed Book
    [Arguments]    ${payload}
    Verify Response Echoes Request    ${payload}
    Verify Response Json Schema    book.json

Create Book And Read It Back
    [Arguments]    ${create_path}    ${body}    ${read_path}    ${expected_status}
    Send Request And Verify Status    POST    ${create_path}    ${body}    ${expected_status}
    Send Request And Verify Status    GET    ${read_path}    ${NONE}    ${expected_status}
