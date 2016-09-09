*** Settings ***
Documentation
...               Tests GeoServer rendering transormations
TestSetup         Open Browser To GeoServer
Resource          resource.robot

*** Variables ***
${VECTOR_DS_NAME}     populated_places
${VECTOR_LAYER_NAME}  ne_10m_populated_places
${VECTOR_URL}         file:data/ne_10m_populated_places.shp
${VECTOR_STYLE}       heatmap.sld
${VECTOR_STYLE_NAME}  heatmap
${RASTER_DS_NAME}     test_dem
${RASTER_LAYER_NAME}  test_raster
${RASTER_URL}         file:data/test_raster.tif
${RASTER_STYLE}       contour.sld
${RASTER_STYLE_NAME}  contour

*** Test Cases ***
Heatmap Vector to Raster
  Submit GeoServer Credentials
  Create Style    ${VECTOR_STYLE}
  Create Datastore  Shapefile location *   'Shapefile'   ${VECTOR_DS_NAME}   ${VECTOR_URL}
  Publish Layer   ${VECTOR_DS_NAME}   ${VECTOR_LAYER_NAME}    srs=EPSG:4326
  Style Layer     ${VECTOR_LAYER_NAME}   ${VECTOR_STYLE_NAME}
  ${img}    WMS Get Map   layernames=opengeo:ne_10m_populated_places   srs=EPSG:4326    bbox=-179.58997888396897,-89.99999981438727,179.38330358817018,82.48332318035943   height=369  width=768
  Images Should Be Equal    ${TEST_DATA}opengeo-heatmap.png    ${img}
  [teardown]    Run Keywords    Clean Up Vector    Close Browser

Contour Raster to Vector
  Submit GeoServer Credentials
  Create Style    ${RASTER_STYLE}
  Create Datastore  URL *   'GeoTIFF'   ${RASTER_DS_NAME}   ${RASTER_URL}
  Publish Layer   ${RASTER_DS_NAME}   ${RASTER_LAYER_NAME}    srs=EPSG:4326
  Style Layer     ${RASTER_LAYER_NAME}   ${RASTER_STYLE_NAME}
  ${img}    WMS Get Map   layernames=opengeo:test_raster   srs=EPSG:4326    bbox=-180.0,-90.0,180.0,90.0  height=384  width=768
  Images Should Be Equal    ${TEST_DATA}opengeo-contour.png    ${img}
  [teardown]    Run Keywords    Clean Up Raster    Close Browser

*** Keywords ***
Clean Up Vector
    Delete Datastore    ${VECTOR_DS_NAME}
    Delete Style        ${VECTOR_STYLE_NAME}
    
Clean Up Raster
    Delete Datastore    ${RASTER_DS_NAME}
    Delete Style        ${RASTER_STYLE_NAME}