*** Settings ***
Documentation     follow the composer tutorial from the suite documentation
...
TestSetup         Login To Composer
TestTeardown      Close Browser
Resource          resource.robot

*** Test Cases ***
Setup Workspace
    Create Workspace          ws=tutorial
    Import File To Workspace  ws=tutorial  file=tutorial.zip  text=4 layers imported.

Edit Layers
    Open Layers  ws=tutorial
    Wait Until Page Contains    4 layers in current project.
    Edit Layer  old_name=ne_10m_populated_places   name=places     title=Populated places
    Edit Layer  old_name=ne_10m_roads              name=roads      title=Roads
    Edit Layer  old_name=ne_10m_admin_0_countries  name=countries  title=Countries
    Edit Layer  old_name=dem_large                 name=dem        title=DEM
    Element Should Be Visible  xpath=//div[@class='layer-detail' and contains(.,"Populated places")]
    Element Should Be Visible  xpath=//div[@class='layer-detail' and contains(.,"Roads")]
    Element Should Be Visible  xpath=//div[@class='layer-detail' and contains(.,"Countries")]
    Element Should Be Visible  xpath=//div[@class='layer-detail' and contains(.,"DEM")]

Create Map
    Open Workspace  ws=tutorial
    Create Map  name=tutmap  title=Tutorial Map  desc=Composer / YSLD tutorial map
    Page Should Contain    Rendering map
    Page Should Contain    roads
    Page Should Contain    symbolizers

Style Layers
    Import Library  OperatingSystem
    ${PLACES_YSLD}=     Get File    ${TEST DATA}places.ysld
    ${ROADS_YSLD}=      Get File    ${TEST DATA}roads.ysld
    ${COUNTRIES_YSLD}=  Get File    ${TEST DATA}countries.ysld
    ${DEM_YSLD}=        Get File    ${TEST DATA}dem.ysld
    Open Layer  ws=tutorial  name=places
    Set Style   style=${PLACES_YSLD}
    Page Should Contain    Style saved for layer: places
    Open Layer  ws=tutorial  name=roads
    Set Style   style=${ROADS_YSLD}
    Page Should Contain    Style saved for layer: roads
    Open Layer  ws=tutorial  name=countries
    Set Style   style=${COUNTRIES_YSLD}
    Page Should Contain    Style saved for layer: countries
    Open Layer  ws=tutorial  name=dem
    Set Style   style=${DEM_YSLD}
    Page Should Contain    Style saved for layer: dem

Verify Map
    Import Resource         ${CURDIR}/../geoserver/resource.robot
    ${img}     WMS Get Map  layernames=tutorial:tutmap
    Images Should Be Equal  ${TEST_DATA}tutmap.png  ${img}

Delete Workspace
    Delete Workspace   ws=tutorial
