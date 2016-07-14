*** Settings ***
Documentation     A resource file with reusable keywords and variables,
...               which form the base of the dashboard tests.
...
Library           Selenium2Library  timeout=10
Resource          ../../environment.robot

*** Variables ***
${DASHBOARD URL}   http://${SERVER}/dashboard

*** Keywords ***
Open Browser To Dashboard
    Open Browser    ${DASHBOARD URL}    ${BROWSER}    None    ${REMOTE_URL}
    Maximize Browser Window
    Set Selenium Speed      0.2
    Title Should Be    Boundless Suite Dashboard

Go To Dashboard
    Go To    ${DASHBOARD URL}
    Title Should Be    Boundless Suite Dashboard

Verify Doc Link
    [arguments]     ${link}  ${title}
    Click Element    ${link}
    Wait Until Page Contains    ${title}
    Page Should Contain     ${title}