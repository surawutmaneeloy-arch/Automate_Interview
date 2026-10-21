"""Robot variable file: test data of the Basic Calculator test cases (one dict per test case).

The test case robot file (calculator_data_driven.robot) lists every test case and passes its dict as the
argument of the template keyword. Types: CALC, CLEAR, INT_TOGGLE, INT_STATE, CLEAR_STATE (see
Test_case/test_cases.md). Expected values come from the maths rules, never from the page.
"""

TC01 = dict(type="CALC", category="Normal", operation="Add",
    first="2", second="3", integers="No",
    expected="5", expected_error="", severity="Critical",
    technique="Normal value - positive integers (equivalence partitioning)")
TC02 = dict(type="CALC", category="Normal", operation="Add",
    first="-2", second="-3", integers="No",
    expected="-5", expected_error="", severity="High",
    technique="Normal value - both negative")
TC03 = dict(type="CALC", category="Normal", operation="Add",
    first="-5", second="3", integers="No",
    expected="-2", expected_error="", severity="High",
    technique="Mixed sign - result changes sign")
TC04 = dict(type="CALC", category="Boundary", operation="Add",
    first="0", second="0", integers="No",
    expected="0", expected_error="", severity="High",
    technique="Boundary - zero + zero")
TC05 = dict(type="CALC", category="Boundary", operation="Add",
    first="7", second="0", integers="No",
    expected="7", expected_error="", severity="Medium",
    technique="Identity element (adding zero)")
TC06 = dict(type="CALC", category="Normal", operation="Add",
    first="1.5", second="2.25", integers="No",
    expected="3.75", expected_error="", severity="High",
    technique="Normal value - decimals")
TC07 = dict(type="CALC", category="Boundary", operation="Add",
    first="9999999999", second="1", integers="No",
    expected="10000000000", expected_error="", severity="Medium",
    technique="Boundary - max input length (10 digits) overflows into 11 digits")
TC08 = dict(type="CALC", category="Normal", operation="Subtract",
    first="5", second="3", integers="No",
    expected="2", expected_error="", severity="Critical",
    technique="Normal value - positive integers")
TC09 = dict(type="CALC", category="Normal", operation="Subtract",
    first="3", second="5", integers="No",
    expected="-2", expected_error="", severity="High",
    technique="Operand order matters - negative result")
TC10 = dict(type="CALC", category="Boundary", operation="Subtract",
    first="0", second="5", integers="No",
    expected="-5", expected_error="", severity="Medium",
    technique="Boundary - zero as first operand")
TC11 = dict(type="CALC", category="Normal", operation="Subtract",
    first="-1.5", second="2.5", integers="No",
    expected="-4", expected_error="", severity="High",
    technique="Negative decimal minus positive decimal")
TC12 = dict(type="CALC", category="Boundary", operation="Subtract",
    first="4", second="4", integers="No",
    expected="0", expected_error="", severity="Medium",
    technique="Boundary - equal operands give zero")
TC13 = dict(type="CALC", category="Normal", operation="Multiply",
    first="4", second="3", integers="No",
    expected="12", expected_error="", severity="Critical",
    technique="Normal value - positive integers")
TC14 = dict(type="CALC", category="Normal", operation="Multiply",
    first="-3", second="4", integers="No",
    expected="-12", expected_error="", severity="High",
    technique="Sign rule - negative x positive")
TC15 = dict(type="CALC", category="Normal", operation="Multiply",
    first="-3", second="-4", integers="No",
    expected="12", expected_error="", severity="High",
    technique="Sign rule - negative x negative")
TC16 = dict(type="CALC", category="Boundary", operation="Multiply",
    first="0", second="5", integers="No",
    expected="0", expected_error="", severity="Medium",
    technique="Boundary - multiply by zero")
TC17 = dict(type="CALC", category="Normal", operation="Multiply",
    first="1.5", second="2", integers="No",
    expected="3", expected_error="", severity="High",
    technique="Decimal x integer")
TC18 = dict(type="CALC", category="Boundary", operation="Multiply",
    first="99999", second="99999", integers="No",
    expected="9999800001", expected_error="", severity="Medium",
    technique="Boundary - large result close to 10 digits")
TC19 = dict(type="CALC", category="Normal", operation="Multiply",
    first="0.5", second="0.5", integers="No",
    expected="0.25", expected_error="", severity="Medium",
    technique="Decimal x decimal (binary exact)")
TC20 = dict(type="CALC", category="Normal", operation="Divide",
    first="10", second="4", integers="No",
    expected="2.5", expected_error="", severity="Critical",
    technique="Normal value - non-integer result")
TC21 = dict(type="CALC", category="Normal", operation="Divide",
    first="4", second="10", integers="No",
    expected="0.4", expected_error="", severity="High",
    technique="Operand order matters (swap of TC20)")
