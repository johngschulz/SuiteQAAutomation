*** Settings ***
Documentation
...               Tests GeoServer WFS requests
Resource          resource.robot

*** Test Cases ***
WPS Aggregation
  ${resp}    WPS Request    ${TEST_DATA}    wps.xml
  Verify WPS Aggregation Request    ${resp}

*** Keywords ***
Verify WPS Aggregation Request
  [arguments]    ${xml}
  ${root}    ParseXML    ${xml}
  XML.Element Text Should Be    ${root}    52    .//Count
  XML.Element Text Should Be    ${root}    563626.0    .//Min
  XML.Element Text Should Be    ${root}    3.7253956E7    .//Max
  XML.Element Text Should Be    ${root}    3.12471327E8   .//Sum
  XML.Element Text Should Be    ${root}    6009063.980769231   .//Average
