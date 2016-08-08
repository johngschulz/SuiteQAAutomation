*** Settings ***
Resource          resource.robot

Test Setup          Open Browser To GeoServer
Test Teardown       Close Browser

*** Variables ***
${JP2K_DS_NAME}        bogota_jp2_direct
${JP2K_URL}            file:data/bogota.jp2

*** Test Cases ***
Valid Login
    Submit Geoserver Credentials
    Welcome Page Should Be Open

Check for strong crypto
    Submit Geoserver Credentials
    Page Should Not Contain     No strong cryptography available
    Page Should Contain         Strong cryptography available

Check for Marlin renderer
    Submit Geoserver Credentials
    Go To   ${REST URL}/about/status
    Page Should Contain     Provider: Marlin

Check for LibJPEG-turbo
    Submit Geoserver Credentials
    Go To   ${REST URL}/about/status
    Page Should Contain     GeoServer libjpeg-turbo Module
    Page Should Not Contain      JNI LibJPEGTurbo Wrapper Version: unavailable

Compute SRS Bounds
    Submit Geoserver Credentials
    Create Datastore  URL *   'JP2K (Direct) '   ${JP2K_DS_NAME}   ${JP2K_URL}
    Publish And Compute SRS Bounds   ${JP2K_DS_NAME}   bogota    srs=EPSG:21892
    Verify SRS Bounds
    [teardown]      Run Keywords    Delete JP2 Datastore    Close Browser

*** Keywords ***
Publish And Compute SRS Bounds
    [arguments]   ${dsname}   ${varname}    ${srs}=EPSG:4326
    Click Element     //span[text()='Layers']/..
    Click Element     //a[text()='Add a new layer']
    Select From List By Label   //select    opengeo:${dsname}
    Wait Until Page Contains      Publish
    Click Element      //span[text()='${varname}']/../..//a
    Wait Until Page Contains     Edit Layer

    Put Text In Labelled Input     Declared SRS     ${srs}
    Click Element    link=Compute from SRS bounds

Verify SRS Bounds
    Textfield Value Should Be    id=minX    832,012.6927586218
    Textfield Value Should Be    id=maxX    1,167,078.0049132355
    Textfield Value Should Be    id=minY    213,804.09150839213
    Textfield Value Should Be    id=maxY    1,799,078.4893904696

Delete JP2 Datastore
    Delete Datastore    ${JP2K_DS_NAME}