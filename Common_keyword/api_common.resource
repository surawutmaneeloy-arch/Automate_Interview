*** Settings ***
Documentation       Common API keywords (RequestsLibrary + jsonschema). The base URL is configuration:
...                 robot.toml [variables] API_BASE_URL or `--variable API_BASE_URL:<url>`.
Library             RequestsLibrary
Library             Browser    auto_closing_level=MANUAL
Library             Collections
Library             OperatingSystem
Library             TestRecorder.py
Library             SchemaValidator.py


*** Variables ***
${API_BASE_URL}         https://fakerestapi.azurewebsites.net
${API_TIMEOUT}          30
${EVIDENCE_LIMIT}       600


*** Keywords ***
Start Api Session
    Create Session    api    ${API_BASE_URL}    timeout=${API_TIMEOUT}    verify=${TRUE}

Send Api Request
    [Arguments]    ${method}    ${path}    ${body}=${NONE}    ${content_type}=application/json
    ${headers}=    Create Dictionary    Content-Type=${content_type}    Accept=application/json
    ${response}=    Run Keyword    ${method} On Session    api    ${path}    data=${body}    headers=${headers}
    ...    expected_status=any
    VAR    ${RESPONSE}    ${response}    scope=TEST
    ${request_text}=    Set Variable    ${method} ${API_BASE_URL}${path}
    IF    $body    VAR    ${request_text}    ${request_text}\nRequest body: ${body}
    VAR    ${REQUEST_TEXT}    ${request_text}    scope=TEST
    Show Response As Evidence

Show Response As Evidence
    ${text}=    Set Variable    ${RESPONSE.text}
    ${text}=    Evaluate    $text[:int($EVIDENCE_LIMIT)] + (' ...' if len($text) > int($EVIDENCE_LIMIT) else '')
    VAR    ${STEP_EVIDENCE}    ${REQUEST_TEXT}\nStatus: ${RESPONSE.status_code}\nResponse body: ${text}    scope=TEST

Verify Response Status
    [Arguments]    ${expected_status}
    VAR    ${STEP_ACTUAL}    status code ${RESPONSE.status_code}    scope=TEST
    Should Be Equal As Integers    ${RESPONSE.status_code}    ${expected_status}
    ...    Expected status ${expected_status} but was ${RESPONSE.status_code}

Verify Response Json Schema
    [Arguments]    ${schema_file}
    Show Response As Evidence
    ${data}=    Evaluate    $RESPONSE.json()
    ${errors}=    Schema Errors    ${data}    ${schema_file}
    VAR    ${STEP_ACTUAL}    schema errors: ${errors}    scope=TEST
    Should Be Empty    ${errors}    Response does not match ${schema_file}: ${errors}

Verify Response Is Non Empty List
    Show Response As Evidence
    ${data}=    Evaluate    $RESPONSE.json()
    VAR    ${STEP_ACTUAL}    ${{ type($data).__name__ }} with ${{ len($data) if isinstance($data, list) else 0 }} item(s)    scope=TEST
    Should Be True    isinstance($data, list) and len($data) > 0    Response is not a non-empty array

Verify Response Field Equals
    [Arguments]    ${field}    ${expected}
    Show Response As Evidence
    ${data}=    Evaluate    $RESPONSE.json()
    ${actual}=    Evaluate    $data.get($field) if isinstance($data, dict) else None
    VAR    ${STEP_ACTUAL}    ${field} = ${actual}    scope=TEST
    Should Be Equal As Strings    ${actual}    ${expected}    Expected ${field}=${expected} but was ${actual}

Verify Every Item Field Equals
    [Arguments]    ${field}    ${expected}
    Show Response As Evidence
    ${data}=    Evaluate    $RESPONSE.json()
    ${values}=    Evaluate    [str(item.get($field)) for item in $data]
    VAR    ${STEP_ACTUAL}    ${field} of items: ${values}    scope=TEST
    ${wrong}=    Evaluate    [v for v in $values if v != str($expected)]
    Should Be Empty    ${wrong}    Items with ${field} different from ${expected}: ${wrong}

Verify Response Echoes Request
    [Arguments]    ${payload_json}
    Show Response As Evidence
    ${sent}=    Evaluate    json.loads($payload_json)    modules=json
    ${got}=    Evaluate    $RESPONSE.json()
    ${diff}=    Evaluate    {k: $got.get(k) for k, v in $sent.items() if $got.get(k) != v}
    VAR    ${STEP_ACTUAL}    fields different from the request: ${diff}    scope=TEST
    Should Be Empty    ${diff}    Response differs from request: ${diff}

Capture Api Evidence
    [Documentation]    Picture of the request/response: the text is rendered in a headless browser page and captured.
    [Arguments]    ${step_no}
    ${base}=    Evidence Path    ${step_no}
    ${text}=    Get Variable Value    ${STEP_EVIDENCE}    ${EMPTY}
    IF    not $text    VAR    ${text}    No request/response was recorded for this step
    ${url}=    Evidence Data Url    ${text}
    New Page    ${url}
    ${status}    ${path}=    Run Keyword And Ignore Error
    ...    Take Screenshot    ${base}    selector=css=#evidence    fileType=jpeg    quality=85
    Close Page    CURRENT
    IF    "${status}" == "FAIL"    RETURN    ${EMPTY}
    RETURN    ${path}
