*** Settings ***
Documentation     MBTiles  test
...
Library           RequestsLibrary

TestSetup         Open Browser To GeoServer
Resource          ${CURDIR}/../geoserver/resource.robot

*** Variables ***
${MBTiles_DS_NAME}        world_lakes
${MBTiles_URL}            file:data/world_lakes.mbtiles

*** Test Cases ***
MBTiles Extension
  Submit Geoserver Credentials
  Create Datastore  'MBTiles'   ${MBTiles_DS_NAME}   ${MBTiles_URL}
  Publish Layer   ${MBTiles_DS_NAME}   geotools_coverage   srs=EPSG:3857
  #check the image
  ${img}    WMS Get Map   layernames=geotools_coverage   srs=EPSG:3857    bbox=0.0,-1.9971868880408555E7,2.0037508342789248E7,-7.081155E-10   height=765  width=768
  Images Should Be Equal    ${TEST_DATA}opengeo_mbtiles.png    ${img}
  #check feature request works
  ${resp}=   Get Feature Info   12717710.142414626,-2555636.09989255,12841094.103260297,-2432252.1390468776   opengeo:geotools_coverage  opengeo:geotools_coverage    EPSG:3857
  Should Contain  ${resp}    113.0
  [teardown]    Run Keywords  Delete MBTiles Datastore    Close Browser

*** Keywords ***
Delete MBTiles DataStore
  Delete Datastore    world_lakes