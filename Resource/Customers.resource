*** Settings ***
Library    SeleniumLibrary
Library    DateTime
Variables     ../Variables/customers.py
Library    ../Libraries/CommonLibrary.py
Resource    ../Resource/App.resource


*** Keywords ***

Open Create Modal
    # [Arguments]    
    Click Element    //a[text()="Create"]
    Wait Until Element Is Visible    //h6[descendant::span[text()="Create Customer"]]

Add A Customer
    [Arguments]    ${user}
    Navigate    Customers 
    Open Create Modal
    Input Text    ${cust_txt_fname}    ${user['first_name']}
    Input Text    ${cust_txt_lname}    ${user['last_name']}
    Input Text    ${cust_txt_email}    ${user['email']}
    Input Text    ${cust_txt_bday}    ${user['birthday']}
    Input Text    ${cust_txt_address}    ${user['address']['street']} ${user['address']['suite']}
    Input Text    ${cust_txt_city}    ${user['address']['city']}
    Input Text    ${cust_txt_stateAbbr}    ${user['address']['stateAbbr']}
    Input Text    ${cust_txt_zipcode}    ${user['address']['zipcode']}
    Input Text    ${cust_txt_password}    ${user['password']}
    Input Text    ${cust_txt_confirm_password}    ${user['password']}

    Click Button    ${cust_btn_save}
    Wait Until Element Is Visible    //div[text()="Customer created"]

    Navigate    Customers
    # Wait Until Element Is Visible    //tr[.//div[contains(., ${user['first_name']}) and contains(., ${user['last_name']})]]
    # Click Element    //tr[.//div[contains(., ${user['first_name']}) and contains(., ${user['last_name']})]]
    # ${status}    Run Keyword And Return Status    Element Should Be Visible    //h6[//span[contains(., ${user['first_name']}) and contains(., ${user['last_name']})]]
    # RETURN   ${status}

Format Birthday
    [Arguments]    ${date}
    ${formatted}    Evaluate    "/".join("${date}".split("-")[1:]+["${date}".split("-")[0]])
    RETURN    ${formatted}


Verify Customer Identity Details
    [Arguments]    ${user}
    Navigate    Customers
    # Wait Until Element Is Visible    (//tbody//tr)[1]//td[contains(@class, "column-last_name")]
    # Click Element    (//tbody//tr)[1]//td[contains(@class, "column-last_name")]
    Wait Until Element Is Visible    //tr[.//div[contains(., ${user['first_name']}) and contains(., ${user['last_name']})]]
    Click Element    //tr[.//div[contains(., ${user['first_name']}) and contains(., ${user['last_name']})]]
    #//tr[descendant::div[contains(., "Bette") and contains(., "Mante")]] - Nilagay ko for checking
    Wait Until Element Is Visible    ${cust_txt_fname}

    ${locators}    Create List    ${cust_txt_fname}    ${cust_txt_lname}    ${cust_txt_email}    ${cust_txt_bday}    ${cust_txt_address}    ${cust_txt_city}    ${cust_txt_stateAbbr}
    ${expected_values}    Create List    ${user["first_name"]}    ${user["last_name"]}    ${user["email"]}    ${user['birthday']}    ${user["address"]["street"]} ${user["address"]["suite"]}    ${user["address"]["city"]}    ${user["address"]["stateAbbr"]}    ${user["address"]["zipcode"]}    ${user["password"]}    ${user["password"]}
    
    FOR    ${i}    ${locator}    IN ENUMERATE    @{locators}
        Mouse Over    ${locator}
        ${value_text}    Get Value    ${locator}
        IF    '${locator}'=='${cust_txt_bday}'
            ${value_text}    Format Birthday    ${value_text}
            # ${value_text}    Convert Date   ${value_text}    result_format=%m/%d/%Y
            # Should Be Equal   ${expected_values[${i}]}    ${value_text}
        END
        Should Be Equal As Strings    ${expected_values[${i}]}    ${value_text}
        
    END
    

