*** Settings ***
Documentation       Data-driven tests for https://testsheepnz.github.io/BasicCalculator.html.
...                 One test case = one record of calculator_test_data.py passed as the argument of the template
...                 keyword. The build is a parameter: `robotcode robot --variable BUILD:3` runs the same test
...                 cases against Build 3 (0 = Prototype); `--include TC01` or `--include severity-Critical` narrows the run.
Resource            calculator_test_case.resource
Variables           calculator_test_data.py

Suite Setup         Start Calculator Suite
Suite Teardown      Finish Calculator Suite
Test Template       Run Calculator Test Case
Test Teardown       Finish Calculator Test
Test Tags           calculator    build-${BUILD}


*** Variables ***
${BUILD}            0


*** Test Cases ***
TC01 Add [2, 3] int=No (CALC)
    [Documentation]    ${TC01}[technique]
    [Tags]    ${TC01}[type]    ${TC01}[category]    ${TC01}[operation]    severity-${TC01}[severity]    TC01
    ${TC01}

TC02 Add [-2, -3] int=No (CALC)
    [Documentation]    ${TC02}[technique]
    [Tags]    ${TC02}[type]    ${TC02}[category]    ${TC02}[operation]    severity-${TC02}[severity]    TC02
    ${TC02}

TC03 Add [-5, 3] int=No (CALC)
    [Documentation]    ${TC03}[technique]
    [Tags]    ${TC03}[type]    ${TC03}[category]    ${TC03}[operation]    severity-${TC03}[severity]    TC03
    ${TC03}

TC04 Add [0, 0] int=No (CALC)
    [Documentation]    ${TC04}[technique]
    [Tags]    ${TC04}[type]    ${TC04}[category]    ${TC04}[operation]    severity-${TC04}[severity]    TC04
    ${TC04}

TC05 Add [7, 0] int=No (CALC)
    [Documentation]    ${TC05}[technique]
    [Tags]    ${TC05}[type]    ${TC05}[category]    ${TC05}[operation]    severity-${TC05}[severity]    TC05
    ${TC05}

TC06 Add [1.5, 2.25] int=No (CALC)
    [Documentation]    ${TC06}[technique]
    [Tags]    ${TC06}[type]    ${TC06}[category]    ${TC06}[operation]    severity-${TC06}[severity]    TC06
    ${TC06}

TC07 Add [9999999999, 1] int=No (CALC)
    [Documentation]    ${TC07}[technique]
    [Tags]    ${TC07}[type]    ${TC07}[category]    ${TC07}[operation]    severity-${TC07}[severity]    TC07
    ${TC07}

TC08 Subtract [5, 3] int=No (CALC)
    [Documentation]    ${TC08}[technique]
    [Tags]    ${TC08}[type]    ${TC08}[category]    ${TC08}[operation]    severity-${TC08}[severity]    TC08
    ${TC08}

TC09 Subtract [3, 5] int=No (CALC)
    [Documentation]    ${TC09}[technique]
    [Tags]    ${TC09}[type]    ${TC09}[category]    ${TC09}[operation]    severity-${TC09}[severity]    TC09
    ${TC09}

TC10 Subtract [0, 5] int=No (CALC)
    [Documentation]    ${TC10}[technique]
    [Tags]    ${TC10}[type]    ${TC10}[category]    ${TC10}[operation]    severity-${TC10}[severity]    TC10
    ${TC10}

TC11 Subtract [-1.5, 2.5] int=No (CALC)
    [Documentation]    ${TC11}[technique]
    [Tags]    ${TC11}[type]    ${TC11}[category]    ${TC11}[operation]    severity-${TC11}[severity]    TC11
    ${TC11}

TC12 Subtract [4, 4] int=No (CALC)
    [Documentation]    ${TC12}[technique]
    [Tags]    ${TC12}[type]    ${TC12}[category]    ${TC12}[operation]    severity-${TC12}[severity]    TC12
    ${TC12}

TC13 Multiply [4, 3] int=No (CALC)
    [Documentation]    ${TC13}[technique]
    [Tags]    ${TC13}[type]    ${TC13}[category]    ${TC13}[operation]    severity-${TC13}[severity]    TC13
    ${TC13}

TC14 Multiply [-3, 4] int=No (CALC)
    [Documentation]    ${TC14}[technique]
    [Tags]    ${TC14}[type]    ${TC14}[category]    ${TC14}[operation]    severity-${TC14}[severity]    TC14
    ${TC14}

