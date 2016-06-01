*** Settings ***
Documentation     A resource fil with reusable keywords and variables.
...
...               The system specific keywords created here form our own
...               domain specific language. They utilize keywords provided
...               by the imported Selenium2Library.
Library           Selenium2Library
Library           ImageLibrary.py
Library           XML
Library           HttpLibrary.HTTP
Resource          ../../environment.robot

*** Variables ***
${DELAY}          0
${VALID USER}     admin
${VALID PASSWORD}    geoserver
${LOGIN URL}      http://${SERVER}/geoserver/web
${WELCOME URL}    http://${SERVER}/geoserver/web/

*** Keywords ***
Open Browser To GeoServer
    Open Browser    ${LOGIN URL}    ${BROWSER}  None    ${REMOTE_URL}
    Maximize Browser Window
    Set Selenium Speed      0.2
    Title Should Be    GeoServer: Welcome

Input Username
    [Arguments]    ${username}
    Input Text    username    ${username}

Input Password
    [Arguments]    ${password}
    Click Element    password
    Input Text    password    ${password}

Submit Credentials
    Click Button    Login

Welcome Page Should Be Open
    Page Should Contain     Logged in as admin

WMS Get Map
     [arguments]   ${host}=${SERVER}   ${layernames}=    ${srs}=EPSG:4326     ${workspace}=    ${mimeType}=image/png     ${bbox}=-180.0,-90,180,90    ${width}=768    ${height}=370    ${styles}=
     ${url}=    Catenate    SEPARATOR=    /geoserver/  ${workspace}    /wms?service=WMS&version=1.1.0&request=GetMap&layers=    ${layernames}    &styles=    ${styles}    &bbox=    ${bbox}    &width=${width}&height=${height}&srs=   ${srs}    &format=    ${mimeType}
     Log    ${url}
     Create Http Context    ${host}    http
     HttpLibrary.HTTP.Get    ${url}
     Response Status Code Should Equal     200
     Response Header Should Not Equal    content-type    application/vnd.ogc.se_xml; charset=UTF-8
     Response Header Should Not Equal    content-type    application/vnd.ogc.se_xml;charset=UTF-8
     ${body}    Get Response Body
     [return]     ${body}

Verify Get Map Request
    [arguments]     ${body}
     ${root}    ParseXML    ${body}
     Log    ${root}
     XML.Element Text Should Match     ${root}     * Could not find layer *
