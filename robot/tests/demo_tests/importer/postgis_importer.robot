***Settings***
 


Resource          ${CURDIR}/../database/resource.robot
Resource          ${CURDIR}/../geoserver/resource.robot



*** Variables ***
${DB_SERVER_IP}             localhost
${DB_USER}                  postgres
${DB_PASS}                  postgres
${DB_PORT}                  5432
${DB_POSTGIS_TMP_DB_NAME}   robot_postgis_test
${DB_PCLOUD_TMP_DB_NAME}    robot_pcloud_test

${TEST_POSTGIS_DATASTORE_NAME}    test_postgis_store

***Testcases***
 
Test Upload to Postgis 
    [Setup]      Run Keywords    Create Temp Postgis Database   Login To Geoserver     Create Postgis Datastore
    Should Be Equal   1    1
    [Teardown]   Run Keywords    Delete Postgis Datastore         Drop Temp Postgis Database  #Close Browser



***Keywords***
Create Postgis Datastore
    Click Element     //span[text()='Stores']/.. 
    Click Element     //a[text()="Add new Store"]
    Click Element     //span[text()='PostGIS']/.. 

    Put Text In Labelled Input      Data Source Name *          ${TEST_POSTGIS_DATASTORE_NAME}  
    Put Text In Labelled Input      host *                      ${DB_SERVER_IP}   
    Put Text In Labelled Input      database                    ${DB_POSTGIS_TMP_DB_NAME} 
    Put Text In Labelled Input      user *                      ${DB_USER}
    Put Text In Labelled Input      passwd                      ${DB_PASS}

    Click Element      //a[text()='Save']
    Wait Until Page Does Not Contain      //a[text()='Save']


Delete Postgis Datastore
    Go To                ${LOGIN URL} 
    Click Element     //span[text()='Stores']/..
    Select Checkbox    //span[text()='${TEST_POSTGIS_DATASTORE_NAME}']/ancestor::tr/th/input
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
    Open Browser To GeoServer
    Input Username    admin
    Input Password    geoserver
    Submit Credentials
    Welcome Page Should Be Open
