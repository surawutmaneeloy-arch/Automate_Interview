# Test Result - Build 4

- Executed: 2026-10-21 17:36:14
- Total: 64 | Passed: 57 | Failed: 7 | Pass rate: 89.1%

## Test results

| TC ID | Type | Category | Operation | First number | Second number | Integers only | Expected | Actual | Status | Severity | Message |
|---|---|---|---|---|---|---|---|---|---|---|---|
| TC01 | CALC | Normal | Add | 2 | 3 | No | answer='5' \| error='' | answer='5' \| error='' | PASS | Critical |  |
| TC02 | CALC | Normal | Add | -2 | -3 | No | answer='-5' \| error='' | answer='-5' \| error='' | PASS | High |  |
| TC03 | CALC | Normal | Add | -5 | 3 | No | answer='-2' \| error='' | answer='-2' \| error='' | PASS | High |  |
| TC04 | CALC | Boundary | Add | 0 | 0 | No | answer='0' \| error='' | answer='0' \| error='' | PASS | High |  |
| TC05 | CALC | Boundary | Add | 7 | 0 | No | answer='7' \| error='' | answer='7' \| error='' | PASS | Medium |  |
| TC06 | CALC | Normal | Add | 1.5 | 2.25 | No | answer='3.75' \| error='' | answer='3' \| error='' | FAIL | High | Expected [answer='3.75' \| error=''] but was [answer='3' \| error='']: answer='3' \| error='' != answer='3.75' \| error='' |
| TC07 | CALC | Boundary | Add | 9999999999 | 1 | No | answer='10000000000' \| error='' | answer='10000000000' \| error='' | PASS | Medium |  |
| TC08 | CALC | Normal | Subtract | 5 | 3 | No | answer='2' \| error='' | answer='2' \| error='' | PASS | Critical |  |
| TC09 | CALC | Normal | Subtract | 3 | 5 | No | answer='-2' \| error='' | answer='-2' \| error='' | PASS | High |  |
| TC10 | CALC | Boundary | Subtract | 0 | 5 | No | answer='-5' \| error='' | answer='-5' \| error='' | PASS | Medium |  |
| TC11 | CALC | Normal | Subtract | -1.5 | 2.5 | No | answer='-4' \| error='' | answer='-4' \| error='' | PASS | High |  |
| TC12 | CALC | Boundary | Subtract | 4 | 4 | No | answer='0' \| error='' | answer='0' \| error='' | PASS | Medium |  |
| TC13 | CALC | Normal | Multiply | 4 | 3 | No | answer='12' \| error='' | answer='12' \| error='' | PASS | Critical |  |
| TC14 | CALC | Normal | Multiply | -3 | 4 | No | answer='-12' \| error='' | answer='-12' \| error='' | PASS | High |  |
| TC15 | CALC | Normal | Multiply | -3 | -4 | No | answer='12' \| error='' | answer='12' \| error='' | PASS | High |  |
| TC16 | CALC | Boundary | Multiply | 0 | 5 | No | answer='0' \| error='' | answer='0' \| error='' | PASS | Medium |  |
| TC17 | CALC | Normal | Multiply | 1.5 | 2 | No | answer='3' \| error='' | answer='3' \| error='' | PASS | High |  |
| TC18 | CALC | Boundary | Multiply | 99999 | 99999 | No | answer='9999800001' \| error='' | answer='9999800001' \| error='' | PASS | Medium |  |
| TC19 | CALC | Normal | Multiply | 0.5 | 0.5 | No | answer='0.25' \| error='' | answer='0' \| error='' | FAIL | Medium | Expected [answer='0.25' \| error=''] but was [answer='0' \| error='']: answer='0' \| error='' != answer='0.25' \| error='' |
| TC20 | CALC | Normal | Divide | 10 | 4 | No | answer='2.5' \| error='' | answer='2' \| error='' | FAIL | Critical | Expected [answer='2.5' \| error=''] but was [answer='2' \| error='']: answer='2' \| error='' != answer='2.5' \| error='' |
| TC21 | CALC | Normal | Divide | 4 | 10 | No | answer='0.4' \| error='' | answer='0' \| error='' | FAIL | High | Expected [answer='0.4' \| error=''] but was [answer='0' \| error='']: answer='0' \| error='' != answer='0.4' \| error='' |
| TC22 | CALC | Boundary | Divide | 0 | 5 | No | answer='0' \| error='' | answer='0' \| error='' | PASS | Medium |  |
| TC23 | CALC | Normal | Divide | -7 | 2 | No | answer='-3.5' \| error='' | answer='-3' \| error='' | FAIL | High | Expected [answer='-3.5' \| error=''] but was [answer='-3' \| error='']: answer='-3' \| error='' != answer='-3.5' \| error='' |
| TC24 | CALC | Normal | Divide | 8 | 2 | No | answer='4' \| error='' | answer='4' \| error='' | PASS | High |  |
| TC25 | CALC | Negative | Divide | 5 | 0 | No | answer='' \| error='Divide by zero error!' | answer='' \| error='Divide by zero error!' | PASS | Critical |  |
| TC26 | CALC | Negative | Divide | 0 | 0 | No | answer='' \| error='Divide by zero error!' | answer='' \| error='Divide by zero error!' | PASS | High |  |
| TC27 | CALC | Normal | Concatenate | abc | def | No | answer='abcdef' \| error='' | answer='abcdef' \| error='' | PASS | Critical |  |
| TC28 | CALC | Normal | Concatenate | 1 | 2 | No | answer='12' \| error='' | answer='12' \| error='' | PASS | Critical |  |
| TC29 | CALC | Normal | Concatenate | -1 | 0.5 | No | answer='-10.5' \| error='' | answer='-10.5' \| error='' | PASS | High |  |
| TC30 | CALC | Boundary | Concatenate |  | abc | No | answer='abc' \| error='' | answer='abc' \| error='' | PASS | Medium |  |
| TC31 | CALC | Normal | Concatenate | @#$ | 12 | No | answer='@#$12' \| error='' | answer='@#$12' \| error='' | PASS | Medium |  |
| TC32 | CALC | Integers only | Add | 1.5 | 2.25 | Yes | answer='3' \| error='' | answer='3' \| error='' | PASS | High |  |
| TC33 | CALC | Integers only | Add | 1.7 | 1.2 | Yes | answer='2' \| error='' | answer='2' \| error='' | PASS | High |  |
| TC34 | CALC | Integers only | Add | -1.5 | -1.5 | Yes | answer='-3' \| error='' | answer='-3' \| error='' | PASS | Medium |  |
| TC35 | CALC | Integers only | Subtract | 1.5 | 4 | Yes | answer='-2' \| error='' | answer='-2' \| error='' | PASS | Medium |  |
| TC36 | CALC | Integers only | Multiply | 1.5 | 2 | Yes | answer='3' \| error='' | answer='3' \| error='' | PASS | Medium |  |
| TC37 | CALC | Integers only | Divide | 10 | 4 | Yes | answer='2' \| error='' | answer='2' \| error='' | PASS | High |  |
| TC38 | CALC | Integers only | Divide | -7 | 2 | Yes | answer='-3' \| error='' | answer='-3' \| error='' | PASS | Medium |  |
| TC39 | CALC | Integers only | Divide | 7 | 2 | Yes | answer='3' \| error='' | answer='3' \| error='' | PASS | Medium |  |
| TC40 | CALC | Integers only | Add | 0.5 | 0.4 | Yes | answer='0' \| error='' | answer='0' \| error='' | PASS | Medium |  |
| TC41 | CALC | Integers only | Subtract | 5 | 3 | Yes | answer='2' \| error='' | answer='2' \| error='' | PASS | Medium |  |
| TC42 | CALC | Integers only | Divide | 5 | 0 | Yes | answer='' \| error='Divide by zero error!' | answer='' \| error='Divide by zero error!' | PASS | Medium |  |
| TC43 | CALC | Negative | Add | abc | 1 | No | answer='' \| error='Number 1 is not a number' | answer='' \| error='Number 1 is not a number' | PASS | High |  |
| TC44 | CALC | Negative | Add | 1 | abc | No | answer='' \| error='Number 2 is not a number' | answer='' \| error='Number 2 is not a number' | PASS | High |  |
| TC45 | CALC | Negative | Add | abc | xyz | No | answer='' \| error='Number 1 is not a number' | answer='' \| error='Number 1 is not a number' | PASS | Medium |  |
| TC46 | CALC | Negative | Subtract | 1,5 | 2 | No | answer='' \| error='Number 1 is not a number' | answer='' \| error='Number 1 is not a number' | PASS | Medium |  |
| TC47 | CALC | Negative | Multiply | 3 | @# | No | answer='' \| error='Number 2 is not a number' | answer='' \| error='Number 2 is not a number' | PASS | High |  |
| TC48 | CALC | Negative | Divide | abc | 2 | No | answer='' \| error='Number 1 is not a number' | answer='' \| error='Number 1 is not a number' | PASS | High |  |
| TC49 | CALC | Negative | Add | --5 | 1 | No | answer='' \| error='Number 1 is not a number' | answer='' \| error='Number 1 is not a number' | PASS | Medium |  |
| TC50 | CALC | Negative | Subtract | 1 | 1 2 | No | answer='' \| error='Number 2 is not a number' | answer='' \| error='Number 2 is not a number' | PASS | Medium |  |
| TC51 | CALC | Boundary | Add |  | 5 | No | answer='5' \| error='' | answer='5' \| error='' | PASS | Low |  |
| TC52 | CALC | Boundary | Add |  |  | No | answer='0' \| error='' | answer='0' \| error='' | PASS | Low |  |
| TC53 | CLEAR | Clear | Add | 2 | 3 | No | answer='' \| error='' \| integers_checked=False | answer='' \| error='' \| integers_checked=False | PASS | Medium |  |
| TC54 | CLEAR | Clear | Add | 1.5 | 2.25 | Yes | answer='' \| error='' \| integers_checked=False | answer='' \| error='' \| integers_checked=False | PASS | Medium |  |
| TC55 | CLEAR | Clear | Add | abc | 1 | No | answer='' \| error='' \| integers_checked=False | answer='' \| error='' \| integers_checked=False | PASS | Medium |  |
| TC56 | CLEAR | Clear | Concatenate | abc | def | No | answer='' \| error='' \| integers_checked=False | answer='' \| error='' \| integers_checked=False | PASS | Medium |  |
| TC57 | CLEAR | Clear | Divide | 10 | 4 | No | answer='' \| error='' \| integers_checked=False | answer='' \| error='' \| integers_checked=False | PASS | Medium |  |
| TC58 | INT_TOGGLE | Integers only | Add | 1.5 | 2.25 | No | answer='3' \| error='' | answer='3' \| error='' | PASS | Medium |  |
| TC59 | INT_TOGGLE | Integers only | Divide | -7 | 2 | No | answer='-3' \| error='' | answer='-3' \| error='' | PASS | Medium |  |
| TC60 | INT_TOGGLE | Integers only | Multiply | 4 | 3 | No | answer='12' \| error='' | answer='12' \| error='' | PASS | Low |  |
| TC61 | INT_STATE | Integers only | Concatenate |  |  | No | integers_checkbox=disabled | integers_checkbox=disabled | PASS | High |  |
| TC62 | INT_STATE | Integers only | Add |  |  | No | integers_checkbox=enabled | integers_checkbox=disabled | FAIL | Medium | Expected [integers_checkbox=enabled] but was [integers_checkbox=disabled]: integers_checkbox=disabled != integers_checkbox=enabled |
| TC63 | INT_STATE | Integers only | Divide |  |  | No | integers_checkbox=enabled | integers_checkbox=disabled | FAIL | Medium | Expected [integers_checkbox=enabled] but was [integers_checkbox=disabled]: integers_checkbox=disabled != integers_checkbox=enabled |
| TC64 | CLEAR_STATE | Clear | Add |  |  | No | clear_button=enabled | clear_button=enabled | PASS | Medium |  |

