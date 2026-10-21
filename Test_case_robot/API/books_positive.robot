*** Settings ***
Documentation       FakeRESTApi - positive tests (status code, response body and JSON schema).
...                 Test data comes from api_test_data.py and is passed to the keywords as arguments.
Resource            api_test_case.resource
Variables           api_test_data.py

Test Teardown       Finish Api Test
Test Tags           api    positive


*** Test Cases ***
API-P01 GET Books returns an array with all fields
    Get All Books Returns A Valid Array    ${BOOKS_PATH}    200    Critical

API-P02 GET Books by id 1 returns that book
    Get Book By Id Returns That Book    ${BOOKS_PATH}/1    1    200    Critical

API-P03 POST Books returns the data that was sent
    Send Book Echoes The Request    POST    ${BOOKS_PATH}    ${NEW_BOOK}    200    Critical

API-P04 PUT Books 1 returns the updated data
    Send Book Echoes The Request    PUT    ${BOOKS_PATH}/1    ${UPDATED_BOOK}    200    Critical

API-P05 DELETE Books 1 returns 200
    Delete Book Returns Status    ${BOOKS_PATH}/1    200    High

API-P06 GET authors of book 1
    Get Authors Of A Book    ${AUTHORS_BY_BOOK_PATH}/1    1    200    High

API-P07 Created book can be read back
    [Tags]    observation
    Created Book Can Be Read Back    ${BOOKS_PATH}    ${NEW_BOOK}    ${BOOKS_PATH}/201    200    Low