TC15 Multiply [-3, -4] int=No (CALC)
    [Documentation]    ${TC15}[technique]
    [Tags]    ${TC15}[type]    ${TC15}[category]    ${TC15}[operation]    severity-${TC15}[severity]    TC15
    ${TC15}

TC16 Multiply [0, 5] int=No (CALC)
    [Documentation]    ${TC16}[technique]
    [Tags]    ${TC16}[type]    ${TC16}[category]    ${TC16}[operation]    severity-${TC16}[severity]    TC16
    ${TC16}

TC17 Multiply [1.5, 2] int=No (CALC)
    [Documentation]    ${TC17}[technique]
    [Tags]    ${TC17}[type]    ${TC17}[category]    ${TC17}[operation]    severity-${TC17}[severity]    TC17
    ${TC17}

TC18 Multiply [99999, 99999] int=No (CALC)
    [Documentation]    ${TC18}[technique]
    [Tags]    ${TC18}[type]    ${TC18}[category]    ${TC18}[operation]    severity-${TC18}[severity]    TC18
    ${TC18}

TC19 Multiply [0.5, 0.5] int=No (CALC)
    [Documentation]    ${TC19}[technique]
    [Tags]    ${TC19}[type]    ${TC19}[category]    ${TC19}[operation]    severity-${TC19}[severity]    TC19
    ${TC19}

TC20 Divide [10, 4] int=No (CALC)
    [Documentation]    ${TC20}[technique]
    [Tags]    ${TC20}[type]    ${TC20}[category]    ${TC20}[operation]    severity-${TC20}[severity]    TC20
    ${TC20}

TC21 Divide [4, 10] int=No (CALC)
    [Documentation]    ${TC21}[technique]
    [Tags]    ${TC21}[type]    ${TC21}[category]    ${TC21}[operation]    severity-${TC21}[severity]    TC21
    ${TC21}

TC22 Divide [0, 5] int=No (CALC)
    [Documentation]    ${TC22}[technique]
    [Tags]    ${TC22}[type]    ${TC22}[category]    ${TC22}[operation]    severity-${TC22}[severity]    TC22
    ${TC22}

TC23 Divide [-7, 2] int=No (CALC)
    [Documentation]    ${TC23}[technique]
    [Tags]    ${TC23}[type]    ${TC23}[category]    ${TC23}[operation]    severity-${TC23}[severity]    TC23
    ${TC23}

TC24 Divide [8, 2] int=No (CALC)
    [Documentation]    ${TC24}[technique]
    [Tags]    ${TC24}[type]    ${TC24}[category]    ${TC24}[operation]    severity-${TC24}[severity]    TC24
    ${TC24}

TC25 Divide [5, 0] int=No (CALC)
    [Documentation]    ${TC25}[technique]
    [Tags]    ${TC25}[type]    ${TC25}[category]    ${TC25}[operation]    severity-${TC25}[severity]    TC25
    ${TC25}

TC26 Divide [0, 0] int=No (CALC)
    [Documentation]    ${TC26}[technique]
    [Tags]    ${TC26}[type]    ${TC26}[category]    ${TC26}[operation]    severity-${TC26}[severity]    TC26
    ${TC26}

TC27 Concatenate [abc, def] int=No (CALC)
    [Documentation]    ${TC27}[technique]
    [Tags]    ${TC27}[type]    ${TC27}[category]    ${TC27}[operation]    severity-${TC27}[severity]    TC27
    ${TC27}

TC28 Concatenate [1, 2] int=No (CALC)
    [Documentation]    ${TC28}[technique]
    [Tags]    ${TC28}[type]    ${TC28}[category]    ${TC28}[operation]    severity-${TC28}[severity]    TC28
    ${TC28}

TC29 Concatenate [-1, 0.5] int=No (CALC)
    [Documentation]    ${TC29}[technique]
    [Tags]    ${TC29}[type]    ${TC29}[category]    ${TC29}[operation]    severity-${TC29}[severity]    TC29
    ${TC29}

TC30 Concatenate [(empty), abc] int=No (CALC)
    [Documentation]    ${TC30}[technique]
    [Tags]    ${TC30}[type]    ${TC30}[category]    ${TC30}[operation]    severity-${TC30}[severity]    TC30
    ${TC30}

