*** Settings ***

Library           Selenium2Library
Resource          ../../environment.robot

Suite Setup          Open Browser To WPS Builder
Test Setup           Reset WPS Builder Page
Suite Teardown       Close Browser

*** Variables ***
${WPSBUILDER_URL}   http://${SERVER}/wpsbuilder


# POLYGON((0 0,10 0, 10 10, 0 10, 0 0))
*** Test Cases ***
Simple Geometry Process Test
       Move WPS Process to Canvas    area
       Set WPS Geom WKT     wkt=POLYGON((0 0,10 0, 10 10, 0 10, 0 0))
       Run WPS Process
       Wait Until Element Contains    //*[@id='tab-results']    100.0   20 seconds    Process did not finish with value 100.0

Simple Feature Collection Process Test
        Move WPS Process to Canvas    Count
        Set Features       layer=opengeo:countries
        Run WPS Process
        Wait Until Element Contains    //*[@id='tab-results']    241   20 seconds    Process did not finish with value 241

*** Keywords ***
Open Browser To WPS Builder
    Set Selenium Timeout     10 seconds
    Set Selenium Implicit Wait     10 seconds
    Open Browser  ${WPSBUILDER_URL}   ${BROWSER}    None    ${REMOTE_URL}
    Set Selenium Speed      .2
    Title Should Be    WPS Process Builder


Reset WPS Builder Page
    Click Element     id=btn-clear


Move WPS Process to Canvas
       [arguments]     ${processName}
       Page Should Contain Element  //*[@id='palette']//*[text()= '${processName}']     could not find wps process "${processName}"
       Drag And Drop    //*[@id='palette']//*[text()= '${processName}']      id=chart
       Page Should Contain Element    //*[local-name()="text" and contains(text(),'${processName}')]/..         could not move wps process "${processName}" to canvas

Set Features
         [arguments]     ${featureElementName}=features   ${layer}=aaa:bbbbbb
         Click Element    //*[local-name()="text" and text()='${featureElementName}']/..
         Select From List By Label    //*[@id='map-input']/select   ${layer}

Set WPS Geom WKT
       [arguments]     ${geomElementName}=geom   ${wkt}=POLYGON((0 0,1 0, 1 1, 0 1, 0 0))
       Click Element    //*[local-name()="text" and text()='${geomElementName}']/..
       Click Element    //a[text()='via Text']
       Click Element     //input[@type='text' and @placeholder="WKT or GML"]
       Input Text        //input[@type='text' and @placeholder="WKT or GML"]      POLYGON((0 0,10 0, 10 10, 0 10, 0 0))

Run WPS Process
         Click Element    //*[@id='btn-run-process']
