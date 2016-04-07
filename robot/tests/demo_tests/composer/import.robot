*** Settings ***
Documentation     adding data to a new workspace in composer
...
TestSetup         Login To Composer
TestTeardown      Close Browser
Resource          resource.robot

*** Test Cases ***
Create New Workspace
    Assign Id To Element    css=span.txt    New
    Click Element    New
    Click Link    New Project Workspace
    Input Text    name=workspaceName    testws
    Click Button    Create Workspace
    Wait Until Page Contains    testws
    Page Should Contain    testws
    Close Browser

Add Data To New Workspace
    Open Workspace Layer Page
    Click Element   xpath=//a[contains(.,"Add Data")]
    Wait Until Page Contains    Add Files
    Choose File     xpath=//input[@type='file']     ${TEST DATA}world.zip
    Wait Until Element Is Visible    xpath=//button[text()='Upload']
    Click Element    xpath=//button[text()='Upload']
    Wait Until Page Contains    Next: Load
    Click Element    xpath=//button[contains(.,"Next")]
    Wait Until Page Contains    Available Layers
    Click Element    css=input.ngSelectionCheckbox
    Click Button    Import Selected Layers
    Wait Until Page Contains Element    css=div.bg-success
    Element Text Should Be    css=div.bg-success    1 layer imported.
    Click Button    Close

Delete Workspace
    Go To    ${COMPOSER URL}/#/workspaces/list
    Input Text    //input[@type='text']    testws
    Click Button    Delete
    Click Element    //button[@class='btn btn-danger btn-sm']
