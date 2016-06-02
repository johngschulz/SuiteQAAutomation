*** Settings ***

Library           Selenium2Library      timeout=30
Resource          ../../environment.robot

Suite Setup          Open Browser To WPS Builder
Test Setup           Reset WPS Builder Page
Suite Teardown       Close Browser

** Settings **
Test Timeout    30 seconds

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
       #Drag And Drop    //*[@id='palette']//*[text()= '${processName}']      id=chart
        Drag to Canvas    ${processName}
       Page Should Contain Element    //*[local-name()="text" and contains(text(),'${processName}')]/..         could not move wps process "${processName}" to canvas

Drag to Canvas
         [arguments]    ${text}
         Run Keyword If   '${BROWSER}' != 'Chrome'      Drag And Drop    //*[@id='palette']//*[text()= '${text}']      id=chart
         Run Keyword If   '${BROWSER}' == 'Chrome'    Execute Javascript    $.ajax({async: false,url: "https://cdn.rawgit.com/j-ulrich/jquery-simulate-ext/master/libs/jquery.simulate.js",dataType: "script"}); $.ajax({async: false,url: "https://cdn.rawgit.com/j-ulrich/jquery-simulate-ext/master/src/jquery.simulate.ext.js",dataType: "script"});$.ajax({async: false,url: "https://cdn.rawgit.com/j-ulrich/jquery-simulate-ext/master/src/jquery.simulate.drag-n-drop.js",dataType: "script"});setTimeout(function() {  $("#palette div.palette_node:contains('${text}')").simulate("drag-n-drop", {dragTarget:$("#chart")[0]});} , 1000);


Set Features
         [arguments]     ${featureElementName}=features   ${layer}=aaa:bbbbbb
         #Click Element    //*[local-name()="text" and text()='${featureElementName}']/..
         Click SVG By Text     ${featureElementName}
         Set Select JQuery   \#map-input select      vector|${layer}

Click SVG By Text
        [arguments]    ${text}
        Run Keyword If   '${BROWSER}' == 'IE'      Execute Javascript   var elem = $("svg text:contains('${text}')").parent('g').children('rect')[0]; var event_up = document.createEvent("MouseEvent"); event_up.initMouseEvent("mouseup",true,true,window,0,0,0,0,0,false,false,false,false,0,null); var event_down= document.createEvent("MouseEvent"); event_down.initMouseEvent("mousedown",true,true,window,0,0,0,0,0,false,false,false,false,0,null); elem.dispatchEvent(event_down); elem.dispatchEvent(event_up);
        Run Keyword If   '${BROWSER}' != 'IE'     Click Element    //*[local-name()="text" and text()='${text}']/..

Set Select JQuery
        [arguments]  ${docSelector}   ${value}
        Execute Javascript   $("${docSelector}").val("${value}");  $("${docSelector}").change();

Set WPS Geom WKT
       [arguments]     ${geomElementName}=geom   ${wkt}=POLYGON((0 0,1 0, 1 1, 0 1, 0 0))
       #Click Element    //*[local-name()="text" and text()='${geomElementName}']/..
        Click SVG By Text   ${geomElementName}
       Click Element    //a[text()='via Text']
       Click Element     //input[@type='text' and @placeholder="WKT or GML"]
       Input Text        //input[@type='text' and @placeholder="WKT or GML"]      POLYGON((0 0,10 0, 10 10, 0 10, 0 0))

Run WPS Process
         Click Element    //*[@id='btn-run-process']
                                                          

    
