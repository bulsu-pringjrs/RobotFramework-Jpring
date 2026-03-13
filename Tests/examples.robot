*** Settings ***
Library    SeleniumLibrary
Library    Collections

*** Variables ***
# ${var_1}    ${10+1}

*** Test Cases ***
TEST-00001
    [Documentation]    Test Descriptions

    # Log To Console    Hello World!
    # Log    Hello World!
    # ${var_2}    Set Variable    3
    # ${sum}    Evaluate    ${var_1}+${var_2}
    # Log To Console    \n${sum}
    # Log    ${sum}

    # ${var_3}    Set Variable    ${var_1}+${var_2}
    # Log    ${var_3}

    # ${concat}    Evaluate    "${var_1}"+"${var_2}"
    # Log    ${concat}

    # Log To Console   ${var_1 + ${var_2}}

    # Basic Arithmetic Operations Examples
    ${var_1}    Set Variable    ${16}
    ${var_2}    Set Variable    8
    
    # Addition
    ${ans}    Evaluate    ${var_1}+${var_2}
    Log To Console    Addition
    Log To Console    ${ans}
    Log To Console    ${var_1+${var_2}} #You could also do this if result would not be needed any further

    # Subtraction
    ${ans}    Evaluate    ${var_1}-${var_2}
    Log To Console    Subtraction
    Log To Console    ${ans}
    Log To Console    ${var_1-${var_2}} #You could also do this if result would not be needed any further

    # Multiplication
    ${ans}    Evaluate    ${var_1}*${var_2}
    Log To Console    Multiplication
    Log To Console    ${ans}
    Log To Console    ${var_1*${var_2}} #You could also do this if result would not be needed any further

    # Division
    ${ans}    Evaluate    ${var_1}/${var_2}
    Log To Console    Division
    Log To Console    ${ans}
    Log To Console    ${var_1/${var_2}} #You could also do this if result would not be needed any further

TEST-00002
    [Documentation]    String Concatenation
    ${var_1}    Set Variable    ${16}
    ${var_2}    Set Variable    8
    ${var_3}    Set Variable    ABC
    ${var_4}    Set Variable    ABCZXC

    ${result}    Evaluate    "${var_1}" + " " + "${var_2}"
    ${result}    Set Variable    ${var_1} ${var_2}
    Log To Console    ${result}
    Log To Console    ${var_1} ${var_2} ${SPACE} ${var_3} ${var_4}

TEST-00003
    [Documentation]    List Examples
    ${list_1}    Create List    value_1    value_2    value_3
    Log To Console    ${list_1[0]}
    Log To Console    ${list_1}[1]
    Append To List    ${list_1}    value_4
    Log To Console    ${list_1}

TEST-00004
    [Documentation]    Dictionary Examples
    ${dict_1}    Create Dictionary    key_1=value_1    key_2=value_2    key_3=value_3
    Log To Console    ${dict_1}
    Log To Console    ${dict_1['key_1']}
    Set To Dictionary    ${dict_1}    key_1=value_3    key_4=value_4
    Log To Console    ${dict_1}

TEST-00005
    [Documentation]    For Loop Examples
    ${list_1}    Create List    value_1    value_2    value_3
    #@ = explode list
    FOR    ${element}    IN    @{list_1}
        Log To Console    ${element}
    END

    FOR    ${element}    IN    value_1    value_2    value_3
        Log To Console    ${element}
    END
    
    # for i in range(0,10)
    # FOR    ${i}    IN RANGE    START    END    opt.steps
    FOR    ${i}    IN RANGE    0    10    2
        Log To Console    ${i}
    END

    ${len}    Get Length    ${list_1}
    Log To Console    \n IN RANGE loop for lists
    FOR    ${i}    IN RANGE    0    ${len}
        Log To Console    ${list_1[${i}]}
    END

    FOR    ${index}    ${element}    IN ENUMERATE    @{list_1}
        Log To Console    ${index+1}. ${element}
    END

    Log To Console    \n FOR loop for dictionary
    ${dict_1}    Create Dictionary    key_1=value_1    key_2=value_2    key_3=value_3    key_4=value_4
    FOR    ${key}    IN    @{dict_1.keys()}
        Log To Console    ${dict_1["${key}"]}
    END

    # Nested For Loop
    FOR    ${i}    IN    1    2    3
        FOR    ${j}    IN    A    B    C
            Log To Console    ${i}:${j}
        END
    END

    FOR    ${i}    IN RANGE   1    4
        FOR    ${j}    IN    A    B    C
            Log To Console    ${i}:${j}
        END
    END 

TEST-00006
    [Documentation]    Assertions
    ${ans}    Evaluate    1+1
    Should Be Equal    ${ans}    2
    # Should Be Equal As Strings    ${ans}    2
    # Should Be Equal As Integers    ${ans}    2

TEST-00007
    [Documentation]    IF STATEMENTS

    ${ans}    Evaluate    1+1
    IF    ${ans}!=3
        Fail    Failed
    END
    
TEST-00008
    [Documentation]     OPEN BROWSER
    OPEN BROWSER    https://google.com  chrome
    Sleep   5s

*** Keywords ***
Log Console
    [Arguments]    ${text}    ${level}=INFO
    Log    ${text}
    Log To Console    \n${text}    