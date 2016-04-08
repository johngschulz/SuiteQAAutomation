*** Settings ***
Documentation     A resource file with reusable keywords and variables.
...
...               The system specific keywords created here form our own
...               domain specific language. They utilize keywords provided
...               by the imported Selenium2Library.
Library           Selenium2Library

*** Variables ***
${SERVER}         10.0.217.57:8080
${BROWSER}        firefox
${DELAY}          0
${VALID USER}     admin
${VALID PASSWORD}    geoserver
${COMPOSER URL}   http://${SERVER}/geoserver/composer
${TEST DATA}    C:\\test_data\\

*** Keywords ***
Open Browser To Composer
    Open Browser    ${COMPOSER URL}    ${BROWSER}    None    http://10.0.217.57:4444/wd/hub
    Maximize Browser Window
    Set Selenium Speed      0.2
    Title Should Be    Composer

Submit Credentials
    Input Text      //input[@type='text']         admin
    Input Text      //input[@type='password']     geoserver
    Click Button    Login

Login to Composer
    Open Browser To Composer
    Wait Until Page Contains    Composer
    Submit Credentials
    Wait Until Page Contains    admin
    Page Should Contain    admin

Open Workspace testws
    Go To    ${COMPOSER URL}/#/workspace/testws/maps/

Open Workspace tutorial
    Go To    ${COMPOSER URL}/#/workspace/tutorial/maps/
