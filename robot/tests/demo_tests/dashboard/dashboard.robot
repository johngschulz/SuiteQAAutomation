*** Settings ***
Documentation     Dashboard smoke test
...
TestSetup         Open Browser To Dashboard
TestTeardown      Close Browser
Resource          resource.robot

*** Test Cases ***
Doc Link
    Click Element    xpath=//*[@id="_documentationlink"]
    Select Window    Boundless Suite User Manual — Boundless Suite 4.9.x User Manual
    Wait Until Page Contains    Boundless Suite User Manual
    Page Should Contain     Boundless Suite User Manual
    Go To Dashboard

Composer Links
    Click Element    xpath=//div[@id="home"]/div[2]/div[1]/div/div/div[1]
    Title Should Be  Composer
    Go To Dashboard
    Verify Doc Link  xpath=//div[@id="home"]/div[2]/div[1]/div/div/div[2]  Making maps with Composer
    Go To Dashboard

WPS Builder Links
    Click Element    xpath=//div[@id="home"]/div[2]/div[2]/div/div/div[1]
    Wait Until Page Contains    Builder
    Title Should Be  WPS Process Builder
    Go To Dashboard
    Verify Doc Link  xpath=//div[@id="home"]/div[2]/div[2]/div/div/div[2]  Executing processes using WPS Builder
    Go To Dashboard

PostGIS Links
    Verify Doc Link  xpath=//div[@id="home"]/div[3]/div[1]/div[2]/a  Working with your data
    Go To Dashboard

GeoServer Links
    Click Element    xpath=//div[@id="home"]/div[3]/div[2]/div[2]/div/div[1]
    Wait Until Page Contains    GeoServer
    Title Should Be  GeoServer: Welcome
    Go To Dashboard
    Verify Doc Link  xpath=//div[@id="home"]/div[3]/div[2]/div[2]/div/div[2]  Using the web administration interface
    Go To Dashboard

GeoWebCache Links
    Click Element    xpath=//div[@id="home"]/div[3]/div[3]/div[2]/div/div[1]
    Wait Until Page Contains    GeoWebCache
    Title Should Be  GWC Home
    Go To Dashboard
    Verify Doc Link  xpath=//div[@id="home"]/div[3]/div[3]/div[2]/div/div[2]  GeoWebCache
    Go To Dashboard

Web SDK Links
    Click Element    xpath=//div[@id="home"]/div[4]/div[2]/div[2]/div/div[1]
    Wait Until Page Contains    Layer
    Title Should Be  WebSDK QuickView
    Go To Dashboard
    Verify Doc Link  xpath=//div[@id="home"]/div[4]/div[2]/div[2]/div/div[2]  Creating web apps with Web SDK
    Go To Dashboard