TC22 = dict(type="CALC", category="Boundary", operation="Divide",
    first="0", second="5", integers="No",
    expected="0", expected_error="", severity="Medium",
    technique="Boundary - zero dividend")
TC23 = dict(type="CALC", category="Normal", operation="Divide",
    first="-7", second="2", integers="No",
    expected="-3.5", expected_error="", severity="High",
    technique="Negative dividend with decimal result")
TC24 = dict(type="CALC", category="Normal", operation="Divide",
    first="8", second="2", integers="No",
    expected="4", expected_error="", severity="High",
    technique="Exact division")
TC25 = dict(type="CALC", category="Negative", operation="Divide",
    first="5", second="0", integers="No",
    expected="", expected_error="Divide by zero error!", severity="Critical",
    technique="Special case - division by zero must be rejected")
TC26 = dict(type="CALC", category="Negative", operation="Divide",
    first="0", second="0", integers="No",
    expected="", expected_error="Divide by zero error!", severity="High",
    technique="Special case - 0 / 0")
TC27 = dict(type="CALC", category="Normal", operation="Concatenate",
    first="abc", second="def", integers="No",
    expected="abcdef", expected_error="", severity="Critical",
    technique="Strings are joined, no numeric validation")
TC28 = dict(type="CALC", category="Normal", operation="Concatenate",
    first="1", second="2", integers="No",
    expected="12", expected_error="", severity="Critical",
    technique="Numbers are treated as text (not 3)")
TC29 = dict(type="CALC", category="Normal", operation="Concatenate",
    first="-1", second="0.5", integers="No",
    expected="-10.5", expected_error="", severity="High",
    technique="Negative and decimal text joined")
TC30 = dict(type="CALC", category="Boundary", operation="Concatenate",
    first="", second="abc", integers="No",
    expected="abc", expected_error="", severity="Medium",
    technique="Boundary - empty first string")
TC31 = dict(type="CALC", category="Normal", operation="Concatenate",
    first="@#$", second="12", integers="No",
    expected="@#$12", expected_error="", severity="Medium",
    technique="Special characters are allowed for text")
TC32 = dict(type="CALC", category="Integers only", operation="Add",
    first="1.5", second="2.25", integers="Yes",
    expected="3", expected_error="", severity="High",
    technique="Integers only - 3.75 shown as 3")
TC33 = dict(type="CALC", category="Integers only", operation="Add",
    first="1.7", second="1.2", integers="Yes",
    expected="2", expected_error="", severity="High",
    technique="Truncate not round - 2.9 shown as 2")
TC34 = dict(type="CALC", category="Integers only", operation="Add",
    first="-1.5", second="-1.5", integers="Yes",
    expected="-3", expected_error="", severity="Medium",
    technique="Integers only - negative result without decimals")
TC35 = dict(type="CALC", category="Integers only", operation="Subtract",
    first="1.5", second="4", integers="Yes",
    expected="-2", expected_error="", severity="Medium",
    technique="Truncate toward zero - -2.5 shown as -2")
TC36 = dict(type="CALC", category="Integers only", operation="Multiply",
    first="1.5", second="2", integers="Yes",
    expected="3", expected_error="", severity="Medium",
    technique="Integer result is unchanged")
TC37 = dict(type="CALC", category="Integers only", operation="Divide",
    first="10", second="4", integers="Yes",
    expected="2", expected_error="", severity="High",
    technique="Integers only - 2.5 shown as 2")
TC38 = dict(type="CALC", category="Integers only", operation="Divide",
    first="-7", second="2", integers="Yes",
    expected="-3", expected_error="", severity="Medium",
    technique="Truncate toward zero - -3.5 shown as -3")
TC39 = dict(type="CALC", category="Integers only", operation="Divide",
    first="7", second="2", integers="Yes",
    expected="3", expected_error="", severity="Medium",
    technique="Truncate not round - 3.5 shown as 3")
TC40 = dict(type="CALC", category="Integers only", operation="Add",
    first="0.5", second="0.4", integers="Yes",
    expected="0", expected_error="", severity="Medium",
    technique="Boundary - 0.9 shown as 0")
TC41 = dict(type="CALC", category="Integers only", operation="Subtract",
    first="5", second="3", integers="Yes",
    expected="2", expected_error="", severity="Medium",
    technique="Integer inputs unaffected by the checkbox")
TC42 = dict(type="CALC", category="Integers only", operation="Divide",
    first="5", second="0", integers="Yes",
    expected="", expected_error="Divide by zero error!", severity="Medium",
    technique="Division by zero with Integers only ticked")
