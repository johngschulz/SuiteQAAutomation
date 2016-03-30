*** Settings ***
Library     ImageLibrary.py


*** Test Case ***
Simple Image Test
    ${data} =  Read File Bytes    /home/ec2-user/test_data/opengeo-countries.png
    Images Should Be Equal   /home/ec2-user/test_data/opengeo-countries.png     ${data}

 
