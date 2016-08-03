*** Settings ***
Resource          resource.robot

Library           OperatingSystem
Library           RequestsLibrary

TestSetup         Open Browser To GeoServer

*** Variables ***
${PLACES_URL}                    file:data/ne_10m_populated_places.shp
${PLACES_DS_NAME}                populated_places
${PLACES_LAYER_NAME}             ne_10m_populated_places
${STYLE_NAME}                    rest_upload


*** Test Cases ***
Verify Uploaded Styles
    Submit Geoserver Credentials
    Upload Test Resources
    Refresh GeoServer Cache
    Upload Test Data
    Style Data
    Verify Map
    [teardown]    Run Keywords    Clean Up    Close Browser

*** Keywords ***
Refresh GeoServer Cache
    Click Element     //span[text()='Server Status']/..
    Click Element     partial link=Clear

Upload Test Resources
    Upload Style Resource    smileyface.png       image/png
    Upload Style Resource    AksharNormal.ttf     application/x-font-ttf
    Upload Style             rest_upload.sld    application/vnd.ogc.sld+xml

Upload Test Data
    Create Datastore    Shapefile location *    'Shapefile'     ${PLACES_DS_NAME}    ${PLACES_URL}
    Publish Layer       ${PLACES_DS_NAME}      ${PLACES_LAYER_NAME}

Upload Style Resource
    [arguments]   ${resource_name}  ${mime}
    &{header}=   Create Dictionary    Content-type=${mime}  raw=true
    Create Rest Session
    ${file}  Set Resource File  ${TEST DATA}    ${resource_name}
    ${resp}   Put Request   RESTAPI   /geoserver/rest/resource/styles/${resource_name}   headers=${header}  data=${file}
    Should Not Be Equal As Strings  ${resp.status_code}   405
    Should Not Be Equal As Strings  ${resp.status_code}   500

Upload Style
    [arguments]   ${resource_name}    ${mime}
    Create Rest Session
    &{header1}=   Create Dictionary    Content-type=text/xml
    &{header2}=   Create Dictionary    Content-type=${mime}
    ${files}  Set SLD File  ${TEST DATA}    ${resource_name}
    ${resp}   Post Request   RESTAPI   /geoserver/rest/styles   headers=${header1}    data=<style><name>${STYLE_NAME}</name><filename>${resource_name}</filename></style>
    Should Be Equal As Strings    ${resp.status_code}   201
    ${resp2}   Put Request   RESTAPI   /geoserver/rest/styles/${STYLE_NAME}.sld   headers=${header2}  data=${files}
    Should Be Equal As Strings    ${resp.status_code}   201
    
Style Data
    Style Layer     ${PLACES_LAYER_NAME}   ${STYLE_NAME}

Verify Map
    ${img}    WMS Get Map   layernames=opengeo:ne_10m_populated_places   srs=EPSG:4326    bbox=-179.58997888396897,-89.99999981438727,179.38330358817018,82.48332318035943  height=369  width=768
    Images Should Be Equal    ${TEST_DATA}opengeo-rest.png    ${img}
    
Set SLD File
    [arguments]   ${filedir}    ${filename}
    ${fullFname}=  evaluate   r"${filedir}" +os.sep + r"${filename}"     os
    ${doubleEscapedFname}=  evaluate   r"${fullFname}".replace("\\\\","\\\\\\\\")
    ${files}=    evaluate   open("${doubleEscapedFname}","rb").read()
    [Return]  ${files}
    
Set Resource File
    [arguments]   ${filedir}    ${filename}
    ${fullFname}=  evaluate   r"${filedir}" +os.sep + r"${filename}"     os
    ${doubleEscapedFname}=  evaluate   r"${fullFname}".replace("\\\\","\\\\\\\\")
    ${files}=     evaluate  open("${doubleEscapedFname}","rb")
    [Return]  ${files}

Create Rest Session
    ${auth}=     Create List   admin    geoserver
    Create Session     RESTAPI    http://${SERVER}   auth=${auth}
    
Clean Up
    Delete Datastore    ${PLACES_DS_NAME}
    Delete Style        ${STYLE_NAME}
    Delete All Sessions
