*** Settings ***
Library     ImageLibrary.py


*** Test Case ***
Simple Image Test
    ${data} =  Read File Bytes    C:\\robot\\SuiteQAAutomation\\infrastructure\\ansible\\roles\\hub\\files\\test_data\\opengeo-countries.png
    Images Should Be Equal   C:\\robot\\SuiteQAAutomation\\infrastructure\\ansible\\roles\\hub\\files\\test_data\\opengeo-countries.png     ${data}

 
