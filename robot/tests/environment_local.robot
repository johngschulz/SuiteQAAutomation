*** Settings ***
Documentation     Environment settings for local testing

*** Variables ***
${BROWSER}        firefox
${SERVER}         localhost:8080
${REMOTE_URL}
${TEST DATA}      ${CURDIR}/../../infrastructure/ansible/roles/win_2012/files/test_data/
