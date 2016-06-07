*** Settings ***
Documentation     adding data to a new workspace in composer
...
TestSetup         Login To Composer
TestTeardown      Close Browser
Suite Teardown    Delete Workspace      ws=testws
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

Add Data To New Workspace
    Open Workspace  testws
    Click Element   xpath=//a[contains(.,"Add Data")]
    Wait Until Page Contains    Add Files
    ${oldLogLevel}    Set Log Level    WARN
    Choose File     xpath=//input[@type='file']     ${TEST DATA}world.zip
    Set Log Level   ${oldLogLevel}
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
