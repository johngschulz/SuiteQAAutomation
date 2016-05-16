*** Settings ***
Library     ImageLibrary.py


*** Test Case ***
Simple Image Test
    ${data} =  Read File Bytes    ${TEST_DATA}opengeo-countries.png
    Images Should Be Equal   ${TEST_DATA}opengeo-countries.png     ${data}