TC43 = dict(type="CALC", category="Negative", operation="Add",
    first="abc", second="1", integers="No",
    expected="", expected_error="Number 1 is not a number", severity="High",
    technique="Invalid input - text in first number")
TC44 = dict(type="CALC", category="Negative", operation="Add",
    first="1", second="abc", integers="No",
    expected="", expected_error="Number 2 is not a number", severity="High",
    technique="Invalid input - text in second number")
TC45 = dict(type="CALC", category="Negative", operation="Add",
    first="abc", second="xyz", integers="No",
    expected="", expected_error="Number 1 is not a number", severity="Medium",
    technique="Both invalid - first number reported first")
TC46 = dict(type="CALC", category="Negative", operation="Subtract",
    first="1,5", second="2", integers="No",
    expected="", expected_error="Number 1 is not a number", severity="Medium",
    technique="Invalid format - comma as decimal separator")
TC47 = dict(type="CALC", category="Negative", operation="Multiply",
    first="3", second="@#", integers="No",
    expected="", expected_error="Number 2 is not a number", severity="High",
    technique="Invalid input - special characters")
TC48 = dict(type="CALC", category="Negative", operation="Divide",
    first="abc", second="2", integers="No",
    expected="", expected_error="Number 1 is not a number", severity="High",
    technique="Invalid input - text for Divide")
TC49 = dict(type="CALC", category="Negative", operation="Add",
    first="--5", second="1", integers="No",
    expected="", expected_error="Number 1 is not a number", severity="Medium",
    technique="Invalid format - double minus")
TC50 = dict(type="CALC", category="Negative", operation="Subtract",
    first="1", second="1 2", integers="No",
    expected="", expected_error="Number 2 is not a number", severity="Medium",
    technique="Invalid format - space inside number")
TC51 = dict(type="CALC", category="Boundary", operation="Add",
    first="", second="5", integers="No",
    expected="5", expected_error="", severity="Low",
    technique="Boundary - blank first number treated as 0 (assumption 2)")
TC52 = dict(type="CALC", category="Boundary", operation="Add",
    first="", second="", integers="No",
    expected="0", expected_error="", severity="Low",
    technique="Boundary - both fields blank (assumption 2)")
TC53 = dict(type="CLEAR", category="Clear", operation="Add",
    first="2", second="3", integers="No",
    expected="", expected_error="", severity="Medium",
    technique="Clear removes the answer after a calculation")
TC54 = dict(type="CLEAR", category="Clear", operation="Add",
    first="1.5", second="2.25", integers="Yes",
    expected="", expected_error="", severity="Medium",
    technique="Clear removes the answer and un-ticks Integers only")
TC55 = dict(type="CLEAR", category="Clear", operation="Add",
    first="abc", second="1", integers="No",
    expected="", expected_error="", severity="Medium",
    technique="Clear removes the validation error message")
TC56 = dict(type="CLEAR", category="Clear", operation="Concatenate",
    first="abc", second="def", integers="No",
    expected="", expected_error="", severity="Medium",
    technique="Clear removes a concatenated answer")
TC57 = dict(type="CLEAR", category="Clear", operation="Divide",
    first="10", second="4", integers="No",
    expected="", expected_error="", severity="Medium",
    technique="Clear after a decimal answer")
TC58 = dict(type="INT_TOGGLE", category="Integers only", operation="Add",
    first="1.5", second="2.25", integers="No",
    expected="3", expected_error="", severity="Medium",
    technique="State transition - tick the checkbox after calculating")
TC59 = dict(type="INT_TOGGLE", category="Integers only", operation="Divide",
    first="-7", second="2", integers="No",
    expected="-3", expected_error="", severity="Medium",
    technique="State transition - negative decimal answer")
TC60 = dict(type="INT_TOGGLE", category="Integers only", operation="Multiply",
    first="4", second="3", integers="No",
    expected="12", expected_error="", severity="Low",
    technique="State transition - integer answer unchanged")
TC61 = dict(type="INT_STATE", category="Integers only", operation="Concatenate",
    first="", second="", integers="No",
    expected="disabled", expected_error="", severity="High",
    technique="Integers only must be disabled for Concatenate")
TC62 = dict(type="INT_STATE", category="Integers only", operation="Add",
    first="", second="", integers="No",
    expected="enabled", expected_error="", severity="Medium",
    technique="Integers only is available for Add")
TC63 = dict(type="INT_STATE", category="Integers only", operation="Divide",
    first="", second="", integers="No",
    expected="enabled", expected_error="", severity="Medium",
    technique="Integers only is available for Divide")
TC64 = dict(type="CLEAR_STATE", category="Clear", operation="Add",
    first="", second="", integers="No",
    expected="enabled", expected_error="", severity="Medium",
    technique="Clear button is available on a fresh page (before any calculation)")
