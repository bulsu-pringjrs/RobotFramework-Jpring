*** Settings ***
Library    SeleniumLibrary
Library    Collections
Variables   ../Variables/loginpage.py
Variables   ../Variables/common.py
Library    ../Libraries/CommonLibrary.py

***Variables***
${google}       https://marmelab.com/react-admin-demo
@{sales_submenu}    Orders    Invoices
@{catalog_submenu}    Posters    Categories
@{customers_submenu}    Customers    Segments
&{MENU}    Sales=${sales_submenu}    Catalog=${catalog_submenu}    Customers=${customers_submenu}
@{USERS}

*** Keywords ***
Launch Browser
    [Arguments]     ${login_txt_username}       ${url}=${google}
    Open Browser    ${url}    chrome    
    Maximize Browser Window
    Wait Until Element Is Visible    ${login_txt_username}    10s

Login
    [Arguments]     ${username}   ${passwd} 
    Input Text      ${login_txt_username}   ${username}
    Input Text      ${login_txt_password}   ${passwd}
    Capture Page Screenshot
    Click Button    ${login_btn_submit}
    Wait Until Element Is Visible    ${main_content}

Get Parent Menu
    [Arguments]    ${page}
    FOR    ${key}    IN    @{MENU.keys()}
        Return From Keyword If    "${page}" in ${MENU["${key}"]}    //li[descendant::p[text()="${key}"]]
    END
    RETURN    ${None}
Navigate
    [Arguments]    ${page}    
    ${sub_menu_loc}    Set Variable    //a[descendant::p[text()="${page}"]]
    ${status}    Run Keyword And Return Status    Element Should Be Visible    ${sub_menu_loc}  
    IF    not ${status}
        
        ${parent_menu}    Get Parent Menu    ${page}
        Click Element    ${parent_menu}
        Wait Until Element Is Visible    ${sub_menu_loc}
    END
    Sleep     2s
    Click Element    ${sub_menu_loc}
    Wait Until Element Is Visible    //h6[//span[text()="${page}"]]
    Run Keyword If    "${page}'=='Customers"
    ...    Sleep    2s