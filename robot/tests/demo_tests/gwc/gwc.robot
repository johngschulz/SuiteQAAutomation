*** Settings ***

Resource          ${CURDIR}/../geoserver/resource.robot

Library           Selenium2Library
Library           XML
Library           RequestsLibrary
Resource          ../../environment.robot


*** Variables ***
 

***Testcases***
Test0
    [Setup]      Run Keywords     Login To Geoserver      
    Empty Cached Layer      layer=topp:states
    ${cacheStatus}=    Get Test Image Cache Status
    Should be Equal    ${cacheStatus}   MISS
    ${cacheStatus2}=    Get Test Image Cache Status
    Should be Equal    ${cacheStatus2}   HIT

***Keywords***

Empty Cached Layer
       [arguments]   ${layer}=topp:states
       Click Element     //span[text()='Tile Layers']/.. 
       Click Element      //span[text()='${layer}']/ancestor::tr//*[text()='Empty']/ancestor::a     
       Click Element       //*[@class="wicket-modal" ]//a[text()='OK']


Get Test Image Cache Status
	    [arguments]   ${layer}=topp:states
		Create Session     GWC    http://${SERVER}  
		&{data}=  Create Dictionary  LAYERS=${layer}   FORMAT=image/png    SERVICE=WMS   REQUEST=GetMap   Version=1.1.1      STYLES=     SRS=EPSG:4326   BBOX=-135,0,-90,45  WIDTH=256  HEIGHT=256
		 ${resp}=   Get Request    GWC    /geoserver/gwc/service/wms      params=${data}  
		 Log   ${resp.headers}		 

		 Should Be Equal As Strings  ${resp.status_code}  200
		 
		 Delete All Sessions
		 [return]  ${resp.headers['geowebcache-cache-result']}


Login To Geoserver
    Set Selenium Timeout     20 seconds
    Set Selenium Speed      .2
    Set Selenium Implicit Wait   1 seconds
    Open Browser To GeoServer
    Input Username    admin
    Input Password    geoserver
    Submit Credentials
    Welcome Page Should Be Open
    Sleep    1 seconds