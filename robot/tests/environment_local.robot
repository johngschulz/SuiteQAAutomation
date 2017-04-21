*** Settings ***
Documentation     Environment settings for local testing

*** Variables ***
${BROWSER}        firefox
${SUT_IP}         localhost
${SERVER}         localhost:8080
${HOST}           Unix
${REMOTE_URL}
${TEST DATA}      ${CURDIR}/../../infrastructure/ansible/roles/hub/files/test_data/
#${TEST DATA}      ${CURDIR}\\..\\..\\infrastructure\\ansible\\roles\\hub\\files\\test_data\\
