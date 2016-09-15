sh ./AllRobotTests centos {{ centos_gs_ip }} {{ nginx_ip }}
sh ./AllRobotTests RHEL {{ rhel_gs_ip }} {{ nginx_ip }}
sh ./AllRobotTests ubuntu {{ ubuntu_gs_ip }} {{ nginx_ip }}
sh ./AllRobotTests win2012 {{ win2012_gs_ip }} {{ nginx_ip }}
