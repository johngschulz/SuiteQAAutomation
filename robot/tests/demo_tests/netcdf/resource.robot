Library           Selenium2Library
Library           RequestsLibrary
Library           Collections

*** Keywords ***

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


Get Feature Info Simple
      [arguments]   ${bbox}   ${qlayer}=opengeo:O3   ${layers}=opengeo:O3
      ${auth}=     Create List   admin    geoserver
      Create Session     RESTAPI    http://${SERVER}   auth=${auth}
     &{params}=   Create Dictionary   SERVICE=WMS    VERSION=1.1.1   REQUEST=GetFeatureInfo   QUERY_LAYERS=${qlayer}  LAYERS=${layers}   INFO_FORMAT=text/html   FEATURE_COUNT=50   X=50  Y=50   SRS=EPSG:4326   WIDTH=101   HEIGHT=101  BBOX=${bbox}
     ${resp}=   GET Request    RESTAPI    /geoserver/wms   params=${params}
     Log   ${resp.content}
     [Return]  ${resp.content}
     [Teardown]   Delete All Sessions

Get Feature Info
      [arguments]   ${elev}     ${time}   ${bbox}   ${qlayer}=opengeo:O3   ${layers}=opengeo:O3
      ${auth}=     Create List   admin    geoserver
      Create Session     RESTAPI    http://${SERVER}   auth=${auth}
     &{params}=   Create Dictionary   SERVICE=WMS    VERSION=1.1.1   REQUEST=GetFeatureInfo   QUERY_LAYERS=${qlayer}  ELEVATION=${elev}   TIME=${time}    LAYERS=${layers}   INFO_FORMAT=application/json   FEATURE_COUNT=50   X=50  Y=50   SRS=EPSG:4326   WIDTH=101   HEIGHT=101  BBOX=${bbox}
     ${resp}=   GET Request    RESTAPI    /geoserver/wms   params=${params}
     [Return]  ${resp.content}
     [Teardown]   Delete All Sessions

Delete Datastore
    [arguments]        ${dsname}
    Go To                ${LOGIN URL}
    Click Element     //span[text()='Stores']/..
    Select Checkbox    //span[text()='${dsname}']/ancestor::tr/th/input
    Wait Until Page Contains Element     //a[text()='Remove selected Stores']
    Click Element        //a[text()='Remove selected Stores']
    Click Element    //a[text()='OK']
    Sleep    1 seconds   #wait for DB connection to drop
