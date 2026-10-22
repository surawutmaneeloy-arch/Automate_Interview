*** Settings ***
Documentation       Yahoo create account - negative tests, data-driven: one row of the table = one test.
...                 Columns: first, last, username, password, month, day, year, error field, expected error
...                 (substring of the message shown at that field, ``*`` = any message), severity.
...                 Every row also contains something Yahoo must reject (taken username, ...) so that no row can
...                 ever pass the form and continue the registration.
Resource            yahoo_test_case.resource
Variables           yahoo_test_data.py

Suite Setup         Start Yahoo Suite
Suite Teardown      Finish Yahoo Suite
Test Template       Invalid Registration Data Shows Error
Test Teardown       Finish Yahoo Test
Test Tags           yahoo    ui    negative    data-driven


*** Test Cases ***    FIRST    LAST    USERNAME    PASSWORD    MM    DD    YYYY    FIELD    EXPECTED ERROR    SEVERITY
YH-N01 Next without any data flags the required fields
    [Template]    NONE
    Empty Form Is Rejected    High

YH-N02 Username already taken
    ${VALID_FIRST}    ${VALID_LAST}    ${TAKEN_USERNAME}    ${VALID_PASSWORD}    05    17    1990    USERNAME    already exists    Critical

YH-N03 Username with a space
    ${VALID_FIRST}    ${VALID_LAST}    john smith    ${VALID_PASSWORD}    05    17    1990    USERNAME    You can only use letters, numbers, periods    High

YH-N04 Username with special characters
    ${VALID_FIRST}    ${VALID_LAST}    john#smith    ${VALID_PASSWORD}    05    17    1990    USERNAME    You can only use letters, numbers, periods    High

YH-N05 Username too short
    ${VALID_FIRST}    ${VALID_LAST}    ab    ${VALID_PASSWORD}    05    17    1990    USERNAME    too short    High

YH-N06 Username too long
    ${VALID_FIRST}    ${VALID_LAST}    ${LONG_USERNAME}    ${VALID_PASSWORD}    05    17    1990    USERNAME    too long    High

YH-N07 Password too short
    ${VALID_FIRST}    ${VALID_LAST}    ${TAKEN_USERNAME}    abc    05    17    1990    PASSWORD    Must contain at least 8 characters    High

YH-N08 Password too weak
    ${VALID_FIRST}    ${VALID_LAST}    ${TAKEN_USERNAME}    password    05    17    1990    PASSWORD    *    High

YH-N09 Password same as the username
    ${VALID_FIRST}    ${VALID_LAST}    administrator    administrator    05    17    1990    PASSWORD    *    High

YH-N10 Password same as the first name
    Johnathan    ${VALID_LAST}    ${TAKEN_USERNAME}    Johnathan    05    17    1990    PASSWORD    *    Medium

YH-N11 Date of birth 31 February
    ${VALID_FIRST}    ${VALID_LAST}    ${TAKEN_USERNAME}    ${VALID_PASSWORD}    02    31    1990    DOB    Check the date entered    High

YH-N12 Date of birth in the future
    ${VALID_FIRST}    ${VALID_LAST}    ${TAKEN_USERNAME}    ${VALID_PASSWORD}    05    17    2099    DOB    *    High

YH-N13 Date of birth below the minimum age
    ${VALID_FIRST}    ${VALID_LAST}    ${VALID_USERNAME}    ${VALID_PASSWORD}    05    17    2020    PAGE    meet the requirements for creating an account    High

YH-N14 Date of birth month 13
    ${VALID_FIRST}    ${VALID_LAST}    ${TAKEN_USERNAME}    ${VALID_PASSWORD}    13    17    1990    DOB    *    Medium

YH-N15 First name with digits only
    1234    ${VALID_LAST}    ${TAKEN_USERNAME}    ${VALID_PASSWORD}    05    17    1990    FIRST_NAME    *    Medium

YH-N16 First name with special characters
    @#$%    ${VALID_LAST}    ${TAKEN_USERNAME}    ${VALID_PASSWORD}    05    17    1990    FIRST_NAME    *    Medium

YH-N17 Last name with digits and special characters
    ${VALID_FIRST}    5678^&*    ${TAKEN_USERNAME}    ${VALID_PASSWORD}    05    17    1990    LAST_NAME    *    Medium

