# Test Cases - Basic Calculator

URL: https://testsheepnz.github.io/BasicCalculator.html

This table is exported from the test data of the automation (`Test_case_robot/Calculator/calculator_test_data.py`, one record per
test case; `calculator_data_driven.robot` lists the same test cases and passes each record to the template keyword).
Refresh this file and `Test_case/test_cases.xlsx` with `python Test_case/export_test_cases.py` after changing the data file.

## Conventions

- `(empty)` = leave the field blank / no expected value.
- **Type**
  - `CALC` - set Operation + numbers (+ Integers only), click Calculate, verify the Answer / error message.
  - `CLEAR` - same as CALC, then click Clear. Expected = state after Clear (answer empty, error empty, Integers only unchecked).
  - `INT_TOGGLE` - Calculate with the checkbox unchecked, then tick "Integers only" and verify the displayed answer.
  - `INT_STATE` - select the Operation and verify whether the "Integers only" checkbox is `enabled` or `disabled`.
  - `CLEAR_STATE` - open a fresh page and verify whether the Clear button is `enabled` or `disabled` before any calculation.
- **Expected result** = value in the Answer field. **Expected error** = text in the red error label.
- Expected values are calculated from the mathematical rules (not read from the page).

## Assumptions (requirement is silent - agreed to be confirmed with the BA/PO)

1. "Integers only" truncates the decimal part toward zero (2.9 -> 2, -2.5 -> -2, 3.5 -> 3); it does not round.
2. A blank number field is treated as 0 for Add (TC51, TC52).
3. Validation order: First number is validated before Second number.
4. Clear removes the answer and the error message and un-ticks "Integers only"; it does not clear the input fields (not asserted).
5. Floating point artifacts (0.1 + 0.2) are out of scope; decimal tests use binary-exact values.

## Test Case Table

