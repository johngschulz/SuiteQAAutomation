***Settings***

Resource          ${CURDIR}/../geoserver/resource.robot
Resource           ${CURDIR}/resource.robot
Library           RequestsLibrary
Library           Collections

*** Variables ***

${GRIB_URL_SAMPLE}            file:data/sampleGrib.grb2
${GRIB_DS_NAME_SAMPLE}        grib_ds_name_sampleGrib



***Testcases***


Test Grib
    [Setup]      Run Keywords      Login To Geoserver     Create Grib Datastores
    Publish Layers
    Verify WMS MultiDim Requests
    [Teardown]   Run Keywords   Delete Grib Datastores    Close Browser



***Keywords***

Create Grib Datastores
        Create Grib Datastore     ${GRIB_DS_NAME_SAMPLE}     ${GRIB_URL_SAMPLE}

Delete Grib Datastores
        Delete Datastore         ${GRIB_DS_NAME_SAMPLE}

Publish Layers
        Publish Layer NoDims     ${GRIB_DS_NAME_SAMPLE}  u-component_of_current_surface


Verify WMS MultiDim Requests
         ${resp}=   Get Feature Info   -56.6290283203125,5.4327392578125,-55.5194091796875,6.5423583984375   opengeo:u-component_of_current_surface  opengeo:u-component_of_current_surface
         Should Contain  ${resp}    -0.06814
         ${resp}=   Get Feature Info   -56.6180419921875,5.2569580078125,-55.5084228515625,6.3665771484375  opengeo:u-component_of_current_surface  opengeo:u-component_of_current_surface
         Should Contain  ${resp}   NaN

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

Create Grib Datastore
    [arguments]    ${DSname}  ${url}
    Click Element     //span[text()='Stores']/..
    Click Element     //a[text()="Add new Store"]
    Click Element     //span[text()='GRIB']/..

    Put Text In Labelled Input      Data Source Name *         ${DSName}
    Put Text In Labelled Input      Description                ${DSNAME}_grib_test
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
