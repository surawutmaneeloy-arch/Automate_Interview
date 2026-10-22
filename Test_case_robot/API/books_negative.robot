*** Settings ***
Documentation       FakeRESTApi - negative tests, data-driven: one row of the table = one test.
...                 Columns: method, path, request body, expected status (REST convention), severity.
Resource            api_test_case.resource
Variables           api_test_data.py

Suite Setup         Start Api Suite
Suite Teardown      Finish Api Suite
Test Template       Request Is Rejected
Test Teardown       Finish Api Test
Test Tags           api    negative    data-driven


*** Test Cases ***    METHOD    PATH    BODY    EXPECTED STATUS    SEVERITY
API-N01 GET book id that does not exist
    GET    ${BOOKS_PATH}/99999    ${EMPTY}    404    High

API-N02 GET book id of the wrong type
    GET    ${BOOKS_PATH}/abc    ${EMPTY}    400    High

API-N03 POST with an empty body
    POST    ${BOOKS_PATH}    ${EMPTY}    400    High

API-N04 POST with malformed JSON
    POST    ${BOOKS_PATH}    ${MALFORMED_JSON}    400    High

API-N05 POST with pageCount as text
    POST    ${BOOKS_PATH}    ${WRONG_TYPE_BOOK}    400    High

API-N06 PATCH on a book is not supported
    PATCH    ${BOOKS_PATH}/1    {}    405    Medium

API-N07 DELETE on the whole collection is not supported
    DELETE    ${BOOKS_PATH}    ${EMPTY}    405    Medium

API-N08 PUT a book that does not exist
    PUT    ${BOOKS_PATH}/99999    ${UPDATED_BOOK}    404    Medium

API-N09 DELETE a book that does not exist
    DELETE    ${BOOKS_PATH}/99999    ${EMPTY}    404    Medium