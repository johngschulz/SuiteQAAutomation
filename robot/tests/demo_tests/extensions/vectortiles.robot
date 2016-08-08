*** Settings ***
Documentation     Vector Tiles Tests
...
TestSetup
TestTeardown
Resource          ${CURDIR}/../geoserver/resource.robot

*** Variables ***
${VT_LAYERNAME}        bogota_jp2_direct

*** Test Cases ***
Vector Tile GeoJSON Test
        ${fileJson}             WMS Get Map   bbox=-180,-90,180,90   layernames=opengeo:countries  mimeType=application/json;type=geojson
        ${data}=   Evaluate  json.loads($fileJson)   modules=json
        Should Be Equal  ${data['type']}    FeatureCollection
        ${nfeatures}=    Evaluate   len($data['features'])
        Should Be Equal As Numbers   ${nfeatures}    239

Vector Tile MapBox Test
        ${fileJson}             WMS Get Map   bbox=-180,-90,180,90   layernames=opengeo:countries  mimeType=application/x-protobuf;type=mapbox-vector
        ${len}=    Evaluate   len($fileJson)
        Should be true   ${len}> 100000
        ${firstByte}=    Evaluate    ord($fileJson[0])
        log    ${firstByte}
        Should Be True   $firstByte == 26

