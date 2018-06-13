*** Settings ***
Documentation    Tests the most basic community -> BSE backup restore
Library    Process
Library    RequestsLibrary
Library    OperatingSystem
Suite Setup       Run Keywords
...               Start Redis
...               Start BSE
#...               Start Community Postgis

Suite Teardown    Run Keywords
...               Stop BSE
...               Stop Redis
#...               Stop Community Postgis

*** Variables ***
${CMMNTY_PORT}    9191
${BSE_IMAGE_NAME}      quay.io/boundlessgeo/bse:1.1.1
${BSE_PORT}    9292
${CMMNTY_DOCKER_ID}
${BSE_DOCKER_ID}
${CONNECT_ATTEMPTS}    8x
${CONNECT_TIMEOUTS}    20s
${POSTGIS_DOCKER_ID}   postgis_community
${POSTGIS_IP}
${POSTGIS_PORT}        5732
${REDIS_IP}
${HOST_TEMP}           ${CURDIR}/data
${REMOTE_TEMP}         /backup-restore

*** Test Cases ***
Test Status Page
    Check Start Page    ${BSE_PORT}

Perform Basic Backup and Restore from Community
    Restore Backup to BSE
    Check Restored Layer In BSE

*** Keywords ***
Check Restored Layer In BSE
    ${auth}=    Create List    admin    geoserver
    Create Session    geoserver_community    http://localhost:${BSE_PORT}   auth=${auth}
    ${resp}=    Get Request    geoserver_community    /geoserver/rest/layers/acme:ne_10m_roads_north_america.json
    Should Be Equal As Strings    ${resp.status_code}    200

Check Start Page
    [Arguments]    ${port}
    ${auth}=    Create List    admin    geoserver
    Create Session    geoserver_community    http://localhost:${port}   auth=${auth}
    ${resp}=    Get Request    geoserver_community    /geoserver/rest/about/status
    Should Be Equal As Strings    ${resp.status_code}    200

Start BSE
    Log    "Starting BSE"
    ${bse_out}=    Run Process    docker    run    --rm    -d   --name   bse_geoserver  
    ...            -e   BSE_CATALOG_REDIS_MANUAL_HOST\=${REDIS_IP}   
    ...            -p   ${BSE_PORT}:8080   -v   ${HOST_TEMP}:${REMOTE_TEMP}    ${BSE_IMAGE_NAME}
    Wait Until Keyword Succeeds    ${CONNECT_ATTEMPTS}    ${CONNECT_TIMEOUTS}    Check Start Page    ${BSE_PORT}  
    Log To Console    BSE Started

Stop Community GeoServer
    Log to Console    Stopping community GeoServer ${CMMNTY_DOCKER_ID}
    Run Process    docker    stop    ${CMMNTY_DOCKER_ID}

Start Redis
    Log    Starting BSE Redis
    ${redis_out}=    Run Process    docker    run    --rm    -d    --name   bse_catalog    -p    6379:6379    redis
    #Should Be Equal As Strings    ${redis_out.rc}    0
    Wait Until Keyword Succeeds    12x    10s    Is Redis Up
    ${di_result}=    Run Process    docker  inspect  -f  
    ...                             {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}  bse_catalog
    Set Suite Variable    ${REDIS_IP}   ${di_result.stdout}

Start Postgis
    [Arguments]    ${container_name}    ${mapped_port}
    ${result}=    Run Process   docker  run  --rm    
    ...           -p  ${mapped_port}:5432  --name  ${container_name}  -d  -t  kartoza/postgis    
    #Should Be Equal As Strings    ${result.rc}   0
    Wait Until Keyword Succeeds    12x    10s    Is Postgis Up
    ${di_result}=    Run Process    docker  inspect  -f  {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}  ${POSTGIS_DOCKER_ID}
    Set Suite Variable    ${POSTGIS_IP}   ${di_result.stdout}

Docker Stop
    [Arguments]    ${container_name}
    Run Process    docker  stop  ${container_name}

Start Community Postgis
    Start Postgis    ${POSTGIS_DOCKER_ID}    ${POSTGIS_PORT}

Stop Community Postgis
    Log To Console  Stopping Postgis
    Docker Stop    ${POSTGIS_DOCKER_ID}

Stop BSE
    Log To Console  Stopping BSE
    Docker Stop   bse_geoserver

Stop Redis
    Log to Console   Stopping Redis
    Docker Stop      bse_catalog

Load NA_Roads
    Log To Console    Loading NA Roads
    ${result}=    Run Process    ./data_load/na_roads_postgis.sh  ${POSTGIS_PORT}   
    Should Be Equal As Strings    ${result.rc}    0

Is Postgis Up
    ${result}=    Run Process   pg_isready  -h  localhost  -p  ${POSTGIS_PORT}
    Should Be Equal As Strings    ${result.rc}    0

Is Redis Up
    ${result}=    Run Process    redis-cli    ping
    Should Be Equal As Strings    ${result.rc}    0

Community Data Load
    Load NA_Roads
    Create Workspace in Community
    Create Postgis Datastore in Community
    Create Postgis FeatureType in Community

