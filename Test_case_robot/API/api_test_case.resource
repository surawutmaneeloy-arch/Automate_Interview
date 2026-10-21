*** Settings ***
Documentation       Test case keywords of the FakeRESTApi tests: each keyword is one test (or one row of the
...                 data-driven negative table) written as steps built from the API process keywords.
...                 All test data (paths, bodies, expected status) arrives as arguments from the test script
...                 (Test_script/fakerest_api).
Resource            ../../Common_keyword/common.resource
Resource            ../../Common_keyword/report.resource
Resource            ../../Process_keyword/api_process.resource


*** Variables ***
${REPORT_SUITE}     FakeRest_API


*** Keywords ***
Start Api Suite
    Set Suite Variable    ${CAPTURE_KEYWORD}    Capture Api Evidence    children=${TRUE}
    Start Api Session

Finish Api Suite
    Export Pdf Reports    ${REPORT_SUITE}    FakeRESTApi - Books (API)

Prepare Api Test
    [Arguments]    ${method}    ${path}    ${body}    ${expected_status}    ${severity}
    ${tc_id}=    Evaluate    $TEST_NAME.split()[0]
    ${shown_body}=    Set Variable If    $body and $body != 'None'    ${body}    (none)
    ${data}=    Create Dictionary    Method=${method}    Endpoint=${path}    Request body=${shown_body}
    ...    Expected status=${expected_status}
    Begin Test Record    ${REPORT_SUITE}    ${EMPTY}    ${tc_id}    ${data}
    ...    API base URL ${API_BASE_URL} (variable API_BASE_URL) is reachable, no authentication is needed
    ...    ${severity}
    VAR    ${EXPECTED_TEXT}    status ${expected_status}    scope=TEST

Finish Api Test
    ${expected}=    Get Variable Value    ${EXPECTED_TEXT}    ${EMPTY}
    ${actual}=    Get Variable Value    ${STEP_ACTUAL}    ${EMPTY}
    End Test Record    ${expected}    ${actual}

# ---------------------------------------------------------------- positive
Get All Books Returns A Valid Array
    [Arguments]    ${path}    ${expected_status}    ${severity}
    Prepare Api Test    GET    ${path}    ${NONE}    ${expected_status}    ${severity}
    Run Test Step    Send GET ${path}    Status code is ${expected_status}
    ...    Send Request And Verify Status    GET    ${path}    ${NONE}    ${expected_status}
    Run Test Step    Check the response body and schema
    ...    A non-empty array; every book has id, title, description, pageCount, excerpt, publishDate with the right types
    ...    Verify Books List Is Valid

Get Book By Id Returns That Book
    [Arguments]    ${path}    ${book_id}    ${expected_status}    ${severity}
    Prepare Api Test    GET    ${path}    ${NONE}    ${expected_status}    ${severity}
    Run Test Step    Send GET ${path}    Status code is ${expected_status}
    ...    Send Request And Verify Status    GET    ${path}    ${NONE}    ${expected_status}
    Run Test Step    Check the response body and schema    id = ${book_id} and the body matches the Book schema
    ...    Verify Book Is Valid And Has Id    ${book_id}

Send Book Echoes The Request
    [Documentation]    POST (create) or PUT (update): the response must repeat the data that was sent.
    [Arguments]    ${method}    ${path}    ${body}    ${expected_status}    ${severity}
    Prepare Api Test    ${method}    ${path}    ${body}    ${expected_status}    ${severity}
    Run Test Step    Send ${method} ${path} with a book    Status code is ${expected_status}
    ...    Send Request And Verify Status    ${method}    ${path}    ${body}    ${expected_status}
    Run Test Step    Compare the response with the request body
    ...    Every field of the response equals the field that was sent, and the body matches the Book schema
    ...    Verify Echoed Book    ${body}

Delete Book Returns Status
    [Arguments]    ${path}    ${expected_status}    ${severity}
    Prepare Api Test    DELETE    ${path}    ${NONE}    ${expected_status}    ${severity}
    Run Test Step    Send DELETE ${path}    Status code is ${expected_status}
    ...    Send Request And Verify Status    DELETE    ${path}    ${NONE}    ${expected_status}

Get Authors Of A Book
    [Arguments]    ${path}    ${book_id}    ${expected_status}    ${severity}
    Prepare Api Test    GET    ${path}    ${NONE}    ${expected_status}    ${severity}
    Run Test Step    Send GET ${path}    Status code is ${expected_status}
    ...    Send Request And Verify Status    GET    ${path}    ${NONE}    ${expected_status}
    Run Test Step    Check the response body and schema
    ...    A non-empty array; every author has idBook = ${book_id} and matches the Author schema
    ...    Verify Authors Belong To Book    ${book_id}

Created Book Can Be Read Back
    [Documentation]    Observation test: a REST API should persist what it just created.
    [Arguments]    ${create_path}    ${body}    ${read_path}    ${expected_status}    ${severity}
    Prepare Api Test    POST    ${create_path}    ${body}    ${expected_status}    ${severity}
    Run Test Step    Create a book with POST and read it with GET ${read_path}
    ...    POST returns ${expected_status} and GET of the new id returns ${expected_status} with the created book
    ...    Create Book And Read It Back    ${create_path}    ${body}    ${read_path}    ${expected_status}

# ---------------------------------------------------------------- negative (data-driven template)
Request Is Rejected
    [Arguments]    ${method}    ${path}    ${body}    ${expected_status}    ${severity}
    Prepare Api Test    ${method}    ${path}    ${body}    ${expected_status}    ${severity}
    Run Test Step    Send ${method} ${path}    Status code is ${expected_status}
    ...    Send Request And Verify Status    ${method}    ${path}    ${body}    ${expected_status}
    Run Test Step    Check the response body    The body is an error description, not a book resource
    ...    Verify Response Is Not A Book
