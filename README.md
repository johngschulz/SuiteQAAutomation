# SuiteQAAutomation
  
  This repository contains all the Ansible scripts and Robot Framework tests used to automate testing of Boundless Suite
  
## Infrastructure
  
  The *infrastructure/ansible* directory contains the Ansible playbooks to deploy and provision the AWS instances that will run the automated tests. Any test data files necessary for the Robot tests are kept in the `roles/role_name/files` directory. 
  
 **AWS Instances**
 * NAT (AWS Linux - NAT) - Provides public IP to connect to QA instances
 * Hub (AWS Linux) - Runs the Selenium Grid hub and the Robot Framework tests
 * Windows node (Win10) - Runs the Selenium Grid node and has the browsers to be tested (Chrome,Firefox,IE,Edge)
 * Windows Suite WAR (Win2012) - Runs the Suite WAR install that the node will run browser tests against
 * Ubuntu Suite Install (Ubuntu 14.04) - Runs the Suite install that the node will run browser tests against
 * NGINX (Ubuntu 14.04) - Serves up the test results, authentication required 

## Robot Framework Tests 

  The *robot* directory contains the all the tests that will be run against Suite installs. It also contains the files used to serve the test results on the NGINX server, and a patch for the Robot Selenium2 library to add support for the Edge broswer.
  
## Selenium

  This directory contains the currently used versions of the webdrivers and the standalone Selenium Server. These files are used on the *Windows Node* instance. 
