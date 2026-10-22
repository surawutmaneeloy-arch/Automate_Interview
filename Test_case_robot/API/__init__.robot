*** Settings ***
Documentation       API tests of FakeRESTApi (Swagger: https://fakerestapi.azurewebsites.net/index.html), resources Books and Authors.
...                 The base URL is configuration (robot.toml: API_BASE_URL). Negative expectations follow REST conventions
...                 and are documented in README.md.
Resource            api_test_case.resource
Variables           api_test_data.py
