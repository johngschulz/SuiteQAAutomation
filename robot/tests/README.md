# Robot Framework Tests

  All the files required to run the Suite tests are located in this directory. 
  The environment files contain the Robot configuration needed for local test development or the AWS automated configuration.
  The `AllRobotTests` script will run the full test suite on all four target browsers (Firefox, Chrome, IE, and Edge) and upload the test results to the NGINX server, when run on AWS.

  **Directory Structure**  
  The tests directory is organized by application. All tests for each application are contained in the `.robot` files within each directory, along with any custom test/keyword libraries.
  
## Test Environment

  There are two options for creating and debugging tests on your local machine.
   - [Preferred] Use one of the vagrant [Suite](https://github.com/boundlessgeo/boundless-devops/tree/master/suite-test-boxes) test boxes. This requires installing Robot Framework on your local machine and creating a `~/test-data/` folder as per the vagrant instructions. The test-data folder should contain all the data needed for your new test. If running existing tests the [data](https://github.com/boundlessgeo/SuiteQAAutomation/tree/master/infrastructure/ansible/roles/test_data) from the test_data role should be copied into the `~/test_data/`.
  - Use the [Win10](https://boundlessgeo.egnyte.com/SimpleUI/home.do#Files/0/Shared/Software/Virtual%20Machines/Win%2010%20VMs) VM, this requires copying the test files and data into the VM and installing Robot Framework and all libraries. 
  
  Then use `pip install -r requirements.txt` to install all the required libraries on the Windows VM or on your own machine if using the vagrant boxes. **Note:** You may need to do `pip install robotframework` first.
  
  To run the tests locally edit the `environment.robot` file so that it uses `environment_local.robot`. 
  For AWS this should be set to `environment_ansible.robot`.

## Writing Tests
  
  Robot Framework is a keyword based testing framework, we mainly use the Selenium2Library to control the targeted web browsers. The Robot [quickstart example] (https://github.com/robotframework/QuickStartGuide/blob/master/QuickStart.rst) provides a great overview of writing tests. The tests in `demo_tests/geoserver/` are good examples of how we use Robot to test GeoServer. Many common GeoServer actions (ie. datastore creation) have existing keywords that you can call from [geoserver/resource.robot](https://github.com/boundlessgeo/SuiteQAAutomation/blob/master/robot/tests/demo_tests/geoserver/resource.robot).
  The general process for writing tests is as follows:
  
  1. Vagrant up one of the suite-test-boxes.
  2. Ssh into the vagrant box and ensure the necessary data for tests is in the GeoServer data directory in a folder called `data`.
  3. Set the robot tests to run locally as described below.
  4. It is advised to use an existing test as a template to get started.
  5. Write the test and run it as necessary to confirm how it works. (See run particular test below)
  6. Once the test is complete commit it to the repository and follow `Adding Tests to AWS`
  
## Running Tests Locally
  
  Running tests only locally requires modifying environment.robot as described above. Though you may need to edit (environment_local.robot)(https://github.com/boundlessgeo/SuiteQAAutomation/blob/master/robot/tests/environment_local.robot) to point to the location of the test data on your machine.
  
  To run the full test suite (single browser)
  `robot demo_tests/`  
  
  To run the full test suite (all browsers: FireFox, Chrome, IE, and Edge)
  `./run_tests.sh`
  
  To run tests for a particular application  
  `robot demo_tests/geoserver`  
  
  To run a particular test for a application  
  `robot demo_tests/geoserver/login.robot`
  
## Running Tests Against a VM

  1. Setup VM as per Suite docs.
  2. Add the *test_data* folder to the VM as a shared folder. (https://github.com/boundlessgeo/SuiteQAAutomation/tree/master/infrastructure/ansible/roles/test_data)
  3. Inside the Geoserver data directory create a folder named *data* with full read/write permissions.
  4. Copy all the test data to the *data* folder and ensure all test files have full read/write permissions.
  5. Install the following extensions: netcdf, grib, mbtiles, vectortiles, gdal, mrsid, jp2k, and geopkg
  6. Restart GeoServer
  7. If testing a VM on a different computer you will need the private IP of the target computer.
  6. Several IP's will need to be updated in the tests:
      - GDALImport.robot :: change SERVER to 0.0.0.0:8080 (or the private IP)
      - database/resource.robot :: change DB_SERVER_IP to 0.0.0.0 (or the private IP)
      - environment_local.robot :: change SERVER to 0.0.0.0:8080 (or the private IP)

## AWS Scripts

  See the infrastructure [README](https://github.com/boundlessgeo/SuiteQAAutomation/blob/master/infrastructure/ansible/README.md) for complete instructions on deploying, provision, and running the tests on AWs.
  
  There are two scripts that are called to run tests on the AWS infrastructure, **AllRobotTests** and **RunSingleTest**. 
  
  The **AllRobotTests** script is called by the Ansible play [run\_tests.yml] (https://github.com/boundlessgeo/SuiteQAAutomation/blob/master/infrastructure/ansible/run_tests.yml) but can be called manually as well. The script will run the full test suite against all browsers (Chrome, FireFox, IE, and Edge) and against all GeoServer instances (Centos, RHEL, Ubuntu, Win2012). 
    Usage - _AllRobotTests machineKeyword machineIP ngnxIP_
  
  The **RunSingleTest** script is only used by the NGINX test results server to rerun particular tests (the purple button on the results grid). It can be used manually as well using:
    Usage - _RunSingleTest  machineKeyword machineIP testDirName browser ngnxIP_

## Adding tests to AWS machines

  1. Make sure any new tests have been committed to this repository
  2. If new Robot libraries or dependencies are required, update the ansible script at [hub/tasks/main.yml] (https://github.com/boundlessgeo/SuiteQAAutomation/blob/master/infrastructure/ansible/roles/hub/tasks/main.yml) to install the new libraries/dependencies for the tests
  3. New test data should be added to:
      1. For server side data (most data) add the data files to [infrastructure/ansible/roles/test\_data] (https://github.com/boundlessgeo/SuiteQAAutomation/tree/master/infrastructure/ansible/roles/test\_data) and update the **linux_data.yml** and **win_data.yml** as appropriate
        - To deploy the data run `ansible-playbook -i hosts/ install.yml --limit tag_type_ubuntu_gs` for each GeoServer host (ubuntu\_gs, centos_gs, win2012)
      2. Other data may need to be put in [infrastructure/ansible/roles/hub/files/test\_data] such as for REST uploads or the composer tests (https://github.com/boundlessgeo/SuiteQAAutomation/tree/master/infrastructure/ansible/roles/test_data), no changes to the `hub/tasks/main.yml` file should be necessary
        - Run `ansible-playbook -i hosts/ install.yml --limit tag_type_hub`, this will also deploy the new tests to the hub
  4. If there is no new test data required run `ansible-playbook -i hosts/ install.yml --limit tag_type_hub` to deploy tests.
  5. Run `ansible-playbook -i hosts/ install.yml --limit geoservers` to provision the test data to the geoserver instances.
  
## To Do:
  
  * update requirements.txt with recently added dependencies
  * Refactor all tests to reduce keyword redundancy
