#!/bin/bash
sudo /home/Administrator/nssm.exe install SelNode \"C:\\Program Files\\Java\\jdk1.8.0_72\\bin\\java.exe\" "-jar C:\cygwin\home\Administrator\selenium-server-standalone-2.52.0.jar  -role webdriver -hub http://10.0.27.43:4444/grid/register -nodeConfig C:\\cygwin\\home\\Administrator\\files\\nodeConfig.json\"
