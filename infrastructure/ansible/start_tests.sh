#!/bin/bash
#cd "~/SuiteQAAutomation/infrastructure/ansible"

ansible-playbook -i hosts/ deploy.yml

./hosts/ec2.py --refresh-cache
sleep 5

ansible-playbook -i hosts/ setup_keys.yml

ansible-playbook -i hosts/ install.yml -vv

sleep 5

ansible-playbook -i hosts/ run_tests.yml