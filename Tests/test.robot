*** Settings ***
Resource    ../Resource/App.resource
Resource    ../Resource/Customers.resource


Suite Setup    Suite Init
Suite Teardown    Capture Page Screenshot


*** Test Cases ***

Test-1
    [Documentation]    add 5 users
    Add Multiple Customers    5

Test-2
    [Documentation]     Update Users
    Update Multiple Customers    6    10

    
Test-3
    [Documentation]    Log Table Data
    Log Table Data

Test-4
    [Documentation]    Analyze User Spending
    Analyze User Spending


*** Keywords ***
Suite Init
    Launch Browser      ${login_txt_username}   ${google}
    Login   demo     demo
    ${users}    get users
    Set Suite Variable    ${USERS}   ${users}
    Sleep    3s

