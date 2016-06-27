***Settings***

Resource          ${CURDIR}/../geoserver/resource.robot
Resource           ${CURDIR}/resource.robot
Library           RequestsLibrary
Library           Collections
Library           OperatingSystem

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
   Create Binary File  _delme.nc    ${cov}
   Log   ${len}
     #verified with ncdump that windows just puts \n in the Projection for the files - otherwise they have the same data
   Should be True  ${len}==42005 or ${len}==41978    grid is different than expected (test by size)


Create NetCDF Datastores
        Create NetCDF Datastore     ${NETCDF_DS_NAME_O3}     ${NETCDF_URL_O3}
        Create NetCDF Datastore      ${NETCDF_DS_NAME_VIS}  ${NETCDF_URL_VIS}

Delete NetCDF Datastores
        Delete Datastore         ${NETCDF_DS_NAME_O3}
        Delete Datastore         ${NETCDF_DS_NAME_VIS}

Publish Layers
        Publish Layer Dims      ${NETCDF_DS_NAME_O3}   O3
        Publish Layer NoDims     ${NETCDF_DS_NAME_VIS}  Visibility_surface

Check NetCDF Output
        ${cov}=   Get Coverage   opengeo__O3   application/x-netcdf   elevation    450
        ${len}    Get Length    ${cov}
           #verified by   java -jar toolsUI-4.6.6.jar   (netcdf tools)
           #windows is slightly different, likely \n in Projection info
        Should Be True  ${len}==32428 or ${len}==32416   grid is different than expected (test by size)


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
