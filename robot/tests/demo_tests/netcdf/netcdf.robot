***Settings***

Resource          ${CURDIR}/../geoserver/resource.robot

Library           RequestsLibrary

*** Variables ***

${NETCDF_URL}            file:data/O3-NO2.nc
${NETCDF_DS_NAME}        netcdf_ds_name

***Testcases***

Test MultiDim NetCDF
    [Setup]      Run Keywords      Login To Geoserver     Create NetCDF Datastore
    Publish Layer
    Verify WMS MultiDim Requests
    [Teardown]   Run Keywords    Delete NetCDF Datastore    Close Browser



***Keywords***

Verify WMS MultiDim Requests
         ${resp}=   Get Feature Info     10.0    2012-04-01T00:00:00.000Z   14.855920835037232,44.95845599601746,14.925272031326294,45.027807192306526
         Should Contain  ${resp}    79.43
         ${resp}=   Get Feature Info     450.0    2012-04-01T00:00:00.000Z   14.855920835037232,44.95845599601746,14.925272031326294,45.027807192306526
         Should Contain  ${resp}   80.60
         ${resp}=   Get Feature Info     10.0   2012-04-01T01:00:00.000Z   14.855920835037232,44.95845599601746,14.925272031326294,45.027807192306526
         Should Contain  ${resp}   73.06
         ${resp}=   Get Feature Info     450.0   2012-04-01T01:00:00.000Z   14.855920835037232,44.95845599601746,14.925272031326294,45.027807192306526
         Should Contain  ${resp}   78.53
         
Publish Layer
      Click Element     //span[text()='Layers']/..
      Click Element     //a[text()='Add a new layer']
      Select From List By Label   //select    opengeo:${NETCDF_DS_NAME}
      Wait Until Page Contains      Publish
      Click Element      //span[text()='O3']/../..//a
      Wait Until Page Contains     Edit Layer
      Click Element    //span[text()='Dimensions']/..
      Select Checkbox    //legend/span[text()="Time"]/../..//input[@type="checkbox"]
      Select From List By Label      //legend/span[text()="Time"]/../..//select[@id="presentation"]    List

      Select Checkbox  //legend/span[text()="Elevation"]/../..//input[@type="checkbox"]
      Select From List By Label   //legend/span[text()="Elevation"]/../..//select[@id="presentation"]   List

      Click Element   //a[text()="Save"]

Get Feature Info
      [arguments]   ${elev}     ${time}   ${bbox}
      ${auth}=     Create List   admin    geoserver
      Create Session     RESTAPI    http://${SERVER}   auth=${auth}
     &{params}=   Create Dictionary   SERVICE=WMS    VERSION=1.1.1   REQUEST=GetFeatureInfo   QUERY_LAYERS=opengeo:O3  ELEVATION=${elev}   TIME=${time}    LAYERS=opengeo:O3   INFO_FORMAT=application/json   FEATURE_COUNT=50   X=50  Y=50   SRS=EPSG:4326   WIDTH=101   HEIGHT=101  BBOX=${bbox}
     ${resp}=   GET Request    RESTAPI    /geoserver/wms   params=${params}
     [Return]  ${resp.content}
     [Teardown]   Delete All Sessions

Create NetCDF Datastore
    Click Element     //span[text()='Stores']/..
    Click Element     //a[text()="Add new Store"]
    Click Element     //span[text()='NetCDF']/..

    Put Text In Labelled Input      Data Source Name *         ${NETCDF_DS_NAME}
    Put Text In Labelled Input      Description                netcdf_test
    Put Text In Labelled Input      URL *                      ${NETCDF_URL}

    Scroll Into View     form .button-group a

    Click Element      //a[text()='Save']
    Wait Until Page Does Not Contain      //a[text()='Save']


Scroll Into View
        [arguments]  ${docSelector}
        Execute Javascript   document.querySelector("${docSelector}").scrollIntoView(true)


Delete NetCDF Datastore
    Go To                ${LOGIN URL}
    Click Element     //span[text()='Stores']/..
    Select Checkbox    //span[text()='${NETCDF_DS_NAME}']/ancestor::tr/th/input
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



Login To Geoserver
    Set Selenium Timeout     20 seconds
    Set Selenium Speed      .2
    Set Selenium Implicit Wait   1 seconds
    Open Browser To GeoServer
    Submit Geoserver Credentials
    Welcome Page Should Be Open
                                     
