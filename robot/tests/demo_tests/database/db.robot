***Settings***
Library  DatabaseLibrary
Library  PostgresqlDDL.py


Resource          ${CURDIR}/resource.robot


*** Variables ***
${DB_SERVER_IP}             localhost
${DB_USER}                  postgres
${DB_PASS}                  postgres
${DB_PORT}                  5432
${DB_POSTGIS_TMP_DB_NAME}   robot_postgis_test
${DB_PCLOUD_TMP_DB_NAME}    robot_pcloud_test

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

Validate PointCloud 
    [Documentation]    Verfies Pointcloud reported version
    [Setup]    Run Keywords    Create Temp PCloud Database    Connect to Temp PCloud Database
    Validate PCloud Version Number
    Verify PointCloud Working
    [Teardown]  Run Keywords     Disconnect From Database   Drop Temp PCloud Database
 
