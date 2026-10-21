# Test Result Summary - Basic Calculator

- Generated: 2026-10-21 17:43:07

## Summary by build

| Build | Total | Passed | Failed | Pass rate | Result |
|---|---|---|---|---|---|
| Prototype | 64 | 64 | 0 | 100.0% | PASS |
| Build 1 | 64 | 56 | 8 | 87.5% | FAIL |
| Build 2 | 64 | 43 | 21 | 67.2% | FAIL |
| Build 3 | 64 | 60 | 4 | 93.8% | FAIL |
| Build 4 | 64 | 57 | 7 | 89.1% | FAIL |
| Build 5 | 64 | 63 | 1 | 98.4% | FAIL |
| Build 6 | 64 | 61 | 3 | 95.3% | FAIL |
| Build 7 | 64 | 23 | 41 | 35.9% | FAIL |
| Build 8 | 64 | 36 | 28 | 56.2% | FAIL |
| Build 9 | 64 | 4 | 60 | 6.2% | FAIL |

## Test case x build matrix

| TC ID | Type | Operation | First number | Second number | Integers only | Severity | Prototype | Build 1 | Build 2 | Build 3 | Build 4 | Build 5 | Build 6 | Build 7 | Build 8 | Build 9 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| TC01 | CALC | Add | 2 | 3 | No | Critical | PASS | PASS | FAIL | PASS | PASS | PASS | PASS | FAIL | PASS | FAIL |
| TC02 | CALC | Add | -2 | -3 | No | High | PASS | PASS | FAIL | PASS | PASS | PASS | PASS | FAIL | PASS | FAIL |
| TC03 | CALC | Add | -5 | 3 | No | High | PASS | PASS | FAIL | PASS | PASS | PASS | PASS | FAIL | PASS | FAIL |
| TC04 | CALC | Add | 0 | 0 | No | High | PASS | PASS | FAIL | PASS | PASS | PASS | PASS | PASS | PASS | FAIL |
| TC05 | CALC | Add | 7 | 0 | No | Medium | PASS | PASS | FAIL | PASS | PASS | PASS | PASS | FAIL | PASS | FAIL |
| TC06 | CALC | Add | 1.5 | 2.25 | No | High | PASS | PASS | FAIL | PASS | FAIL | PASS | PASS | FAIL | PASS | FAIL |
| TC07 | CALC | Add | 9999999999 | 1 | No | Medium | PASS | PASS | FAIL | PASS | PASS | PASS | PASS | FAIL | PASS | FAIL |
| TC08 | CALC | Subtract | 5 | 3 | No | Critical | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | FAIL | FAIL |
| TC09 | CALC | Subtract | 3 | 5 | No | High | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | FAIL | FAIL |
| TC10 | CALC | Subtract | 0 | 5 | No | Medium | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | FAIL |
| TC11 | CALC | Subtract | -1.5 | 2.5 | No | High | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | FAIL | FAIL |
| TC12 | CALC | Subtract | 4 | 4 | No | Medium | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | PASS | FAIL |
| TC13 | CALC | Multiply | 4 | 3 | No | Critical | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | PASS | FAIL |
| TC14 | CALC | Multiply | -3 | 4 | No | High | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | PASS | FAIL |
| TC15 | CALC | Multiply | -3 | -4 | No | High | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | PASS | FAIL |
| TC16 | CALC | Multiply | 0 | 5 | No | Medium | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL |
| TC17 | CALC | Multiply | 1.5 | 2 | No | High | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | PASS | FAIL |
| TC18 | CALC | Multiply | 99999 | 99999 | No | Medium | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | PASS | FAIL |
| TC19 | CALC | Multiply | 0.5 | 0.5 | No | Medium | PASS | PASS | PASS | PASS | FAIL | PASS | PASS | FAIL | PASS | FAIL |
| TC20 | CALC | Divide | 10 | 4 | No | Critical | PASS | PASS | PASS | PASS | FAIL | PASS | PASS | FAIL | FAIL | FAIL |
| TC21 | CALC | Divide | 4 | 10 | No | High | PASS | PASS | PASS | PASS | FAIL | PASS | PASS | FAIL | FAIL | FAIL |
| TC22 | CALC | Divide | 0 | 5 | No | Medium | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | FAIL |
| TC23 | CALC | Divide | -7 | 2 | No | High | PASS | PASS | PASS | PASS | FAIL | PASS | PASS | FAIL | FAIL | FAIL |
| TC24 | CALC | Divide | 8 | 2 | No | High | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | FAIL | FAIL |
| TC25 | CALC | Divide | 5 | 0 | No | Critical | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | PASS | FAIL | FAIL |
| TC26 | CALC | Divide | 0 | 0 | No | High | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | PASS | PASS | FAIL |
| TC27 | CALC | Concatenate | abc | def | No | Critical | PASS | PASS | FAIL | FAIL | PASS | PASS | PASS | FAIL | FAIL | FAIL |
| TC28 | CALC | Concatenate | 1 | 2 | No | Critical | PASS | PASS | FAIL | PASS | PASS | PASS | PASS | FAIL | FAIL | FAIL |
| TC29 | CALC | Concatenate | -1 | 0.5 | No | High | PASS | PASS | FAIL | PASS | PASS | PASS | PASS | FAIL | FAIL | FAIL |
| TC30 | CALC | Concatenate |  | abc | No | Medium | PASS | PASS | FAIL | FAIL | PASS | PASS | PASS | PASS | PASS | FAIL |
| TC31 | CALC | Concatenate | @#$ | 12 | No | Medium | PASS | PASS | FAIL | FAIL | PASS | PASS | PASS | FAIL | FAIL | FAIL |
| TC32 | CALC | Add | 1.5 | 2.25 | Yes | High | PASS | PASS | FAIL | PASS | PASS | PASS | PASS | FAIL | PASS | FAIL |
| TC33 | CALC | Add | 1.7 | 1.2 | Yes | High | PASS | PASS | FAIL | PASS | PASS | PASS | PASS | FAIL | PASS | FAIL |
| TC34 | CALC | Add | -1.5 | -1.5 | Yes | Medium | PASS | PASS | FAIL | PASS | PASS | PASS | PASS | FAIL | PASS | FAIL |
| TC35 | CALC | Subtract | 1.5 | 4 | Yes | Medium | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | FAIL | FAIL |
| TC36 | CALC | Multiply | 1.5 | 2 | Yes | Medium | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | PASS | FAIL |
| TC37 | CALC | Divide | 10 | 4 | Yes | High | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | FAIL | FAIL |
| TC38 | CALC | Divide | -7 | 2 | Yes | Medium | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | FAIL | FAIL |
| TC39 | CALC | Divide | 7 | 2 | Yes | Medium | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | FAIL | FAIL |
| TC40 | CALC | Add | 0.5 | 0.4 | Yes | Medium | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL |
| TC41 | CALC | Subtract | 5 | 3 | Yes | Medium | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | FAIL | FAIL |
| TC42 | CALC | Divide | 5 | 0 | Yes | Medium | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | PASS | FAIL | FAIL |
| TC43 | CALC | Add | abc | 1 | No | High | PASS | FAIL | FAIL | PASS | PASS | PASS | PASS | FAIL | FAIL | FAIL |
| TC44 | CALC | Add | 1 | abc | No | High | PASS | FAIL | FAIL | PASS | PASS | PASS | PASS | PASS | FAIL | FAIL |
| TC45 | CALC | Add | abc | xyz | No | Medium | PASS | FAIL | FAIL | PASS | PASS | PASS | PASS | FAIL | PASS | FAIL |
| TC46 | CALC | Subtract | 1,5 | 2 | No | Medium | PASS | FAIL | PASS | PASS | PASS | PASS | PASS | FAIL | FAIL | FAIL |
| TC47 | CALC | Multiply | 3 | @# | No | High | PASS | FAIL | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | FAIL |
| TC48 | CALC | Divide | abc | 2 | No | High | PASS | FAIL | PASS | PASS | PASS | PASS | PASS | FAIL | FAIL | FAIL |
| TC49 | CALC | Add | --5 | 1 | No | Medium | PASS | FAIL | FAIL | PASS | PASS | PASS | PASS | FAIL | FAIL | FAIL |
| TC50 | CALC | Subtract | 1 | 1 2 | No | Medium | PASS | FAIL | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | FAIL |
| TC51 | CALC | Add |  | 5 | No | Low | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL |
| TC52 | CALC | Add |  |  | No | Low | PASS | PASS | FAIL | PASS | PASS | PASS | PASS | PASS | PASS | FAIL |
| TC53 | CLEAR | Add | 2 | 3 | No | Medium | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL |
| TC54 | CLEAR | Add | 1.5 | 2.25 | Yes | Medium | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL |
| TC55 | CLEAR | Add | abc | 1 | No | Medium | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL |
| TC56 | CLEAR | Concatenate | abc | def | No | Medium | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL |
| TC57 | CLEAR | Divide | 10 | 4 | No | Medium | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL |
| TC58 | INT_TOGGLE | Add | 1.5 | 2.25 | No | Medium | PASS | PASS | FAIL | PASS | PASS | PASS | PASS | FAIL | PASS | FAIL |
| TC59 | INT_TOGGLE | Divide | -7 | 2 | No | Medium | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | FAIL | FAIL |
| TC60 | INT_TOGGLE | Multiply | 4 | 3 | No | Low | PASS | PASS | PASS | PASS | PASS | PASS | PASS | FAIL | PASS | FAIL |
| TC61 | INT_STATE | Concatenate |  |  | No | High | PASS | PASS | PASS | FAIL | PASS | PASS | PASS | PASS | PASS | PASS |
| TC62 | INT_STATE | Add |  |  | No | Medium | PASS | PASS | PASS | PASS | FAIL | PASS | PASS | PASS | PASS | PASS |
| TC63 | INT_STATE | Divide |  |  | No | Medium | PASS | PASS | PASS | PASS | FAIL | PASS | PASS | PASS | PASS | PASS |
| TC64 | CLEAR_STATE | Add |  |  | No | Medium | PASS | PASS | PASS | PASS | PASS | FAIL | PASS | PASS | PASS | PASS |
