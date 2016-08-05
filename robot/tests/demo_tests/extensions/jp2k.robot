*** Settings ***
Documentation     JP2K  test
...
TestSetup         Open Browser To GeoServer
TestTeardown      Close Browser
Resource          ${CURDIR}/../geoserver/resource.robot

*** Variables ***
${JP2K_DS_NAME}        bogota_jp2_direct
${JP2K_URL}            file:data/bogota.jp2

*** Test Cases ***
JP2K Direct Extension
  Submit Geoserver Credentials
  Create Datastore  URL *   'JP2K (Direct) '   ${JP2K_DS_NAME}   ${JP2K_URL}
  Publish Layer   ${JP2K_DS_NAME}   bogota    srs=EPSG:21892

  ${img}    WMS Get Map   layernames=opengeo:bogota   srs=EPSG:21892    bbox=440720.0,69280.0,471440.0,100000.0   height=768  width=768
  Images Should Be Equal    ${TEST_DATA}opengeo-bogota.png    ${img}
