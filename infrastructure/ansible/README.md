
# Ansible Scripts
  
  All the AWS instances need for automated testing of Suite are deployed and provisioned using [Ansible](http://docs.ansible.com/ansible/playbooks.html)  
  The the AWS instances as provisioned based on the `main.yml` file in the tasks folder of each ansible role. The AWS role is only used to do the initial deployment of the AWS instances. All the other roles provision those instances as described below. Each role can have subfolders for `files` and `vars` specific to that role.  
  
## AWS Instances  
  
* **NAT (AWS Linux - NAT)** - Provides public IP to connect to QA instances  
* **Hub (AWS Linux)** - Runs the Selenium Grid hub and the Robot Framework tests  
  * *files/* - put files that the Robot tests will expect here, such as the *opengeo-countries* image used to test `getmap` functionality  
* **Windows node (Win10)** - Runs the Selenium Grid node and has the browsers to be tested (Chrome,Firefox,IE,Edge)  
  * *files/* - cygwin and node configuration files, and the script to start a Selenium node, to be executed on startup
* **Windows Suite WAR (Win2012)** - Runs the Suite WAR install that the node will run browser tests against  
    * *files/test_data* - put all test data files that will be uploaded to GeoServer as part of testing
    * *files/* - files required to setup the Tomcat WAR install of Suite, including data directory, (`install.sh` is called by ansible to do the setup)
* **Ubuntu Suite Install (Ubuntu 14.04)** - Runs the Suite install that the node will run browser tests against  
* **NGINX (Ubuntu 14.04)** - Serves up the test results, authentication required 
  
## Requirements:

  * Install ansible and boto with pip
  * Set local environment variables for AWS access/secret keys
  * Add the suite-qa key to your ssh agent

## Runnning scripts:

**Deploy, Provision, & Run Full Test Suite**
  `./start_tests.sh`

**Deploy AWS Instances :**  
  `ansible-playbook -i hosts deploy.yml`  
  (hosts should default to localhost)

**Provision the AWS instances :**  
  `ansible-playbook -i hosts/ install.yml`
  
**Provision specific instances/roles :**  
 `ansible-playbook -i hosts/ install.yml --limit tag_type_win2012`

**Terminate Instances**

  Terminate GeoServer instances and hub:
  `ansible-playbook -i hosts/ terminate.yml --limit tag_type_test_runners`
  
  Terminate a particular instance:
  `ansible-playbook -i hosts/ terminate.yml --limit tag_type_centos_gs`

### Notes:
  * You can limit a playbook to a specific role (as above) or group (see hosts/hosts.yml file for groups, ie. test_runners)
  * Currently a complete teardown of instances requires some manual steps. This includes terminating all QA instances (can use the terminate.yml script), release the EIP, and delete the subnet route tables. 
  * All instances should be tagged with QA.

## To Do:
* Automate shutdown and termination of aws instances
  * Shutdown all instances, except NAT and NGINX
  * Figure out where Ansible will be run from
  * Hook up to build system