Get Customer Row
    [Arguments]    ${user}
    Navigate    Customers
    ${web_elems}    Get WebElements    //tbody//tr
    FOR    ${i}    ${elem}    IN ENUMERATE    @{web_elems}
        ${name}    Get Text    ((//tbody//tr)[${i+1}]//td)[2]
        ${name}    Clean Text    ${name}
        Log To Console    ${name}
        Return From Keyword If    "${user['first_name']} ${user['last_name']}"=="${name}"    ${i+1}
    END

    RETURN    None
    
Clean Text
    [Arguments]    ${text}
    IF    "\\n" in """${text}"""
        ${text}    Evaluate    """${text}""".replace("\\n","")[1:]
    END
    Return From Keyword    ${text}
    

Verify If Customer Is Added In The Table
    [Arguments]    ${user}
    ${user_row}    Get Customer Row    ${user}
    Should Not Be Equal As Strings    None    ${user_row}


Add Multiple Customers
    [Arguments]    ${num}
    FOR    ${i}    IN RANGE    0    ${num}
        Add A Customer    ${USERS}[${i}]
        Verify If Customer Is Added In The Table    ${USERS[${i}]}
        Verify Customer Identity Details    ${USERS}[${i}]
        Sleep    3s
    END
    Navigate    Customers


Update A Customer
    [Arguments]    ${user}    ${index}
    Navigate    Customers
    # ${user_row}    Get Customer Row    ${user}
    # Wait Until Element Is Visible    //tr[${user_row}]//td[contains(text(), "Edit")]
    # Click Element    //tr[${user_row}]//td[contains(text(), "Edit")]
    # Wait Until Element Is Visible    //tr[.//div[contains(., ${user['first_name']}) and contains(., ${user['last_name']})]]
    # Click Element    //tr[.//div[contains(., ${user['first_name']}) and contains(., ${user['last_name']})]]
    Click Element    (//tbody//tr)[${index+1}]
    Wait Until Element Is Visible    ${cust_txt_fname}
    
    # Clear and input new details
    Press Keys   ${cust_txt_fname}    CTRL+a    BACKSPACE
    Input Text    ${cust_txt_fname}    ${user['first_name']}
    Press Keys   ${cust_txt_lname}    CTRL+a    BACKSPACE
    Input Text    ${cust_txt_lname}    ${user['last_name']}
    Press Keys   ${cust_txt_email}    CTRL+a    BACKSPACE
    Input Text    ${cust_txt_email}    ${user['email']}
    Input Text    ${cust_txt_bday}    ${user['birthday']}
    Input Text    ${cust_txt_address}    ${user['address']['street']} ${user['address']['suite']}
    Input Text    ${cust_txt_city}    ${user['address']['city']}
    Input Text    ${cust_txt_stateAbbr}    ${user['address']['stateAbbr']}
    Input Text    ${cust_txt_zipcode}    ${user['address']['zipcode']}
    Input Text    ${cust_txt_password}    ${user['password']}
    Input Text    ${cust_txt_confirm_password}    ${user['password']}

    Click Button    ${cust_btn_save}
    Wait Until Element Is Visible    //div[text()="Customer updated"]
    Navigate    Customers
    Wait Until Element Is Visible    //tr[.//div[contains(., ${user['first_name']}) and contains(., ${user['last_name']})]]

Update Multiple Customers
    [Arguments]    ${num_from}    ${num_to}
    FOR    ${i}    IN RANGE    ${${num_from}-${1}}    ${${num_to}-${1}}
        Update A Customer    ${USERS[${i}]}    ${i}
    END
    Sleep    3sc

Log Table Data
    Navigate    Customers
    ${web_elems}    Get WebElements    //tbody//tr
    FOR    ${i}    ${elem}    IN ENUMERATE    @{web_elems}
        ${name}    Get Text    ((//tbody//tr)[${i+1}]//td)[2]
        ${name}    Clean Text    ${name}
        ${last_seen}    Get Text    ((//tbody//tr)[${i+1}]//td)[3]
        ${orders}    Get Text    ((//tbody//tr)[${i+1}]//td)[4]
        ${total_spent}    Get Text    ((//tbody//tr)[${i+1}]//td)[5]
        ${news}    Get Text    ((//tbody//tr)[${i+1}]//td)[6]
        ${segments}    Get Text    ((//tbody//tr)[${i+1}]//td)[7]

        # Format news and segments
        ${news_display}    Evaluate    "Yes" if '${news}' == 'True' else "No"
        # ${segments_list}    Split String    ${segments}    ","
        
        # Log in required format
        Log to Console     ====== User ${i+1} ======
        Log to Console     Name: ${name}
        Log to Console     Last seen: ${last_seen}
        Log to Console     Orders: ${orders}
        Log to Console     Total spent: ${total_spent}
        Log to Console     Latest purchase: ${last_seen}
        Log to Console     News: ${news_display}
        # Log to Console      Segments: ${segments_list}
        Log to Console      ========
    END
    
Analyze User Spending
    Navigate    Customers
    ${web_elems}    Get WebElements    //tbody//tr
    ${total_spending}    Set Variable    0
    ${spending_data}    Create List    # Initialize an empty list to store the customer data
    
    # Display users with spending > 0
    ${user_count}    Set Variable    1
    FOR    ${i}    ${elem}    IN ENUMERATE    @{web_elems}
        ${name}    Get Text    ((//tbody//tr)[${i+1}]//td)[2]
        ${total_spent}    Get Text    ((//tbody//tr)[${i+1}]//td)[5]
        
        # Remove unwanted characters using Python's replace function
        ${total_spent}    Evaluate    "${total_spent}".replace('$', '').replace(',', '')
        
        # Convert to float for calculation
        ${total_spent}    Evaluate    float("${total_spent}")

        # Only consider users with spending > 0
        IF    ${total_spent} > 0
            # Log the user and their spending in the required format
            Log To Console   ${user_count}. ${name}: ${total_spent}
            
            # Accumulate the total spending
            ${total_spending}    Evaluate    ${total_spending} + ${total_spent}
            
            # Increase user count for the next user
            ${user_count}    Evaluate    ${user_count} + 1
        END
    END

    # Log the total spending sum
    Log To Console   ============================
    Log To Console   Total Customer Spending: $${total_spending}
    Log To Console   ============================
    
    # Validate if total spending meets the threshold
    ${threshold}    Set Variable    3500
    IF    ${total_spending} < ${threshold}
        Log To Console   FAIL: Total spending ($${total_spending}) is below minimum threshold ($${threshold})
        Fail    Test execution
    ELSE
        Log To Console   PASS: Total spending ($${total_spending}) meets minimum threshold ($${threshold})
    END