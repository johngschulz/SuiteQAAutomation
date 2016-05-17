from robot.api import logger

class PostgresqlDDL:

    def execute_postgresql_ddl(self, dbapiModuleName=None, dbName=None, dbUsername=None, dbPassword=None, dbHost=None, dbPort=None, ddlCommand=None ):
        db_api_2 = __import__(dbapiModuleName)
        logger.debug ('Connecting using : %s.connect(database=%s, user=%s, password=%s, host=%s, port=%s) ' % (dbapiModuleName, dbName, dbUsername, dbPassword, dbHost, dbPort))

        try:
            dbconnection =  None
            dbconnection = db_api_2.connect (database=dbName, user=dbUsername, password=dbPassword, host=dbHost, port=dbPort)
            dbconnection.set_isolation_level(0)
            try:
                cursor = dbconnection.cursor()
                cursor.execute(ddlCommand)
            except Exception as e:
                print "*FAIL* ", e
                raise e
            finally:
                cursor.close()
        except Exception as e:
                print "*FAIL* ", e
                raise e
        finally:
             if dbconnection is not None:
                dbconnection.close()
