*** Settings ***
Library     ImageLibrary.py


*** Test Case ***
Simple Image Test
    ${data} =  Read File Bytes  C:\\Users\\boundless\\workspace\\Geoserver_robot\\demo_tests\\data\\topp-countries2.png
    Images Should Be Equal    C:\\Users\\boundless\\workspace\\Geoserver_robot\\demo_tests\\data\\topp-countries2.png    ${data}

 