## Defects (auto logged in test teardown)

| Defect ID | Build | TC ID | Title | Severity | Status | Input | Expected | Actual | Steps to reproduce | Evidence | Detected at |
|---|---|---|---|---|---|---|---|---|---|---|---|
| DEF-B4-TC06 | Build 4 | TC06 | [Build 4] TC06 CALC Add: expected result not met | High | Open | Add: First='1.5', Second='2.25', Integers only=No | answer='3.75' \| error='' | answer='3' \| error='' | 1. Open https://testsheepnz.github.io/BasicCalculator.html<br>2. Select Build = Build 4<br>3. Select Operation = Add<br>4. Enter First number = '1.5', Second number = '2.25'<br>5. Click Calculate | browser/screenshot/TC06_B4.png | 2026-10-21 17:35:39 |
| DEF-B4-TC19 | Build 4 | TC19 | [Build 4] TC19 CALC Multiply: expected result not met | Medium | Open | Multiply: First='0.5', Second='0.5', Integers only=No | answer='0.25' \| error='' | answer='0' \| error='' | 1. Open https://testsheepnz.github.io/BasicCalculator.html<br>2. Select Build = Build 4<br>3. Select Operation = Multiply<br>4. Enter First number = '0.5', Second number = '0.5'<br>5. Click Calculate | browser/screenshot/TC19_B4.png | 2026-10-21 17:35:48 |
| DEF-B4-TC20 | Build 4 | TC20 | [Build 4] TC20 CALC Divide: expected result not met | Critical | Open | Divide: First='10', Second='4', Integers only=No | answer='2.5' \| error='' | answer='2' \| error='' | 1. Open https://testsheepnz.github.io/BasicCalculator.html<br>2. Select Build = Build 4<br>3. Select Operation = Divide<br>4. Enter First number = '10', Second number = '4'<br>5. Click Calculate | browser/screenshot/TC20_B4.png | 2026-10-21 17:35:48 |
| DEF-B4-TC21 | Build 4 | TC21 | [Build 4] TC21 CALC Divide: expected result not met | High | Open | Divide: First='4', Second='10', Integers only=No | answer='0.4' \| error='' | answer='0' \| error='' | 1. Open https://testsheepnz.github.io/BasicCalculator.html<br>2. Select Build = Build 4<br>3. Select Operation = Divide<br>4. Enter First number = '4', Second number = '10'<br>5. Click Calculate | browser/screenshot/TC21_B4.png | 2026-10-21 17:35:49 |
| DEF-B4-TC23 | Build 4 | TC23 | [Build 4] TC23 CALC Divide: expected result not met | High | Open | Divide: First='-7', Second='2', Integers only=No | answer='-3.5' \| error='' | answer='-3' \| error='' | 1. Open https://testsheepnz.github.io/BasicCalculator.html<br>2. Select Build = Build 4<br>3. Select Operation = Divide<br>4. Enter First number = '-7', Second number = '2'<br>5. Click Calculate | browser/screenshot/TC23_B4.png | 2026-10-21 17:35:51 |
| DEF-B4-TC62 | Build 4 | TC62 | [Build 4] TC62 INT_STATE Add: expected result not met | Medium | Open | Operation: Add | integers_checkbox=enabled | integers_checkbox=disabled | 1. Open https://testsheepnz.github.io/BasicCalculator.html<br>2. Select Build = Build 4<br>3. Select Operation = Add<br>4. Inspect the 'Integers only' checkbox | browser/screenshot/TC62_B4.png | 2026-10-21 17:36:13 |
| DEF-B4-TC63 | Build 4 | TC63 | [Build 4] TC63 INT_STATE Divide: expected result not met | Medium | Open | Operation: Divide | integers_checkbox=enabled | integers_checkbox=disabled | 1. Open https://testsheepnz.github.io/BasicCalculator.html<br>2. Select Build = Build 4<br>3. Select Operation = Divide<br>4. Inspect the 'Integers only' checkbox | browser/screenshot/TC63_B4.png | 2026-10-21 17:36:14 |
