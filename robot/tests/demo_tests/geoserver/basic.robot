*** Settings ***
Resource          resource.robot

Test Setup          Open Browser To GeoServer
Test Teardown       Close Browser

*** Test Cases ***
Valid Login    
    Submit Geoserver Credentials
    Welcome Page Should Be Open

Check for strong crypto
    Submit Geoserver Credentials
    Page Should Not Contain     No strong cryptography available
    Page Should Contain         Strong cryptography available

Check for Marlin renderer
    Submit Geoserver Credentials
    Go To   ${REST URL}/about/status
    Page Should Contain     Provider: Marlin

Check for LibJPEG-turbo
    Submit Geoserver Credentials
    Go To   ${REST URL}/about/status
    Page Should Contain     GeoServer libjpeg-turbo Module
    Page Should Not Contain      JNI LibJPEGTurbo Wrapper Version: unavailable
