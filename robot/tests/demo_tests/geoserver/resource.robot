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
Library           RequestsLibrary
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

Submit Geoserver Credentials
    Input Username  ${VALID USER}
    Input Password  ${VALID PASSWORD}
    Click Button    Login

Welcome Page Should Be Open
    Wait Until Page Contains    Logged in as admin
    Page Should Contain     Logged in as admin

WFS Get Feature By BBOX
    [arguments]    ${workspace}=    ${layername}=    ${bbox}=-180.0,-90,180,90    ${srs}=EPSG:4326    ${output}=GML3    ${host}=${SERVER}
    ${url}=    Catenate    SEPARATOR=    /geoserver/wfs?request=GetFeature&version=1.1.0&typeNames=    ${workspace}:  ${layername}    &bbox=    ${bbox}    ,   ${srs}   &outputFormat=${output}
    Log    ${url}
    Create Http Context    ${host}    http
    HttpLibrary.HTTP.Get    ${url}
    Response Status Code Should Equal     200
    ${body}    Get Response Body
    [return]     ${body}


WFS Get Feature By Property
    [arguments]    ${workspace}=    ${layername}=    ${property}=    ${host}=${SERVER}
    ${url}=    Catenate    SEPARATOR=    /geoserver/wfs?request=GetPropertyValue&typeNames=    ${workspace}:  ${layername}    &valueReference=   ${property}
    Log    ${url}
    Create Http Context    ${host}    http
    HttpLibrary.HTTP.Get    ${url}
    Response Status Code Should Equal     200
    ${body}    Get Response Body
    [return]     ${body}

WPS Request
    [arguments]   ${filedir}    ${filename}
    ${auth}=     Create List   admin    geoserver
    Create Session     RESTAPI    http://${SERVER}   auth=${auth}
    ${header}=   Create Dictionary   Content-type=xml

    ${fullFname}=  evaluate   r"${filedir}" +os.sep + r"${filename}"     os
    ${doubleEscapedFname}=  evaluate   r"${fullFname}".replace("\\\\","\\\\\\\\")
    &{files}=     evaluate  {"${filename}" : open("${doubleEscapedFname}","rb").read()}

    ${resp}=   Post Request    RESTAPI    /geoserver/wps/    files=${files}
    Log   ${resp}
    Log   ${resp.content}
    [Return]  ${resp.content}
    [Teardown]   Delete All Sessions

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

Get Feature Info
    [arguments]   ${bbox}   ${qlayer}   ${layers}   ${srs}=EPSG:4326
    ${auth}=     Create List   admin    geoserver
    Create Session     RESTAPI    http://${SERVER}   auth=${auth}
    &{params}=   Create Dictionary   SERVICE=WMS    VERSION=1.1.1   REQUEST=GetFeatureInfo   QUERY_LAYERS=${qlayer}  LAYERS=${layers}   INFO_FORMAT=text/html   FEATURE_COUNT=50   X=50  Y=50   SRS=${srs}   WIDTH=101   HEIGHT=101  BBOX=${bbox}
    ${resp}=   GET Request    RESTAPI    /geoserver/wms   params=${params}
    Log   ${resp.content}
    [Return]  ${resp.content}
    [Teardown]   Delete All Sessions

Publish Layer
    [arguments]   ${dsname}   ${varname}    ${srs}=EPSG:4326
      Click Element     //span[text()='Layers']/..
      Click Element     //a[text()='Add a new layer']
      Select From List By Label   //select    opengeo:${dsname}
      Wait Until Page Contains      Publish
      Click Element      //span[text()='${varname}']/../..//a/span[text()='Publish']
      Wait Until Page Contains     Edit Layer

      Put Text In Labelled Input     Declared SRS     ${srs}
      Click Element    //a[text()="Compute from native bounds"]
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

Create Datastore
    [arguments]    ${connection}    ${DStype}   ${DSname}   ${url}
    Click Element     //span[text()='Stores']/..
    Click Element     //a[text()="Add new Store"]
    Click Element     //a/span[text()=${DStype}]/..

    Wait Until Page Contains    Basic Store Info
    Put Text In Labelled Input      Data Source Name *         ${DSName}
    Put Text In Labelled Input      Description                ${DSNAME}_test
    Put Text In Labelled Input      ${connection}              ${url}

    Scroll Into View     form .button-group a

    Click Element      //a[text()='Save']
    Wait Until Page Does Not Contain      //a[text()='Save']

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