TC31 Concatenate [@#$, 12] int=No (CALC)
    [Documentation]    ${TC31}[technique]
    [Tags]    ${TC31}[type]    ${TC31}[category]    ${TC31}[operation]    severity-${TC31}[severity]    TC31
    ${TC31}

TC32 Add [1.5, 2.25] int=Yes (CALC)
    [Documentation]    ${TC32}[technique]
    [Tags]    ${TC32}[type]    ${TC32}[category]    ${TC32}[operation]    severity-${TC32}[severity]    TC32
    ${TC32}

TC33 Add [1.7, 1.2] int=Yes (CALC)
    [Documentation]    ${TC33}[technique]
    [Tags]    ${TC33}[type]    ${TC33}[category]    ${TC33}[operation]    severity-${TC33}[severity]    TC33
    ${TC33}

TC34 Add [-1.5, -1.5] int=Yes (CALC)
    [Documentation]    ${TC34}[technique]
    [Tags]    ${TC34}[type]    ${TC34}[category]    ${TC34}[operation]    severity-${TC34}[severity]    TC34
    ${TC34}

TC35 Subtract [1.5, 4] int=Yes (CALC)
    [Documentation]    ${TC35}[technique]
    [Tags]    ${TC35}[type]    ${TC35}[category]    ${TC35}[operation]    severity-${TC35}[severity]    TC35
    ${TC35}

TC36 Multiply [1.5, 2] int=Yes (CALC)
    [Documentation]    ${TC36}[technique]
    [Tags]    ${TC36}[type]    ${TC36}[category]    ${TC36}[operation]    severity-${TC36}[severity]    TC36
    ${TC36}

TC37 Divide [10, 4] int=Yes (CALC)
    [Documentation]    ${TC37}[technique]
    [Tags]    ${TC37}[type]    ${TC37}[category]    ${TC37}[operation]    severity-${TC37}[severity]    TC37
    ${TC37}

TC38 Divide [-7, 2] int=Yes (CALC)
    [Documentation]    ${TC38}[technique]
    [Tags]    ${TC38}[type]    ${TC38}[category]    ${TC38}[operation]    severity-${TC38}[severity]    TC38
    ${TC38}

TC39 Divide [7, 2] int=Yes (CALC)
    [Documentation]    ${TC39}[technique]
    [Tags]    ${TC39}[type]    ${TC39}[category]    ${TC39}[operation]    severity-${TC39}[severity]    TC39
    ${TC39}

TC40 Add [0.5, 0.4] int=Yes (CALC)
    [Documentation]    ${TC40}[technique]
    [Tags]    ${TC40}[type]    ${TC40}[category]    ${TC40}[operation]    severity-${TC40}[severity]    TC40
    ${TC40}

TC41 Subtract [5, 3] int=Yes (CALC)
    [Documentation]    ${TC41}[technique]
    [Tags]    ${TC41}[type]    ${TC41}[category]    ${TC41}[operation]    severity-${TC41}[severity]    TC41
    ${TC41}

TC42 Divide [5, 0] int=Yes (CALC)
    [Documentation]    ${TC42}[technique]
    [Tags]    ${TC42}[type]    ${TC42}[category]    ${TC42}[operation]    severity-${TC42}[severity]    TC42
    ${TC42}

TC43 Add [abc, 1] int=No (CALC)
    [Documentation]    ${TC43}[technique]
    [Tags]    ${TC43}[type]    ${TC43}[category]    ${TC43}[operation]    severity-${TC43}[severity]    TC43
    ${TC43}

TC44 Add [1, abc] int=No (CALC)
    [Documentation]    ${TC44}[technique]
    [Tags]    ${TC44}[type]    ${TC44}[category]    ${TC44}[operation]    severity-${TC44}[severity]    TC44
    ${TC44}

TC45 Add [abc, xyz] int=No (CALC)
    [Documentation]    ${TC45}[technique]
    [Tags]    ${TC45}[type]    ${TC45}[category]    ${TC45}[operation]    severity-${TC45}[severity]    TC45
    ${TC45}

TC46 Subtract [1,5, 2] int=No (CALC)
    [Documentation]    ${TC46}[technique]
    [Tags]    ${TC46}[type]    ${TC46}[category]    ${TC46}[operation]    severity-${TC46}[severity]    TC46
    ${TC46}

TC47 Multiply [3, @#] int=No (CALC)
    [Documentation]    ${TC47}[technique]
    [Tags]    ${TC47}[type]    ${TC47}[category]    ${TC47}[operation]    severity-${TC47}[severity]    TC47
    ${TC47}

TC48 Divide [abc, 2] int=No (CALC)
    [Documentation]    ${TC48}[technique]
    [Tags]    ${TC48}[type]    ${TC48}[category]    ${TC48}[operation]    severity-${TC48}[severity]    TC48
    ${TC48}

TC49 Add [--5, 1] int=No (CALC)
    [Documentation]    ${TC49}[technique]
    [Tags]    ${TC49}[type]    ${TC49}[category]    ${TC49}[operation]    severity-${TC49}[severity]    TC49
    ${TC49}

TC50 Subtract [1, 1 2] int=No (CALC)
    [Documentation]    ${TC50}[technique]
    [Tags]    ${TC50}[type]    ${TC50}[category]    ${TC50}[operation]    severity-${TC50}[severity]    TC50
    ${TC50}

TC51 Add [(empty), 5] int=No (CALC)
    [Documentation]    ${TC51}[technique]
    [Tags]    ${TC51}[type]    ${TC51}[category]    ${TC51}[operation]    severity-${TC51}[severity]    TC51
    ${TC51}

TC52 Add [(empty), (empty)] int=No (CALC)
    [Documentation]    ${TC52}[technique]
    [Tags]    ${TC52}[type]    ${TC52}[category]    ${TC52}[operation]    severity-${TC52}[severity]    TC52
    ${TC52}

TC53 Add [2, 3] int=No (CLEAR)
    [Documentation]    ${TC53}[technique]
    [Tags]    ${TC53}[type]    ${TC53}[category]    ${TC53}[operation]    severity-${TC53}[severity]    TC53
    ${TC53}

TC54 Add [1.5, 2.25] int=Yes (CLEAR)
    [Documentation]    ${TC54}[technique]
    [Tags]    ${TC54}[type]    ${TC54}[category]    ${TC54}[operation]    severity-${TC54}[severity]    TC54
    ${TC54}

TC55 Add [abc, 1] int=No (CLEAR)
    [Documentation]    ${TC55}[technique]
    [Tags]    ${TC55}[type]    ${TC55}[category]    ${TC55}[operation]    severity-${TC55}[severity]    TC55
    ${TC55}

TC56 Concatenate [abc, def] int=No (CLEAR)
    [Documentation]    ${TC56}[technique]
    [Tags]    ${TC56}[type]    ${TC56}[category]    ${TC56}[operation]    severity-${TC56}[severity]    TC56
    ${TC56}

TC57 Divide [10, 4] int=No (CLEAR)
    [Documentation]    ${TC57}[technique]
    [Tags]    ${TC57}[type]    ${TC57}[category]    ${TC57}[operation]    severity-${TC57}[severity]    TC57
    ${TC57}

TC58 Add [1.5, 2.25] int=No (INT_TOGGLE)
    [Documentation]    ${TC58}[technique]
    [Tags]    ${TC58}[type]    ${TC58}[category]    ${TC58}[operation]    severity-${TC58}[severity]    TC58
    ${TC58}

TC59 Divide [-7, 2] int=No (INT_TOGGLE)
    [Documentation]    ${TC59}[technique]
    [Tags]    ${TC59}[type]    ${TC59}[category]    ${TC59}[operation]    severity-${TC59}[severity]    TC59
    ${TC59}

TC60 Multiply [4, 3] int=No (INT_TOGGLE)
    [Documentation]    ${TC60}[technique]
    [Tags]    ${TC60}[type]    ${TC60}[category]    ${TC60}[operation]    severity-${TC60}[severity]    TC60
    ${TC60}

TC61 Concatenate [(empty), (empty)] int=No (INT_STATE)
    [Documentation]    ${TC61}[technique]
    [Tags]    ${TC61}[type]    ${TC61}[category]    ${TC61}[operation]    severity-${TC61}[severity]    TC61
    ${TC61}

TC62 Add [(empty), (empty)] int=No (INT_STATE)
    [Documentation]    ${TC62}[technique]
    [Tags]    ${TC62}[type]    ${TC62}[category]    ${TC62}[operation]    severity-${TC62}[severity]    TC62
    ${TC62}

TC63 Divide [(empty), (empty)] int=No (INT_STATE)
    [Documentation]    ${TC63}[technique]
    [Tags]    ${TC63}[type]    ${TC63}[category]    ${TC63}[operation]    severity-${TC63}[severity]    TC63
    ${TC63}

TC64 Add [(empty), (empty)] int=No (CLEAR_STATE)
    [Documentation]    ${TC64}[technique]
    [Tags]    ${TC64}[type]    ${TC64}[category]    ${TC64}[operation]    severity-${TC64}[severity]    TC64
    ${TC64}
