*** Settings ***
Documentation       Yahoo create account - positive tests. Valid data is only typed in, never submitted with Next.
...                 Test data comes from yahoo_test_data.py and is passed to the keywords as arguments.
Resource            yahoo_test_case.resource
Variables           yahoo_test_data.py

Test Teardown       Finish Yahoo Test
Test Tags           yahoo    ui    positive


*** Test Cases ***
YH-P01 Valid data in every field shows no error
    Valid Data Shows No Error    ${VALID_FIRST}    ${VALID_LAST}    ${VALID_USERNAME}    ${VALID_PASSWORD}
    ...    ${VALID_MONTH}    ${VALID_DAY}    ${VALID_YEAR}    Critical

YH-P02 Strong password is not flagged
    Strong Password Is Accepted    ${VALID_PASSWORD}    High

YH-P03 Terms link opens
    Legal Link Opens    Terms    ${YH_TERMS_LINK}    ${TERMS_URL_PART}    Medium

YH-P04 Privacy link opens
    Legal Link Opens    Privacy Policy    ${YH_PRIVACY_LINK}    ${PRIVACY_URL_PART}    Medium