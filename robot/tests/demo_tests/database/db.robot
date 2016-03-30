***Settings***
Library  DatabaseLibrary
Library  PostgresqlDDL


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
 


*** Keywords ***
Create Temp Postgis Database
      Execute Postgresql Ddl        psycopg2  template1    ${DB_USER}   ${DB_PASS}  ${DB_SERVER_IP}   ${DB_PORT}   CREATE DATABASE ${DB_POSTGIS_TMP_DB_NAME}
      Execute Postgresql Ddl        psycopg2  ${DB_POSTGIS_TMP_DB_NAME}  ${DB_USER}   ${DB_PASS}  ${DB_SERVER_IP}   ${DB_PORT}   CREATE EXTENSION postgis


Drop Temp Postgis Database
        Execute Postgresql Ddl      psycopg2  template1    ${DB_USER}   ${DB_PASS}  ${DB_SERVER_IP}   ${DB_PORT}  DROP DATABASE ${DB_POSTGIS_TMP_DB_NAME}

Connect to Temp Postgis Database
        Connect To Database         psycopg2  ${DB_POSTGIS_TMP_DB_NAME}  ${DB_USER}   ${DB_PASS}  ${DB_SERVER_IP}   ${DB_PORT} 

Create Temp PCloud Database
      Execute Postgresql Ddl        psycopg2  template1    ${DB_USER}   ${DB_PASS}  ${DB_SERVER_IP}   ${DB_PORT}   CREATE DATABASE ${DB_PCLOUD_TMP_DB_NAME}
      Execute Postgresql Ddl        psycopg2  ${DB_PCLOUD_TMP_DB_NAME}  ${DB_USER}   ${DB_PASS}  ${DB_SERVER_IP}   ${DB_PORT}   CREATE EXTENSION pointcloud


Drop Temp PCloud Database
        Execute Postgresql Ddl      psycopg2  template1    ${DB_USER}   ${DB_PASS}  ${DB_SERVER_IP}   ${DB_PORT}  DROP DATABASE ${DB_PCLOUD_TMP_DB_NAME}

Connect to Temp PCloud Database
        Connect To Database         psycopg2  ${DB_PCLOUD_TMP_DB_NAME}  ${DB_USER}   ${DB_PASS}  ${DB_SERVER_IP}   ${DB_PORT} 




Connect to Generic Postgresql Database
        Connect To Database         psycopg2  template1  ${DB_USER}   ${DB_PASS}  ${DB_SERVER_IP}   ${DB_PORT} 


Check Postgis Lib Version
    @{queryResults}    Query        SELECT postgis_lib_version()
    Should Be Equal     ${queryResults[0][0]}    2.1.7    Incorrect Postgis version


Check Postgis GEOS Version
    @{queryResults}    Query        SELECT postgis_GEOS_version()
    Should Start With     ${queryResults[0][0]}    3.4.2    Incorrect GEOS version    

Check Postgis PROJ Version
    @{queryResults}    Query        SELECT postgis_PROJ_version()
    Should Start With     ${queryResults[0][0]}    Rel. 4.8.0    Incorrect PROJ version  

Check Postgis GDAL Version
    @{queryResults}    Query        SELECT postgis_GDAL_version()
    Should Start With     ${queryResults[0][0]}    GDAL 1.11.1   Incorrect GDAL version  

Validate PostGIS Version Numbers
    Check Postgis Lib Version 
    Check Postgis GEOS Version 
    Check Postgis PROJ Version
    Check Postgis GDAL Version

Verify PostGIS Working
    [Documentation]  Query from SUITE-672
     @{queryResults}    Query        SELECT st_astext( st_geomfromgeojson( st_asgeojson( st_geomfromgml( st_asgml( st_buffer( st_transform( st_transform( 'SRID=4326;POINT(0 0)'::geometry, 3857), 4326), 10))))))
     Should Start With     ${queryResults[0][0]}    POLYGON((10 0,9.80785280403231 -1.95090322016128,    PostGIS Query failed


Validate Postgresql Version
    @{queryResults}    Query        SELECT version()
    Should Start With     ${queryResults[0][0]}    PostgreSQL 9.3.5    Incorrect PostgreSQL version 

Validate PCloud Version Number
     @{queryResults}    Query        SELECT pc_version()
    Should Be Equal     ${queryResults[0][0]}    1.0.1    Incorrect PointCloud version 

Verify PointCloud Working
    Execute Sql Script    pointcloud_schema.sql  
     @{queryResults}    Query        SELECT PC_MakePoint(1, ARRAY[-127, 45, 124.0, 4.0]);
    Should Be Equal     ${queryResults[0][0]}  010100000064CEFFFF94110000703000000400    Incorrect PointCloud response