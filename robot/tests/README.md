# Robot Framework Tests

  All the files required to run the Suite tests are located in this directory. 
  The environment files contain the Robot configuration needed for local test development or the AWS automated configuration.
  The `AllRobotTests` script will run the full test suite on all four target browers (Firefox, Chrome, IE, and Edge) and upload the test results to the NGINX server.

  **Directory Structure**  
  The tests directory is organized by application. All tests for each application are contained in the `.robot` files within each directory, along with any custom test/keyword libraries.
  
## Test Environment

  For creating and debugging tests on you local machine, use the [Win10](https://boundlessgeo.egnyte.com/SimpleUI/home.do#Files/0/Shared/Software/Virtual%20Machines/Win%2010%20VMs) VM
  and use `pip install -r requirements.txt` to install all the required libraries. **Note:** You may need to do `pip install robotframework` if there are issues with some of the libraries.
  
  To run the tests locally edit the `environment.robot` file so that it uses `environment_local.robot`. 
  For AWS this should be set to `environment_ansible.robot`.
  
## Running Tests
  
  To run the full test suite   
  `robot demo_tests/`  
  
  To run tests for a particular application  
  `robot demo_tests/geoserver`  
  
  To run a set of tests for a particular application  
  `robot demo_tests/geoserver/login.robot`
  
## To Do:
  
  * update requirements.txt with recently added dependencies
  * how to write robot test
  * how/what to update AWS machines with new tests (ie. dependencies)
