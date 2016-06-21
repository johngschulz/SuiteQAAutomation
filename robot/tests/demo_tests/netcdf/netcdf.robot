***Settings***

Resource          ${CURDIR}/../geoserver/resource.robot

Library           RequestsLibrary
Library           Collections

*** Variables ***

${NETCDF_URL_O3}            file:data/O3-NO2.nc
${NETCDF_DS_NAME_O3}        netcdf_ds_name_O3

${NETCDF_URL_VIS}            file:data/visibility.nc
${NETCDF_DS_NAME_VIS}        netcdf_ds_name_VIS


***Testcases***

# we use two netcdf files - both from the geoserver/geotools test cases
# Visibility - this is in a non-standard projects, however, its big enough to be compressable
# O3-NO2.nc  - 2 variables (O3 and NO2) in X, Y, Z, T

Test MultiDim NetCDF
    [Setup]      Run Keywords      Login To Geoserver     Create NetCDF Datastores
    Publish Layers
    Verify WMS MultiDim Requests
    Check NetCDF Output
    Check NetCDF4 Compressed Output
    [Teardown]   Run Keywords    Delete NetCDF Datastores    Close Browser



***Keywords***
Check NetCDF4 Compressed Output
   ${cov}=   Get Coverage    opengeo__Visibility_surface   application/x-netcdf4
   ${len}    Get Length    ${cov}   
   Log   ${len}
   Should be equal as numbers   ${len}   42005  grid is different than expected (test by size)


Create NetCDF Datastores
	Create NetCDF Datastore     ${NETCDF_DS_NAME_O3}     ${NETCDF_URL_O3}
	Create NetCDF Datastore      ${NETCDF_DS_NAME_VIS}  ${NETCDF_URL_VIS}

Delete NetCDF Datastores
        Delete NetCDF Datastore         ${NETCDF_DS_NAME_O3}
	Delete NetCDF Datastore         ${NETCDF_DS_NAME_VIS}

Publish Layers
	Publish Layer Dims      ${NETCDF_DS_NAME_O3}   O3
	Publish Layer NoDims     ${NETCDF_DS_NAME_VIS}  Visibility_surface

Check NetCDF Output
	${cov}=   Get Coverage   opengeo__O3   application/x-netcdf   elevation    450
	${len}    Get Length    ${cov}
           #verified by   java -jar toolsUI-4.6.6.jar   (netcdf tools)
	Should be equal as numbers   ${len}   32428    grid is different than expected (test by size)

Get Coverage 
      [arguments]   ${covid}   ${mime}=application/x-netcdf  ${axis}=na      ${axis_val}=na  
      ${auth}=     Create List   admin    geoserver
      Create Session     RESTAPI    http://${SERVER}   auth=${auth}
     &{params}=   Create Dictionary   request=GetCoverage   service=WCS   version=2.0.1   coverageId=${covid}   Format=${mime}
     Log    ${axis}
     Run Keyword If    '${axis}' != 'na'    Set To Dictionary   ${params}  subset=http://www.opengis.net/def/axis/OGC/0/${axis}(${axis_val})
     ${resp}=   GET Request    RESTAPI    /geoserver/wcs   params=${params}
     [Return]  ${resp.content}
     [Teardown]   Delete All Sessions

Verify WMS MultiDim Requests
         ${resp}=   Get Feature Info     10.0    2012-04-01T00:00:00.000Z   14.855920835037232,44.95845599601746,14.925272031326294,45.027807192306526
         Should Contain  ${resp}    79.43
         ${resp}=   Get Feature Info     450.0    2012-04-01T00:00:00.000Z   14.855920835037232,44.95845599601746,14.925272031326294,45.027807192306526
         Should Contain  ${resp}   80.60
 	 ${resp}=   Get Feature Info     10.0   2012-04-01T01:00:00.000Z   14.855920835037232,44.95845599601746,14.925272031326294,45.027807192306526
         Should Contain  ${resp}   73.06
         ${resp}=   Get Feature Info     450.0   2012-04-01T01:00:00.000Z   14.855920835037232,44.95845599601746,14.925272031326294,45.027807192306526
         Should Contain  ${resp}   78.53

Publish Layer NoDims
    [arguments]   ${dsname}   ${varname}
      Click Element     //span[text()='Layers']/..
      Click Element     //a[text()='Add a new layer']
      Select From List By Label   //select    opengeo:${dsname}
      Wait Until Page Contains      Publish
      Click Element      //span[text()='${varname}']/../..//a
      Wait Until Page Contains     Edit Layer

      Put Text In Labelled Input     Declared SRS     EPSG:4326

      Click Element    //span[text()='NetCDF Output Settings']/..
      Wait Until Page Contains    Enable Chunk Shuffling      
      Input Text    //*[@id="compressionLevel"]    9

      Click Element   //a[text()="Save"]
     

Publish Layer Dims
      [arguments]   ${dsname}   ${varname}
      Click Element     //span[text()='Layers']/..
      Click Element     //a[text()='Add a new layer']
      Select From List By Label   //select    opengeo:${dsname}
      Wait Until Page Contains      Publish
      Click Element      //span[text()='${varname}']/../..//a 
      Wait Until Page Contains     Edit Layer

      Click Element    //span[text()='Dimensions']/..
      Select Checkbox    //legend/span[text()="Time"]/../..//input[@type="checkbox"]
      Select From List By Label      //legend/span[text()="Time"]/../..//select[@id="presentation"]    List

      Select Checkbox  //legend/span[text()="Elevation"]/../..//input[@type="checkbox"]
      Select From List By Label   //legend/span[text()="Elevation"]/../..//select[@id="presentation"]   List

      Click Element    //span[text()='NetCDF Output Settings']/..
      Wait Until Page Contains    Enable Chunk Shuffling
      Input Text    //*[@id="compressionLevel"]    9

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
    [arguments]    ${DSname}  ${url}
    Click Element     //span[text()='Stores']/..
    Click Element     //a[text()="Add new Store"]
    Click Element     //span[text()='NetCDF']/..

    Put Text In Labelled Input      Data Source Name *         ${DSName} 
    Put Text In Labelled Input      Description                ${DSNAME}_netcdf_test
    Put Text In Labelled Input      URL *                      ${url}

    Scroll Into View     form .button-group a

    Click Element      //a[text()='Save']
    Wait Until Page Does Not Contain      //a[text()='Save']


Scroll Into View
        [arguments]  ${docSelector}
        Execute Javascript   document.querySelector("${docSelector}").scrollIntoView(true)


Delete NetCDF Datastore
    [arguments]        ${dsname}
    Go To                ${LOGIN URL}
    Click Element     //span[text()='Stores']/..
    Select Checkbox    //span[text()='${dsname}']/ancestor::tr/th/input
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
