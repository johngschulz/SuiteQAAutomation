*** Settings ***
Documentation     GeoPackage test
...
TestSetup         Open Browser To GeoServer
TestTeardown      Close Browser
Resource          ${CURDIR}/../geoserver/resource.robot

*** Variables ***
${VECTOR_DS_NAME}        pop_places
${VECTOR_URL}            pop_places.gpkg
${RASTER_DS_NAME}        world_lakes
${RASTER_URL}            file:data/world_lakes.gpkg

*** Test Cases ***
Verfiy Vector GeoPkg Store
  Submit Geoserver Credentials
  Create Datastore  database *   'GeoPackage'   ${VECTOR_DS_NAME}   ${VECTOR_URL}
  Publish Layer   ${VECTOR_DS_NAME}   pop_places    srs=EPSG:4326
  #get map
  ${img}    WMS Get Map   layernames=opengeo:pop_places   srs=EPSG:4326    bbox=-89.18199854735434,-34.538004006675465,109.31599868366044,41.74299916992038   height=330  width=768
  #get feature info
  Images Should Be Equal    ${TEST_DATA}opengeo-vec_gpkg.png    ${img}
  ${resp}=   Get Feature Info   -14.166774975270382,-6.7105776198649245,15.956262340567715,23.412459695973173   opengeo:pop_places    opengeo:pop_places    EPSG:4326
  [teardown]    Run Keyword     Clean Up   ${VECTOR_DS_NAME}

Verify Raster GeoPkg Store
  Submit Geoserver Credentials
  Create Datastore  URL *   'GeoPackage (mosaic)'   ${RASTER_DS_NAME}   ${RASTER_URL}
  Publish Layer   ${RASTER_DS_NAME}   World_Lakes    srs=EPSG:4326
  #get map
  ${img}    WMS Get Map   layernames=opengeo:World_Lakes   srs=EPSG:4326    bbox=0.0,-85.0,180.0,0.0   height=362  width=768
  Images Should Be Equal    ${TEST_DATA}opengeo-ras_gpkg.png    ${img}
  # get feature info
  ${resp}=   Get Feature Info   98.26171875,-52.91015625,133.76953125,-17.40234375   opengeo:World_Lakes  opengeo:World_Lakes    EPSG:4326
  Should Contain  ${resp}    251.0
  [teardown]    Run Keyword     Clean Up   ${RASTER_DS_NAME}

GetMap Output GeoPkg
  Submit Geoserver Credentials
  ${file}    WMS Get Map    layernames=opengeo:countries    srs=EPSG:4326    mimeType=application/x-gpkg    bbox=-180.0,-89.99892578124998,180.00000000000003,83.59960937500006   width=370    height=370
  ${len}    Get Length    ${file}
  Should Be True    ${len}==2956288

GetFeature Output GeoPkg
  Submit Geoserver Credentials
  ${file}   WFS Get Feature By BBOX    usa    states    -121.695556640625,46.263427734375,-119.476318359375,48.482666015625    EPSG:4326    gpkg
  ${len}    Get Length    ${file}
  Should Be True    ${len}==29696


*** Keywords ***
Clean Up
    [arguments]    ${ds_name}
    Delete Datastore    ${ds_name}
    Close Browser