*** Settings ***
Documentation
...               Tests GeoServer WFS requests
Resource          resource.robot

*** Test Case ***
WFS BBOX Request
  ${resp}    WFS Get Feature By BBOX   usa   states    -164.26757,10.634765,-146.513672,28.3886719
  Log   ${resp}
  Verify WFS BBOX    ${resp}

WFS Property Request
  ${resp}    WFS Get Feature By Property    usa    states    STATE_NAME
  Verify WFS Property    ${resp}

*** Keywords ***
Verify WFS Property
  [arguments]    ${xml}
  ${root}    Parse XML    ${xml}
  ${count}    Get Element Count    ${root}   */STATE_NAME
  Should Be Equal As Integers   ${count}    52

Verify WFS BBOX
  [arguments]    ${xml}
  ${root}    Parse XML    ${xml}
  ${text}    Get Element Text    ${root}    .//STATE_NAME
  Should Be Equal    ${text}    Hawaii