*** Settings ***
Documentation     A resource file with reusable keywords and variables,
...               which form the base of the composer tests. The default
...               Selenium time is set to 20 seconds to allow for uploads
...
Library           Selenium2Library  timeout=20
Resource          ../../environment.robot

*** Variables ***
${DELAY}          0
${VALID USER}     admin
${VALID PASSWORD}    geoserver
${COMPOSER URL}   http://${SERVER}/composer

*** Keywords ***
Is Angular Busy
    ${retval}=  Execute Async Javascript         var callback = arguments[arguments.length - 1]; var el = document.querySelector("[ng-app]"); callback(angular.element(el).injector().get('$http').pendingRequests.length)
    [return]    ${retval}

Assert Angular Not Busy
    ${retval}=   Is Angular Busy
    Run Keyword If  '${retval}' != '0'  Fail

Wait For Angular
    Wait Until Keyword Succeeds         30 second  1 second     Assert Angular Not Busy

Open Browser To Composer
    Open Browser    ${COMPOSER URL}    ${BROWSER}    None    ${REMOTE_URL}
    Maximize Browser Window
    Set Selenium Speed      0.2
    Title Should Be    Composer

Submit Composer Credentials
    Input Text      //input[@type='text']         admin
    Input Text      //input[@type='password']     geoserver
    Click Button    Login

Login to Composer
    Open Browser To Composer
    Wait Until Page Contains    Composer
    Submit Composer Credentials
    Wait Until Page Contains    admin
    Page Should Contain    admin

Create Workspace
    [arguments]     ${ws}
    Assign Id To Element    css=span.txt    New
    Click Element    New
    Click Link    New Project Workspace
    Input Text    name=workspaceName    ${ws}
    Click Button    Create Workspace
    Wait Until Page Contains    ${ws}
    Page Should Contain    ${ws}

Delete Workspace
    [arguments]     ${ws}
    Login to Composer
    Go To    ${COMPOSER URL}/#/workspaces/list
    Wait Until Element Is Visible  xpath=//div[@class='workspace-info' and contains(.,"${ws}")]//button[contains(.,"Delete")]
    Click Element    xpath=//div[@class='workspace-info' and contains(.,"${ws}")]//button[contains(.,"Delete")]
    Click Element    //button[@class='btn btn-danger btn-sm']
    Close Browser

Open Workspace
    [arguments]     ${ws}
    Go To    ${COMPOSER URL}/#/workspace/${ws}/maps/

Open Maps
    [arguments]     ${ws}
    Open Workspace  ws=${ws}
    Wait Until Element Is Visible    xpath=//ul[@class='nav nav-tabs']//a[contains(.,"Maps")]
    Click Element   xpath=//ul[@class='nav nav-tabs']//a[contains(.,"Layers")]

Open Layers
    [arguments]     ${ws}
    Open Workspace  ws=${ws}
    Wait Until Element Is Visible    xpath=//ul[@class='nav nav-tabs']//a[contains(.,"Layers")]
    Wait For Angular
    Click Element   xpath=//ul[@class='nav nav-tabs']//a[contains(.,"Layers")]

Open Data
    [arguments]     ${ws}
    Open Workspace  ws=${ws}
    Wait Until Element Is Visible    xpath=//ul[@class='nav nav-tabs']//a[contains(.,"Data")]
    Click Element   xpath=//ul[@class='nav nav-tabs']//a[contains(.,"Data")]

Open Map
    [arguments]     ${ws}  ${name}
    Open Workspace  ws=${ws}
    Input Text      xpath=//input[contains(@class,'grid-filter')]  ${name}
    Click Element                  xpath=//div[@class='map-wrapper' and contains(.,"${name}")]//img[@class='mapthumb']

Open Layer
    [arguments]     ${ws}  ${name}
    Open Layers  ws=${ws}
    Wait For Angular
    Input Text      xpath=//input[contains(@class,'grid-filter')]  ${name}
    Sleep     2 seconds
    Wait For Angular
    Click Element                  xpath=//div[@class='layer-info-section' and contains(.,"${name}")]//img[@class='layerthumb']
    Wait For Angular

Import File to Workspace
    [arguments]     ${ws}  ${file}  ${text}=1 layer imported.
    Open Workspace  ws=${ws}
    Wait Until Element Is Visible    xpath=//a[contains(.,"Add Data")]
    Wait For Angular
    Click Element   xpath=//a[contains(.,"Add Data")]
    Wait Until Page Contains    Add Files
    Choose File     xpath=//input[@type='file']     ${TEST DATA}${file}
    Wait Until Element Is Visible    xpath=//button[text()='Upload']
    Click Element    xpath=//button[text()='Upload']
    Wait Until Page Contains    Next: Load      30 seconds
    Click Element    xpath=//button[contains(.,"Next")]
    Wait Until Page Contains    Available Layers
    Click Element    css=input.ngSelectionHeader
    Click Button    Import Selected Layers
    Wait Until Page Contains Element    css=div.bg-success
    Element Text Should Be    css=div.bg-success    ${text}
    Click Button    Close

#Should already be in the desired workspace, on the layers tab.
Edit Layer
    [arguments]     ${old_name}  ${name}  ${title}
    Wait For Angular
    Click Element   xpath=//div[@class='layer-detail' and contains(.,"${old_name}")]//button[contains(.,"Settings")]
    Input Text      name=layerName  ${name}
    Input Text      name=title      ${title}
    Click Button    Update Layer Settings

#Should already be in the desired workspace. Uses all layers in the workspace to create the map.
Create Map
    [arguments]     ${name}  ${title}  ${desc}
    Wait Until Element Is Visible    xpath=//a[contains(.,"New Map")]
    Click Element   xpath=//a[contains(.,"New Map")]
    Wait Until Element Is Visible    name=mapName
    Input Text     name=mapName      ${name}
    Input Text     name=title        ${title}
    Input Text     name=description  ${desc}
    Click Button   xpath=//button[contains(.,"Add Layers")]
    Click Button   xpath=//button[contains(.,"Add Layers")]
    Click Element  css=input.ngSelectionHeader
    Click Button   Create Map with Selected

#Should be in the edit layer or edit map view
Set Style
    [arguments]     ${style}
    Execute Javascript  $("div.CodeMirror")[0].CodeMirror.setValue("${style}")
    Click Element   xpath=//span[text()="Save"]

