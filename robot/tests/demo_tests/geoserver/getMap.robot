*** Settings ***
Documentation       WMS Get Map test with image comparison
...
Resource            resource.robot
Test Teardown       Run Keyword If Test Failed      Log    Image coudn't be found, does the layer exist?

*** Test Case ***
Get Map
    [tags]      functional
    ${img}      WMS Get Map     layernames=opengeo:countries
    Images Should Be Equal       /home/ec2-user/test_data/opengeo-countries.png  ${img}
