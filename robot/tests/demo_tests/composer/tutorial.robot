*** Settings ***
Documentation     follow the composer tutorial from the suite documentation
...
TestSetup         Login To Composer
TestTeardown      Close Browser
Resource          resource.robot

*** Variables ***
${X_PLACES}     xpath=//div[@class='layer-detail' and contains(.,"ne_10m_populated_places")]//button[contains(.,"Settings")]
${X_ROADS}      xpath=//div[@class='layer-detail' and contains(.,"ne_10m_roads")]//button[contains(.,"Settings")]
${X_COUNTRIES}  xpath=//div[@class='layer-detail' and contains(.,"ne_10m_admin_0_countries")]//button[contains(.,"Settings")]
${X_DEM}        xpath=//div[@class='layer-detail' and contains(.,"dem_large")]//button[contains(.,"Settings")]


*** Test Cases ***
Create New Workspace
    Assign Id To Element    css=span.txt    New
    Click Element    New
    Click Link    New Project Workspace
    Input Text    name=workspaceName    tutorial
    Click Button    Create Workspace
    Wait Until Page Contains    tutorial
    Page Should Contain    tutorial
    Close Browser

Add Data To New Workspace
    Open Workspace tutorial
    Wait Until Element Is Visible    xpath=//a[contains(.,"Add Data")]
    Click Element   xpath=//a[contains(.,"Add Data")]
    Wait Until Page Contains    Add Files
    Choose File     xpath=//input[@type='file']     ${TEST DATA}tutorial.zip
    Wait Until Element Is Visible    xpath=//button[text()='Upload']
    Click Element    xpath=//button[text()='Upload']
    Wait Until Page Contains    Next: Load
    Click Element    xpath=//button[contains(.,"Next")]
    Wait Until Page Contains    Available Layers
    Click Element    css=input.ngSelectionHeader
    Click Button    Import Selected Layers
    Wait Until Page Contains Element    css=div.bg-success
    Element Text Should Be    css=div.bg-success    4 layers imported.
    Click Button    Close

Edit Layer details
    Open Workspace tutorial
    Wait Until Element Is Visible    xpath=//a[contains(.,"Layers")]
    Click Element   xpath=//a[contains(.,"Layers")]
    Wait Until Page Contains    4 layers in current project.
    Wait Until Element Is Visible  ${X_PLACES}
    Click Element  ${X_PLACES}
    Input Text     name=layerName  places
    Input Text     name=title      Populated places
    Click Button   Update Layer Settings
    Wait Until Element Is Visible  ${X_ROADS}
    Click Element  ${X_ROADS}
    Input Text     name=layerName  roads
    Input Text     name=title      Roads
    Click Button   Update Layer Settings
    Wait Until Element Is Visible  ${X_COUNTRIES}
    Click Element  ${X_COUNTRIES}
    Input Text     name=layerName  countries
    Input Text     name=title      Countries
    Click Button   Update Layer Settings
    Wait Until Element Is Visible  ${X_DEM}
    Click Element  ${X_DEM}
    Input Text     name=layerName  dem
    Input Text     name=title      DEM
    Click Button   Update Layer Settings
    Element Should Be Visible  xpath=//div[@class='layer-detail' and contains(.,"Populated places")]
    Element Should Be Visible  xpath=//div[@class='layer-detail' and contains(.,"Roads")]
    Element Should Be Visible  xpath=//div[@class='layer-detail' and contains(.,"Countries")]
    Element Should Be Visible  xpath=//div[@class='layer-detail' and contains(.,"DEM")]

Create Map
    Open Workspace tutorial
    Wait Until Element Is Visible    xpath=//a[contains(.,"New Map")]
    Click Element   xpath=//a[contains(.,"New Map")]
    Wait Until Element Is Visible    name=mapName
    Input Text     name=mapName      tutmap
    Input Text     name=title        Tutorial Map
    Input Text     name=description  Composer / YSLD tutorial map
    Click Button   xpath=//button[contains(.,"Add Layers")]
    Click Button   xpath=//button[contains(.,"Add Layers")]
    Click Element  css=input.ngSelectionHeader
    Click Button   Create Map with Selected
    Page Should Contain    Rendering map
    Page Should Contain    roads
    Page Should Contain    symbolizers

Delete Workspace
    Go To    ${COMPOSER URL}/#/workspaces/list
    Wait Until Element Is Visible  xpath=//button[contains(.,"Delete")]
    Click Button    Delete
    Click Element    //button[@class='btn btn-danger btn-sm']
