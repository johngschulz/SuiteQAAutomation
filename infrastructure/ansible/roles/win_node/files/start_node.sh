#!/bin/bash
java -jar selenium-server-standalone-2.52.0.jar -role webdriver -hub http://10.0.217.57:32768/grid/register -browser browserName=firefox,maxInstances=1,platform=WINDOWS -browser browserName=chrome,maxInstances=1,platform=WINDOWS -browser browserName=MicrosoftEdge,maxInstances=1,platform=WINDOWS -browser browserName="internet explorer",maxInstances=1,platform=WINDOWS  -Dwebdriver.ie.driver="C:\source\Microsoft Web Driver\IEDriverServer x32 - 2.49b.exe" -Dwebdriver.chrome.driver="C:\source\Microsoft Web Driver\chromedriver - 2.20.exe" -Dwebdriver.edge.driver="C:\source\Microsoft Web Driver\MicrosoftWebDriver - 2.0.exe"
