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
${REST URL}       http://${SERVER}/geoserver/rest

*** Keywords ***
Open Browser To GeoServer
    #Open Browser    ${LOGIN URL}    ${BROWSER}  None    ${REMOTE_URL}
    Open Browser    ${LOGIN URL}    ${BROWSER}
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

Submit Geoserver Credentials
    Input Username  ${VALID USER}
    Input Password  ${VALID PASSWORD}
    Click Button    Login

Welcome Page Should Be Open
    Wait Until Page Contains    Logged in as admin
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

Publish Layer
    [arguments]   ${dsname}   ${varname}    ${srs}=EPSG:4326
      Click Element     //span[text()='Layers']/..
      Click Element     //a[text()='Add a new layer']
      Select From List By Label   //select    opengeo:${dsname}
      Wait Until Page Contains      Publish
      Click Element      //span[text()='${varname}']/../..//a
      Wait Until Page Contains     Edit Layer

      Put Text In Labelled Input     Declared SRS     ${srs}
      Click Element   //a[text()="Save"]

Scroll Into View
        [arguments]  ${docSelector}
        Execute Javascript   document.querySelector("${docSelector}").scrollIntoView(true)

Put Text In Labelled Input
      [arguments]    ${label}     ${text}
      ${passed}    ${elem}       Run Keyword and Ignore Error    Get WebElement      //*[(self::span or self::label) and text()='${label}']/..//input
      ${passed2}    ${elem2}     Run Keyword and Ignore Error    Get WebElement      //*[(self::span or self::label) and text()='${label}']/../..//input
      ${elemFinal}=    Set Variable If       '${passed}'=='PASS'      ${elem}    ${elem2}
      Input Text         ${elemFinal}      ${text}

#wait for DB connection to drop
Delete Datastore
    [arguments]        ${dsname}
    Go To                ${LOGIN URL}
    Click Element     //span[text()='Stores']/..
    Select Checkbox    //span[text()='${dsname}']/ancestor::tr/th/input
    Wait Until Page Contains Element     //a[text()='Remove selected Stores']
    Click Element        //a[text()='Remove selected Stores']
    Click Element    //a[text()='OK']
    Sleep    1 seconds