Create Workspace in Community
    ${auth}=    Create List    admin    geoserver
    Create Session    geoserver-rest    http://localhost:${CMMNTY_PORT}    auth=${auth}
    ${req_data}=  Set Variable   <workspace><name>acme</name></workspace>
    &{headers}    Create Dictionary    Content-Type=text/xml
    ${resp}=    Post Request    geoserver-rest    /geoserver/rest/workspaces     data=${req_data}    headers=${headers}
    Log    ${resp.content}
    Should Be Equal As Strings    201    ${resp.status_code}

Create Postgis Datastore in Community
    ${auth}=    Create List    admin    geoserver
    Create Session    geoserver-rest    http://localhost:${CMMNTY_PORT}    auth=${auth}
    &{headers}    Create Dictionary    Content-Type=text/xml
    ${data}=   Catenate    <dataStore>
    ...                      <name>na_roads</name>
    ...                      <connectionParameters>
    ...                        <host>${POSTGIS_IP}</host>
    ...                        <port>5432</port>
    ...                        <database>na_roads</database>
    ...                        <user>docker</user>
    ...                        <passwd>docker</passwd>
    ...                        <dbtype>postgis</dbtype>
    ...                      </connectionParameters>
    ...                    </dataStore>
    ${resp}=    Post Request    geoserver-rest    /geoserver/rest/workspaces/acme/datastores     data=${data}    headers=${headers}
    Log    ${resp.content}
    Should Be Equal As Strings    201    ${resp.status_code}

Create Postgis FeatureType in Community
    ${auth}=    Create List    admin    geoserver
    Create Session    geoserver-rest    http://localhost:${CMMNTY_PORT}    auth=${auth}
    &{headers}=    Create Dictionary    Content-Type=text/xml
    ${data}=    Set Variable    <featureType><name>ne_10m_roads_north_america</name></featureType>
    ${resp}=    Post Request    geoserver-rest    /geoserver/rest/workspaces/acme/datastores/na_roads/featuretypes     
    ...                         data=${data}    headers=${headers}
    Log    ${resp.content}
    Should Be Equal As Strings    201    ${resp.status_code}

Extract Backup From Community
    ${auth}=    Create List    admin    geoserver
    Create Session    geoserver-rest    http://localhost:${CMMNTY_PORT}    auth=${auth}
    ${data}=    Catenate
    ...  {
    ...   "backup":{
    ...     "archiveFile":"${REMOTE_TEMP}/test_rest_1.zip",
    ...     "overwrite":true,
    ...     "options":{
    ...  }}}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${resp}=       Post Request    geoserver-rest    /geoserver/rest/br/backup    data=${data}    headers=${headers}
    Should Be Equal As Strings    201    ${resp.status_code}
    ${jsondata}=    To Json    ${resp.content}
    Set Test Variable    ${backup_id}    ${jsondata['backup']['execution']['id']}
    Wait Until Keyword Succeeds    5x    3s    Backup Is Complete    ${backup_id}
    Wait Until Keyword Succeeds    5x    3s    Backup File is Not Empty

Restore Backup to BSE
    ${chmod_cmd}    Run Process   docker exec -i bse_geoserver chmod 777 ${REMOTE_TEMP}/backup.zip   shell=True 
    Log    ${chmod_cmd.stdout}
    ${auth}=    Create List    admin    geoserver
    Create Session    geoserver-rest    http://localhost:${BSE_PORT}    auth=${auth}
    ${data}=    Catenate
    ...  {
    ...   "restore":{
    ...     "archiveFile":"${REMOTE_TEMP}/backup.zip",
    ...     "options":{
    ...         "option": ["BK_SKIP_SECURITY=true", "BK_PASSWORD_TOKENS=opengeo.cntryshp.passwd=docker"]
    ...  }}}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${resp}=       Post Request    geoserver-rest    /geoserver/rest/br/restore    data=${data}    headers=${headers}
    Log    ${resp.content}
    Should Be Equal As Strings    201    ${resp.status_code}
    ${jsondata}=    To Json    ${resp.content}
    Set Test Variable    ${restore_id}    ${jsondata['restore']['execution']['id']}
    Wait Until Keyword Succeeds    5x    3s    Restore Is Complete    ${restore_id}

Backup File Is Not Empty
    ${filesize}=    Get File Size  ${HOST_TEMP}/backup.zip
    Should Be True  ${filesize} > 0

Restore Is Complete
    [Arguments]    ${restore_id}
    Log To Console    Checking restore ${restore_id}
    ${auth}=    Create List    admin    geoserver
    Create Session    geoserver-rest    http://localhost:${BSE_PORT}    auth=${auth}
    ${resp}=    Get Request   geoserver-rest   /geoserver/rest/br/restore/${restore_id}.json
    ${jsondata}=    To Json    ${resp.content}
    Should Be Equal As Strings    COMPLETED    ${jsondata['restore']['execution']['status']}

Backup Is Complete
    [Arguments]    ${backup_id}
    Log To Console    Checking backup ${backup_id}
    ${auth}=    Create List    admin    geoserver
    Create Session    geoserver-rest    http://localhost:${CMMNTY_PORT}    auth=${auth}
    ${resp}=    Get Request   geoserver-rest   /geoserver/rest/br/backup/${backup_id}.json
    ${jsondata}=    To Json    ${resp.content}
    Should Be Equal As Strings    COMPLETED    ${jsondata['backup']['execution']['status']}


