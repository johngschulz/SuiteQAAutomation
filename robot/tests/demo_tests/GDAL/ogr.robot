***Settings***

Resource          ${CURDIR}/../geoserver/resource.robot

Library           RequestsLibrary

*** Variables ***

${OGR_PATH_UNIX}            /usr/share/boundless/geoserver/data-dir/cdfadmin13_1.gdb
${OGR_PATH_WIN}             C:\\geoserverDataDir\\cdfadmin13_1.gdb
${OGR_LAYER_NAME}     cdfadmin13_1_region
${OGR_DS_NAME}        ogr_test_ds

***Testcases***

Test OGR Datastore
    [Setup]      Run Keywords      Login To Geoserver     Create OGR Datastore
    Publish Layer
    Verify OGR Map
    [Teardown]   Run Keywords    Delete OGR Datastore    Close Browser

***Keywords***

Publish Layer
      Wait Until Page Contains      Publish
      Input Text    id=filter   region
      Press Key   id=filter   \\13
      Click Element   link=Publish
      Wait Until Page Contains    Edit Layer

      Click Element     link=Compute from native bounds

      Click Element   //a[text()="Save"]

Create OGR Datastore
    Get OGR URL
    Click Element     //span[text()='Stores']/..
    Click Element     //a[text()="Add new Store"]
    Click Element     //span[text()='OGR']/..

    Put Text In Labelled Input      Data Source Name *         ${OGR_DS_NAME}
    Put Text In Labelled Input      Description                ogr_test
    Put Text In Labelled Input      DatasourceName *           ${OGR_URL}
    Put Text In Labelled Input      DriverName                 OpenFileGDB

    Scroll Into View     form .button-group a

    Click Element      //a[text()='Save']
    Wait Until Page Does Not Contain      //a[text()='Save']


Scroll Into View
        [arguments]  ${docSelector}
        Execute Javascript   document.querySelector("${docSelector}").scrollIntoView(true)

Verify OGR Map
    ${img}     WMS Get Map  layernames=opengeo:${OGR_LAYER_NAME}  srs=EPSG:3310  bbox=-373983.78119999915,-604504.6875,540082.7500000008,450029.87500000047   width=665   height=768
    Images Should Be Equal  ${TEST_DATA}ogr_full.png  ${img}

    ${img2}     WMS Get Map  layernames=opengeo:${OGR_LAYER_NAME}   srs=EPSG:3310   bbox=-120024.49656522134,-311513.9605509562,286165.2755257313,157589.41533754254   width=665   height=768
    Images Should Be Equal  ${TEST_DATA}ogr_zoomed.png  ${img2}

Delete Ogr Datastore
    Go To                ${LOGIN URL}
    Click Element     //span[text()='Stores']/..
    Select Checkbox    //span[text()='${OGR_DS_NAME}']/ancestor::tr/th/input
    Wait Until Page Contains Element     //a[text()='Remove selected Stores']
    Click Element        //a[text()='Remove selected Stores']
    Click Element    //a[text()='OK']
    Sleep    1 seconds   #wait for DB connection to drop


Put Text In Labelled Input
      [arguments]    ${label}     ${text}
      ${passed}    ${elem}       Run Keyword and Ignore Error    Get WebElement      //*[(self::span or self::label) and text()='${label}']/..//input
      ${passed2}    ${elem2}     Run Keyword and Ignore Error    Get WebElement      //*[(self::span or self::label) and text()='${label}']/../..//input
      ${elemFinal}=    Set Variable If       '${passed}'=='PASS'      ${elem}    ${elem2}
      Input Text         ${elemFinal}      ${text}

Set Unix Path
    Set Suite Variable  ${OGR_URL}  ${OGR_PATH_UNIX}

Set Win Path
    Set Suite Variable  ${OGR_URL}  ${OGR_PATH_WIN}

Check Host
    Should Match Regexp   ${HOST}   (?i)win

Get OGR URL
    ${status}=   Run Keyword And Return Status  Check Host
    Run Keyword If  '${status}'=='True'   Set Win Path
    Run Keyword Unless  '${status}'=='True'   Set Unix Path

Login To Geoserver
    Set Selenium Timeout     20 seconds
    Set Selenium Speed      .2
    Set Selenium Implicit Wait   1 seconds
    Open Browser To GeoServer
    Submit Geoserver Credentials
    Welcome Page Should Be Open
