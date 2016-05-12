 cd C:\cygwin\home\Administrator\

 call java -jar "selenium-server-standalone-2.52.0.jar" -role webdriver -hub http://10.0.0.185:4444/grid/register -Dwebdriver.ie.driver="C:/source/IEDriverServer.exe" -DWebdriver.chrome.driver="C:/source/chromedriver.exe" -Dwebdriver.edge.driver="C:/source/MicrosoftWebDriver.exe" -nodeConfig C:\\cygwin\\home\\Administrator\\nodeConfig.json
