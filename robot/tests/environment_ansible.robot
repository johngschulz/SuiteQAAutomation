*** Settings ***
Documentation     Environment settings for ansible VM

*** Variables ***
${BROWSER}        firefox
${SUT_IP}         10.0.17.176
${SERVER}         ${SUT_IP}:8080
${REMOTE_URL}     http://10.0.28.72:4444/wd/hub
${TEST_DATA}      /home/ec2-user/test_data/
