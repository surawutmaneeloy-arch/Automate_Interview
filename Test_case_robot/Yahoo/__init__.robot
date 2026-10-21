*** Settings ***
Documentation       UI tests of the Yahoo "Create account" page (https://login.yahoo.com/account/create).
...                 Only the on-screen validation is tested: no test completes (or tries to bypass) the registration.
...                 Page Object = Process_keyword/yahoo_create_account_page.resource, locators = Locator/yahoo_locators.resource.
Resource            yahoo_test_case.resource
Variables           yahoo_test_data.py

Suite Setup         Start Yahoo Suite
Suite Teardown      Finish Yahoo Suite
