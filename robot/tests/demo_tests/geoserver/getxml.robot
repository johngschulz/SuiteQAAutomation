*** Settings ***
Documentation     A test suite to test the links to service capabilites
...               and validate that the XML doesn't throw an exception
...
...
Force Tags        smoke     non-critical
Test Template     Validate Service Capabilities
Library           XML
Library           HttpLibrary.HTTP
Resource          resource.robot
Variables         variables.py

*** Test Case ***    URI            TITLE
WCS100               ${WCS100u}      ${WCS100}
WCS110               ${WCS110}      ${WCS}
WCS111               ${WCS111}      ${WCS}
WCS11                ${WCS11}       ${WCS}
WCS201               ${WCS201}      ${WCS}
WFS100               ${WFS100}      ${WFS}
WFS110               ${WFS110}      ${WFS}
WFS200               ${WFS200}      ${WFS}
WMS111               ${WMS111u}      ${WMS111}
WMS130               ${WMS130u}      ${WMS130}

*** Comment ***
these return 400 bad request, tms loads xml in browser, WMS-C and WMTS download an xml
    - how to download the xml?
TMS                  ${TMSurl}      ${TMS}
WMS-C                ${WMSCurl}     ${WMSC}
WMTS                 ${WMTSurl}        ${WMTS}

*** Keywords ***
Validate Service Capabilities
    [arguments]    ${uri}    ${title}
    Create Http Context    ${SERVER}    http
    HttpLibrary.HTTP.Get   /geoserver/${uri}
    Response Status Code Should Equal     200
    ${body}    Get Response Body
    Response Body Should Contain    <?xml version="1.0" encoding="UTF-8"?>
    ${root}    Parse Xml    ${body}
    Log    ${root.tag}
    Should Be Equal   ${root.tag}    ${title}


