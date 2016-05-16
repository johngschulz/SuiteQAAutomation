*** Settings ***
Documentation     Environment settings for local testing

*** Variables ***
${BROWSER}        firefox
${SERVER}         localhost:8080
${REMOTE_URL}
${TEST DATA}      ${CURDIR}\\..\\..\\infrastructure\\ansible\\roles\\hub\\files\\test_data\\
