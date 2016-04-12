***Settings***
 


Resource          ${CURDIR}/../database/resource.robot
Resource          ${CURDIR}/../geoserver/resource.robot


 
Library           Collections
Library           RequestsLibrary
Library           OperatingSystem


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
    Import File

    Import Library    Dialogs
    Pause Execution

    ${img}      WMS Get Map     layernames=cite:parks      bbox=-122.96722412109375,42.247066497802734,-122.70355224609375,42.446537017822266   width=768       height=581   styles=polygon
    Create Binary File   aaa.png    ${img}
    Images Should Be Equal       ${CURDIR}\\parks.png  ${img}

    [Teardown]   Run Keywords    Delete Postgis Datastore         Drop Temp Postgis Database  #Close Browser



***Keywords***


#https://github.com/bulkan/robotframework-requests/blob/master/tests/testcase.txt
Import File
        [arguments]    ${datastoreName}=${TEST_POSTGIS_DATASTORE_NAME}   ${namespace}=cite    ${fname}=parks.zip   ${fdir}=c:\\
        ${auth}=     Create List   admin    geoserver
        Create Session     RESTAPI    http://${SERVER}   auth=${auth}
        &{headers}=  Create Dictionary     Content-type=application/json
        ${data}=     Set Variable    {"import":{"targetWorkspace":{"workspace":{"name":"${namespace}"}},"targetStore":{"dataStore":{"name":"${datastoreName}"}}}}          
        ${resp}=   POST Request    RESTAPI    /geoserver/rest/imports     data=${data}
        Log     ${resp.content}
        ${ID}=    Set Variable     ${resp.json()['import']['id']}
         
       
        ${filecontent}=     Get Binary File      ${fdir}${fname}
        &{files}=  Create Dictionary  ${fname}=${filecontent}
        ${resp}=  Post Request  RESTAPI  /geoserver/rest/imports/${ID}/tasks  files=${files}
        Log     ${resp.content}
        Should Be Equal As Strings  ${resp.status_code}  201
         
        ${resp}=  Put Request     RESTAPI  /geoserver/rest/imports/${ID}/tasks/0/target   headers=${headers}     data={"dataStore":{"name":"test_postgis_store"}}
        Log     ${resp.content}
        Should Be Equal As Strings  ${resp.status_code}  204

        ${resp}=   POST Request    RESTAPI    /geoserver/rest/imports/${ID} 
        Log     ${resp.content}
        Should Be Equal As Strings  ${resp.status_code}  204
        Sleep    2 seconds

        Delete All Sessions

 

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
    Set Selenium Implicit Wait   1 seconds
    Open Browser To GeoServer
    Input Username    admin
    Input Password    geoserver
    Submit Credentials
    Welcome Page Should Be Open
