***Settings***
Library  DatabaseLibrary
Library  PostgresqlDDL.py


Resource          ${CURDIR}/resource.robot


*** Variables ***
 

***Testcases***

Validate Postgresql
    [Setup]     Connect to Generic Postgresql Database
    Validate Postgresql Version
    [Teardown]  Disconnect From Database

Validate PostGIS 
    [Documentation]    Verfies postgis reported version (creates a database, installs postgis, verifies, drops database)
    [Setup]    Run Keywords    Create Temp Postgis Database    Connect to Temp Postgis Database
    Validate PostGIS Version Numbers
    Verify PostGIS Working
    [Teardown]  Run Keywords     Disconnect From Database   Drop Temp Postgis Database
