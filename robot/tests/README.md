# Robot Framework Tests

  All the files required to run the Suite tests are located in this directory. 
  The environment files contain the Robot configuration needed for local test development or the AWS automated configuration.
  The `AllRobotTests` script will run the full test suite on all four target browers (Firefox, Chrome, IE, and Edge) and upload the test results to the NGINX server.

  **Directory Structure**  
  The tests directory is organized by application. All tests for each application are contained in the `.robot` files within each directory, along with any custom test/keyword libraries.
  
## Test Environment

  There are two options for creating and debugging tests on your local machine.
  - Use the [Win10](https://boundlessgeo.egnyte.com/SimpleUI/home.do#Files/0/Shared/Software/Virtual%20Machines/Win%2010%20VMs) VM, this requires copying the test files and data into the VM and installing Robot Framework and all libraries.
  - Or use one of the vagrant [Suite](https://github.com/boundlessgeo/boundless-devops/tree/master/suite-test-boxes) test boxes. This requires installing Robot Framework and dependencies on your local machine. 
  
  Then use `pip install -r requirements.txt` to install all the required libraries on the Windows VM or on your own machine if using the vagrant boxes. **Note:** You may need to do `pip install robotframework` first.
  
  To run the tests locally edit the `environment.robot` file so that it uses `environment_local.robot`. 
  For AWS this should be set to `environment_ansible.robot`.

## Writing Tests
  
  Robot Framework is a keyword based testing framework, we mainly use the Selenium2Library to control the targeted web browsers. The Robot [quickstart example] (https://github.com/robotframework/QuickStartGuide/blob/master/QuickStart.rst) provides a great overview of writing tests. The tests in `demo_tests/geoserver/` are good, fairly simple, examples of how we use Robot to test GeoServer.
  
## Running Tests Locally
  
  To run a test suite (single browser)
  `robot demo_tests/`  
  
  To run tests for a particular application  
  `robot demo_tests/geoserver`  
  
  To run a particular test for a application  
  `robot demo_tests/geoserver/login.robot`
  
## Running Tests on AWS

  There are two scripts that are called to run tests on the AWS infrastructure, **AllRobotTests** and **RunSingleTest**. 
  
  The **AllRobotTests** script is called by the Ansible play [run\_tests.yml] (https://github.com/boundlessgeo/SuiteQAAutomation/blob/master/infrastructure/ansible/run_tests.yml) but can be called manually as well. The script will run the full test suite against all browsers (Chrome, FireFox, IE, and Edge) and against all GeoServer instances (Centos, Ubuntu, Win2012). 
    Usage - _AllRobotTests machineKeyword machineIP ngnxIP_
  
  The **RunSingleTest** script is only used by the NGINX test results server to rerun particular tests (the purple button on the results grid). It can be used manually as well using:
    Usage - _RunSingleTest  machineKeyword machineIP testDirName browser ngnxIP_

## Adding tests to AWS machines

  1. Make sure any new tests have been committed to this repository
  2. If new Robot libraries or dependencies are required, update the ansible script at [hub/tasks/main.yml] (https://github.com/boundlessgeo/SuiteQAAutomation/blob/master/infrastructure/ansible/roles/hub/tasks/main.yml) to install the new libraries/dependencies for the tests
  3. New test data should be added to:
      1. For server side data (such as netcdf or OGR files) add the data files to [infrastructure/ansible/roles/test\_data] (https://github.com/boundlessgeo/SuiteQAAutomation/tree/master/infrastructure/ansible/roles/test\_data) and update the **linux_data.yml** and **win_data.yml** as appropriate
        - To deploy the data run `ansible-playbook -i hosts/ install.yml --limit tag_type_ubuntu_gs` for each GeoServer host (ubuntu\_gs, centos_gs, win2012)
      2. All other data should be put in [infrastructure/ansible/roles/hub/files/test\_data] (https://github.com/boundlessgeo/SuiteQAAutomation/tree/master/infrastructure/ansible/roles/test_data), no changes to the `hub/tasks/main.yml` file should be necessary
        - Run `ansible-playbook -i hosts/ install.yml --limit tag_type_hub`, this will also deploy the new tests to the hub
  4. If there is no new test data required run `ansible-playbook -i hosts/ install.yml --limit tag_type_hub` to deploy tests.
  
## To Do:
  
  * update requirements.txt with recently added dependencies
  * how to write robot test
  * Refactor to make adding/updating tests and data easier (changes on ansible side)
  * Refactor all tests to reduce keyword redundancy