| TC ID | Type | Category | Operation | First number | Second number | Integers only | Expected result | Expected error | Severity | Technique / Rationale |
|---|---|---|---|---|---|---|---|---|---|---|
| TC01 | CALC | Normal | Add | 2 | 3 | No | 5 | (empty) | Critical | Normal value - positive integers (equivalence partitioning) |
| TC02 | CALC | Normal | Add | -2 | -3 | No | -5 | (empty) | High | Normal value - both negative |
| TC03 | CALC | Normal | Add | -5 | 3 | No | -2 | (empty) | High | Mixed sign - result changes sign |
| TC04 | CALC | Boundary | Add | 0 | 0 | No | 0 | (empty) | High | Boundary - zero + zero |
| TC05 | CALC | Boundary | Add | 7 | 0 | No | 7 | (empty) | Medium | Identity element (adding zero) |
| TC06 | CALC | Normal | Add | 1.5 | 2.25 | No | 3.75 | (empty) | High | Normal value - decimals |
| TC07 | CALC | Boundary | Add | 9999999999 | 1 | No | 10000000000 | (empty) | Medium | Boundary - max input length (10 digits) overflows into 11 digits |
| TC08 | CALC | Normal | Subtract | 5 | 3 | No | 2 | (empty) | Critical | Normal value - positive integers |
| TC09 | CALC | Normal | Subtract | 3 | 5 | No | -2 | (empty) | High | Operand order matters - negative result |
| TC10 | CALC | Boundary | Subtract | 0 | 5 | No | -5 | (empty) | Medium | Boundary - zero as first operand |
| TC11 | CALC | Normal | Subtract | -1.5 | 2.5 | No | -4 | (empty) | High | Negative decimal minus positive decimal |
| TC12 | CALC | Boundary | Subtract | 4 | 4 | No | 0 | (empty) | Medium | Boundary - equal operands give zero |
| TC13 | CALC | Normal | Multiply | 4 | 3 | No | 12 | (empty) | Critical | Normal value - positive integers |
| TC14 | CALC | Normal | Multiply | -3 | 4 | No | -12 | (empty) | High | Sign rule - negative x positive |
| TC15 | CALC | Normal | Multiply | -3 | -4 | No | 12 | (empty) | High | Sign rule - negative x negative |
| TC16 | CALC | Boundary | Multiply | 0 | 5 | No | 0 | (empty) | Medium | Boundary - multiply by zero |
| TC17 | CALC | Normal | Multiply | 1.5 | 2 | No | 3 | (empty) | High | Decimal x integer |
| TC18 | CALC | Boundary | Multiply | 99999 | 99999 | No | 9999800001 | (empty) | Medium | Boundary - large result close to 10 digits |
| TC19 | CALC | Normal | Multiply | 0.5 | 0.5 | No | 0.25 | (empty) | Medium | Decimal x decimal (binary exact) |
| TC20 | CALC | Normal | Divide | 10 | 4 | No | 2.5 | (empty) | Critical | Normal value - non-integer result |
| TC21 | CALC | Normal | Divide | 4 | 10 | No | 0.4 | (empty) | High | Operand order matters (swap of TC20) |
| TC22 | CALC | Boundary | Divide | 0 | 5 | No | 0 | (empty) | Medium | Boundary - zero dividend |
| TC23 | CALC | Normal | Divide | -7 | 2 | No | -3.5 | (empty) | High | Negative dividend with decimal result |
| TC24 | CALC | Normal | Divide | 8 | 2 | No | 4 | (empty) | High | Exact division |
| TC25 | CALC | Negative | Divide | 5 | 0 | No | (empty) | Divide by zero error! | Critical | Special case - division by zero must be rejected |
| TC26 | CALC | Negative | Divide | 0 | 0 | No | (empty) | Divide by zero error! | High | Special case - 0 / 0 |
| TC27 | CALC | Normal | Concatenate | abc | def | No | abcdef | (empty) | Critical | Strings are joined, no numeric validation |
| TC28 | CALC | Normal | Concatenate | 1 | 2 | No | 12 | (empty) | Critical | Numbers are treated as text (not 3) |
| TC29 | CALC | Normal | Concatenate | -1 | 0.5 | No | -10.5 | (empty) | High | Negative and decimal text joined |
| TC30 | CALC | Boundary | Concatenate | (empty) | abc | No | abc | (empty) | Medium | Boundary - empty first string |
| TC31 | CALC | Normal | Concatenate | @#$ | 12 | No | @#$12 | (empty) | Medium | Special characters are allowed for text |
| TC32 | CALC | Integers only | Add | 1.5 | 2.25 | Yes | 3 | (empty) | High | Integers only - 3.75 shown as 3 |
| TC33 | CALC | Integers only | Add | 1.7 | 1.2 | Yes | 2 | (empty) | High | Truncate not round - 2.9 shown as 2 |
| TC34 | CALC | Integers only | Add | -1.5 | -1.5 | Yes | -3 | (empty) | Medium | Integers only - negative result without decimals |
| TC35 | CALC | Integers only | Subtract | 1.5 | 4 | Yes | -2 | (empty) | Medium | Truncate toward zero - -2.5 shown as -2 |
| TC36 | CALC | Integers only | Multiply | 1.5 | 2 | Yes | 3 | (empty) | Medium | Integer result is unchanged |
| TC37 | CALC | Integers only | Divide | 10 | 4 | Yes | 2 | (empty) | High | Integers only - 2.5 shown as 2 |
| TC38 | CALC | Integers only | Divide | -7 | 2 | Yes | -3 | (empty) | Medium | Truncate toward zero - -3.5 shown as -3 |
| TC39 | CALC | Integers only | Divide | 7 | 2 | Yes | 3 | (empty) | Medium | Truncate not round - 3.5 shown as 3 |
| TC40 | CALC | Integers only | Add | 0.5 | 0.4 | Yes | 0 | (empty) | Medium | Boundary - 0.9 shown as 0 |
| TC41 | CALC | Integers only | Subtract | 5 | 3 | Yes | 2 | (empty) | Medium | Integer inputs unaffected by the checkbox |
| TC42 | CALC | Integers only | Divide | 5 | 0 | Yes | (empty) | Divide by zero error! | Medium | Division by zero with Integers only ticked |
| TC43 | CALC | Negative | Add | abc | 1 | No | (empty) | Number 1 is not a number | High | Invalid input - text in first number |
| TC44 | CALC | Negative | Add | 1 | abc | No | (empty) | Number 2 is not a number | High | Invalid input - text in second number |
| TC45 | CALC | Negative | Add | abc | xyz | No | (empty) | Number 1 is not a number | Medium | Both invalid - first number reported first |
| TC46 | CALC | Negative | Subtract | 1,5 | 2 | No | (empty) | Number 1 is not a number | Medium | Invalid format - comma as decimal separator |
| TC47 | CALC | Negative | Multiply | 3 | @# | No | (empty) | Number 2 is not a number | High | Invalid input - special characters |
| TC48 | CALC | Negative | Divide | abc | 2 | No | (empty) | Number 1 is not a number | High | Invalid input - text for Divide |
| TC49 | CALC | Negative | Add | --5 | 1 | No | (empty) | Number 1 is not a number | Medium | Invalid format - double minus |
| TC50 | CALC | Negative | Subtract | 1 | 1 2 | No | (empty) | Number 2 is not a number | Medium | Invalid format - space inside number |
| TC51 | CALC | Boundary | Add | (empty) | 5 | No | 5 | (empty) | Low | Boundary - blank first number treated as 0 (assumption 2) |
| TC52 | CALC | Boundary | Add | (empty) | (empty) | No | 0 | (empty) | Low | Boundary - both fields blank (assumption 2) |
| TC53 | CLEAR | Clear | Add | 2 | 3 | No | (empty) | (empty) | Medium | Clear removes the answer after a calculation |
| TC54 | CLEAR | Clear | Add | 1.5 | 2.25 | Yes | (empty) | (empty) | Medium | Clear removes the answer and un-ticks Integers only |
| TC55 | CLEAR | Clear | Add | abc | 1 | No | (empty) | (empty) | Medium | Clear removes the validation error message |
| TC56 | CLEAR | Clear | Concatenate | abc | def | No | (empty) | (empty) | Medium | Clear removes a concatenated answer |
| TC57 | CLEAR | Clear | Divide | 10 | 4 | No | (empty) | (empty) | Medium | Clear after a decimal answer |
| TC58 | INT_TOGGLE | Integers only | Add | 1.5 | 2.25 | No | 3 | (empty) | Medium | State transition - tick the checkbox after calculating |
| TC59 | INT_TOGGLE | Integers only | Divide | -7 | 2 | No | -3 | (empty) | Medium | State transition - negative decimal answer |
| TC60 | INT_TOGGLE | Integers only | Multiply | 4 | 3 | No | 12 | (empty) | Low | State transition - integer answer unchanged |
| TC61 | INT_STATE | Integers only | Concatenate | (empty) | (empty) | No | disabled | (empty) | High | Integers only must be disabled for Concatenate |
| TC62 | INT_STATE | Integers only | Add | (empty) | (empty) | No | enabled | (empty) | Medium | Integers only is available for Add |
| TC63 | INT_STATE | Integers only | Divide | (empty) | (empty) | No | enabled | (empty) | Medium | Integers only is available for Divide |
| TC64 | CLEAR_STATE | Clear | Add | (empty) | (empty) | No | enabled | (empty) | Medium | Clear button is available on a fresh page (before any calculation) |
