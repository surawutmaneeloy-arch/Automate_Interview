*** Settings ***
Documentation       Data-driven tests for https://testsheepnz.github.io/BasicCalculator.html.
...                 The single template test below is expanded by DataDrivenModifier into one test per
...                 row of Test_case/test_cases.md. Select the build with --variable BUILD:<0-9>.
Resource            ../Common_keyword/calculator.resource

Suite Setup         Start Calculator Suite
Suite Teardown      Finish Calculator Suite
Test Setup          Open Calculator
Test Teardown       Log Result And Defect


*** Test Cases ***
Calculator Data Driven Template
    Skip    Placeholder - replaced by DataDrivenModifier (see robot.toml / run_tests.py)
