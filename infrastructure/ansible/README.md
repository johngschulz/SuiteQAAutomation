Requirements:
  - Install ansible and boto with pip
  - Set env variables for AWS access/secret keys

To run scripts:

Provision AWS
ansible-playbook -i hosts deploy.yml
(hosts should default to localhost)

Configure the AWS instances
ansible-playbook -i hosts.yml install.yml

Notes:
Currently teardown of instances is manual. To do a fresh provisioning you must terminate all QA instances, release the EIP, and delete the subnet route tables.

To Do:
1) Automate discovery of instance IP's and set them in the hosts.yml file appropriately. Set global variables of IP's so other cfg's can update dynamically. (ie. the ssh config, nat/main.yml
2) Automate shutdown and termination of aws instances
3) Get windows ssh working
4) Run the robot demo tests on the full setup

