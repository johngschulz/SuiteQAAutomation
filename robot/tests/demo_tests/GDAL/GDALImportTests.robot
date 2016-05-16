***Settings***


Resource          ${CURDIR}/../database/resource.robot
Resource          ${CURDIR}/../geoserver/resource.robot


Library           Collections
Library           RequestsLibrary
Library           OperatingSystem
Library           Dialogs
Library           Collections

Suite Setup         Create Rest Session   

Suite Teardown      Delete All Sessions


*** Variables ***
${SERVER}                   ${SUT_IP}:8080
${REST_USER}                admin
${REST_PASSWD}              geoserver
${NAMESPACE}                opengeo

***Testcases***

Test GDAL Imports
    Upload And Check   ${CURDIR}     i_3001a.ntf    NITF  ${CURDIR}/i_3001a.png   85.00000733882189,32.98301378265023,85.00026483088732,32.983270939439535    EPSG:4326
    Upload And Check   ${CURDIR}     w_11160994_12_07200_col_2002.zip    MrSID  ${CURDIR}/w_11160994_12_07200_col_2002.png   1116953.4375,994468.359375,1118033.4375,995546.953125   EPSG:404000   
    Upload And Check   ${CURDIR}     sample.ecw    ECW  ${CURDIR}/sample.ecw.png   -23.5546875,-73.212890625,111.4453125,61.611328125   EPSG:404000   
    Upload And Check   ${CURDIR}     bogota.jp2    JP2ECW  ${CURDIR}/bogota.jp2.png    455532.1875,84107.8125,456612.1875,85187.8125   EPSG:404000   
    Upload And Check   ${CURDIR}     n43.dt0    DTED  ${CURDIR}/n43.png  -79.78683471679688,43.39221954345703,-79.25949096679688,43.91887664794922    EPSG:4326   




***Keywords***
Upload And Check   
        [arguments]   ${filedir}    ${filename}   ${formatType}   ${checkImage}   ${requestBBOX}    ${proj}
        ${DSName}=   Upload Image To Geoserver    ${filedir}    ${filename}     ${formatType}     namespace=${NAMESPACE}       
       # pause execution
        Check Against Reference Image    ${DSName}    ${requestBBOX}  ${NAMESPACE}  ${checkImage}    ${proj}       
        [Teardown]  Delete Datastore    ${DSName}    namespace=${NAMESPACE}



Check Against Reference Image
        [arguments]   ${DSName}    ${requestBBOX}  ${namespace}   ${checkImage}   ${proj}
         ${img}=      WMS Get Map  host=${SERVER}   layernames=${namespace}:${DSName}   srs=${proj}    bbox=${requestBBOX}    width=768       height=767  
         Images Should Be Equal       ${checkImage}    ${img} 

Upload Image To Geoserver
        [arguments]   ${filedir}    ${filename}   ${formatType}     ${namespace}=cite   
        ${ID}=      Create Import   namespace=${namespace}
        Upload File To Importer   ${ID}    ${filedir}    ${filename}   ${formatType}
        Fix Workspace   ${ID}   ${namespace}
        ${DSName}=  Complete Import   ${ID} 
        [return]  ${DSName}

Create Import
        [arguments]    ${namespace}=cite 
        &{headers}=  Create Dictionary     Content-type=application/json
        ${data}=     Set Variable    {"import":{"targetWorkspace":{"workspace":{"name":"${namespace}"}} }}          
        ${resp}=   POST Request    RESTAPI    /geoserver/rest/imports     data=${data}
        Should Be Equal As Strings  ${resp.status_code}  201
        ${ID}=    Set Variable     ${resp.json()['import']['id']}
        Log     ${resp.content}
        [return]  ${ID}


Upload File To Importer
        [arguments]   ${ID}     ${filedir}    ${filename}     ${formatType}
        ${oldLogLevel}    Set Log Level    WARN 
         
         #this MUST BE INLINED or very very very slow.  Also, set log level to WARN or your log is HUGE
        ${fullFname}=  evaluate   r"${filedir}" +os.sep + r"${filename}"     os
        ${doubleEscapedFname}=  evaluate   r"${fullFname}".replace("\\\\","\\\\\\\\")   
        &{files}=     evaluate  {"${filename}" : open("${doubleEscapedFname}","rb").read()}
        #---

        ${resp}=  Post Request  RESTAPI  /geoserver/rest/imports/${ID}/tasks  files=${files}   

        Log     ${resp.content}
        Should Be Equal As Strings  ${resp.status_code}  201
        ${geoserverFormat}=     Set Variable    ${resp.json()['task']['data']['format']}
        Should Be Equal As Strings  ${geoserverFormat}   ${formatType}   "geoserver detected format type does not match expected type"
        [teardown]   Set Log Level   ${oldLogLevel}
  
 

Fix Workspace      
        [arguments]   ${ID}     ${namespace}
         &{headers}=  Create Dictionary     Content-type=application/json
        ${resp}=  Put Request     RESTAPI  /geoserver/rest/imports/${ID}/tasks/0/target   headers=${headers}     data={"coverageStore":{"enabled":true,"workspace":{"name":"${namespace}"}}}
        Log     ${resp.content}
        Should Be Equal As Strings  ${resp.status_code}  204

Complete Import
        [arguments]   ${ID}  
        ${resp}=   POST Request    RESTAPI    /geoserver/rest/imports/${ID} 
        Log     ${resp.content}
        Should Be Equal As Strings  ${resp.status_code}  204
        Sleep    2 seconds
        ${resp}=    Get Request   RESTAPI    /geoserver/rest/imports/${ID}/tasks/0
         Log     ${resp.content}
        Should Be Equal As Strings  ${resp.status_code}  200
         Log     ${resp.json()}
         ${DSName}=     Set Variable    ${resp.json()['task']['target']['coverageStore']['name']}
         [return]  ${DSName}


Delete Datastore
         [arguments]   ${DSName}   ${namespace}=cite 
         &{params}=   Create Dictionary   recurse=true     
         ${resp}=   Delete Request    RESTAPI    /geoserver/rest/workspaces/${namespace}/coveragestores/${DSName}   params=${params}
          Should Be Equal As Strings  ${resp.status_code}  200
        Log     ${resp.content}

Create Rest Session   
        ${auth}=     Create List   admin    geoserver
        Create Session     RESTAPI    http://${SERVER}   auth=${auth}




