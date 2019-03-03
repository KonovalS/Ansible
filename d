[33mcommit c5ff3e1fe20f4005ef2f8203d9481a0068c9982e[m
Author: KonovalS <boprak@gmail.com>
Date:   Sun Mar 3 13:45:19 2019 +0300

    write config_apache, defaults, var, templates

[1mdiff --git a/roles/ansible-apache2/defaults/main.yml b/roles/ansible-apache2/defaults/main.yml[m
[1mindex ed97d53..16064d7 100644[m
[1m--- a/roles/ansible-apache2/defaults/main.yml[m
[1m+++ b/roles/ansible-apache2/defaults/main.yml[m
[36m@@ -1 +1,40 @@[m
 ---[m
[32m+[m[32m#defailt apache2 role[m
[32m+[m
[32m+[m[32m#Apache2 shuld config[m
[32m+[m[32mapache2_config: true[m
[32m+[m
[32m+[m[32m#Php chuld be config[m
[32m+[m[32mapache2_config_php: false[m
[32m+[m
[32m+[m[32mapache2_default_port: 80[m
[32m+[m
[32m+[m[32m#PHP shuld be install[m
[32m+[m[32mapache2_php_install: false[m
[32m+[m
[32m+[m[32mapache2_server_admin: 'webadmin@localhost'[m
[32m+[m
[32m+[m[32m#add custome vitrual VirtualHost[m
[32m+[m[32mapache2_vhost_add: true[m
[32m+[m
[32m+[m[32mapache2_virtualhosts:[m
[32m+[m[32m  - documentroot: '/var/www/dev.local'[m
[32m+[m[32m    port: 80[m
[32m+[m[32m    serveradmin: '{{ apache2_server_admin }}'[m
[32m+[m[32m    servername: "dev.local"[m
[32m+[m[32m  #[m
[32m+[m[32m  #[m
[32m+[m[32m  #[m
[32m+[m[32m  #[m
[32m+[m[32m  #[m
[32m+[m[32m  #[m
[32m+[m[32m  #[m
[32m+[m[32m  #[m
[32m+[m[32m  #[m
[32m+[m[32m  #[m
[32m+[m[32m  #[m
[32m+[m[32m  #[m
[32m+[m[32m  #[m
[32m+[m[32m  #[m
[32m+[m[32m  #[m
[32m+[m[32m  #[m
[1mdiff --git a/roles/ansible-apache2/tasks/config_apache2.yml b/roles/ansible-apache2/tasks/config_apache2.yml[m
[1mindex 47ce195..a0044dd 100644[m
[1m--- a/roles/ansible-apache2/tasks/config_apache2.yml[m
[1m+++ b/roles/ansible-apache2/tasks/config_apache2.yml[m
[36m@@ -1,15 +1,23 @@[m
 ---[m
[31m-  - namme:[m
   - name: config_apache2 | create apache2 logs folder[m
     file:[m
       path: "{{ apache2_log_dir }}"[m
       state: directory[m
 [m
 [m
[31m-  - name: Debian | config_apache2 | add virtualhost[m
[31m-    template:[m
[31m-      src: "{{ virtualhost_templfile_name }}"[m
[31m-      dest: "{{ virtualhost_file_name }}"[m
[31m-      ownner: "{{ apache2_web_owner }}"[m
[32m+[m[32m  - name: config_apache2 | add virtualhost folder[m
[32m+[m[32m    file:[m
[32m+[m[32m      path: "{{ item.documentroot }}"[m
[32m+[m[32m      state: "directory"[m
[32m+[m[32m      owner: "{{ apache2_web_owner }}"[m
       group: "{{ apache2_web_group }}"[m
[32m+[m[32m    become: true[m
[32m+[m[32m    with_items: '{{ apache2_virtualhosts }}'[m
[32m+[m[32m    when: apache2_vhost_add[m
 [m
[32m+[m[32m  - name: config_apache2 | add virtualhost custome file[m
[32m+[m[32m    template:[m
[32m+[m[32m      src: "{{ apache2_vhost_folder_src }}/vhost.conf.j2"[m
[32m+[m[32m      dest: "{{ apache2_vhost_folder_dest }}/vhost.conf"[m
[32m+[m[32m    become: true[m
[32m+[m[32m    when: apache2_vhost_add[m
[1mdiff --git a/roles/ansible-apache2/tasks/debiab.yml b/roles/ansible-apache2/tasks/debiab.yml[m
[1mindex bba72b5..98efc2e 100644[m
[1m--- a/roles/ansible-apache2/tasks/debiab.yml[m
[1m+++ b/roles/ansible-apache2/tasks/debiab.yml[m
[36m@@ -5,7 +5,5 @@[m
     become: true[m
 [m
   - name: Debian | install apache2[m
[31m-    apt:[m
[31m-      name: apache2[m
[31m-      state: present[m
[32m+[m[32m    apt: "name={{ debian_package }} state=present"[m
     become: true[m
[1mdiff --git a/roles/ansible-apache2/tasks/main.yml b/roles/ansible-apache2/tasks/main.yml[m
[1mindex 137ec91..eb429c3 100644[m
[1m--- a/roles/ansible-apache2/tasks/main.yml[m
[1m+++ b/roles/ansible-apache2/tasks/main.yml[m
[36m@@ -9,5 +9,7 @@[m
   when: ansible_os_family == "RedHat"[m
 [m
 - include: config_apache2.yml[m
[32m+[m[32m  when: apache2_config[m
 [m
 - include: php.yml[m
[32m+[m[32m  when: apache2_php_install[m
[1mdiff --git a/roles/ansible-apache2/tasks/redhat.yml b/roles/ansible-apache2/tasks/redhat.yml[m
[1mindex 119943f..b363d53 100644[m
[1m--- a/roles/ansible-apache2/tasks/redhat.yml[m
[1m+++ b/roles/ansible-apache2/tasks/redhat.yml[m
[36m@@ -5,9 +5,7 @@[m
     become: true[m
 [m
   - name: Redhat | install httpd[m
[31m-    yum:[m
[31m-      name: httpd[m
[31m-      state: present[m
[32m+[m[32m    yum: "name={{ Redhat_package }} state=present"[m
     become: true[m
 [m
   - name: Redhat | enable service httpd[m
[1mdiff --git a/roles/ansible-apache2/tasks/set_facts.yml b/roles/ansible-apache2/tasks/set_facts.yml[m
[1mindex a0bc108..73ff927 100644[m
[1m--- a/roles/ansible-apache2/tasks/set_facts.yml[m
[1m+++ b/roles/ansible-apache2/tasks/set_facts.yml[m
[36m@@ -3,8 +3,10 @@[m
     set_fact:[m
       apache2_log_dir: "var/log/apache2"[m
       apache2_web_group: "www-data"[m
[31m-      apche2_web_owner: "www-data"[m
[32m+[m[32m      apache2_web_owner: "www-data"[m
       apache2_web_root: "/var/www/html"[m
[32m+[m[32m      apache2_vhost_folder_src: "etc/apache2/sites-available"[m
[32m+[m[32m      apache2_vhost_folder_dest: "/etc/apache2/sites-available"[m
     when: ansible_os_family == "Debian"[m
 [m
   - name: Setting RedHat facts[m
[1mdiff --git a/roles/ansible-apache2/templates/etc/apache2/sites-available/test.conf.j2 b/roles/ansible-apache2/templates/etc/apache2/sites-available/test.conf.j2[m
[1mnew file mode 100644[m
[1mindex 0000000..e06bb6b[m
[1m--- /dev/null[m
[1m+++ b/roles/ansible-apache2/templates/etc/apache2/sites-available/test.conf.j2[m
[36m@@ -0,0 +1,3 @@[m
[32m+[m[32m----[m
[32m+[m
[32m+[m[32mTest file[m
[1mdiff --git a/roles/ansible-apache2/templates/etc/apache2/sites-available/vhost.conf.j2 b/roles/ansible-apache2/templates/etc/apache2/sites-available/vhost.conf.j2[m
[1mnew file mode 100644[m
[1mindex 0000000..8721c8a[m
[1m--- /dev/null[m
[1m+++ b/roles/ansible-apache2/templates/etc/apache2/sites-available/vhost.conf.j2[m
[36m@@ -0,0 +1,13 @@[m
[32m+[m
[32m+[m[32m</VirtualHost>[m
[32m+[m[32m{% if apache2_vhost_add %}[m
[32m+[m[32m{%   for item in apache2_virtualhosts %}[m
[32m+[m[32m<VirtualHost *:{{ item.port }}>[m
[32m+[m	[32mServerAdmin {{ item.serveradmin }}[m
[32m+[m	[32mDocumentRoot {{ item.documentroot }}[m
[32m+[m	[32mServername {{ item.servername }}[m
[32m+[m	[32mErrorLog {{ apache2_log_dir }}/{{ item.servername }}_error.log[m
[32m+[m	[32mCustomLog {{ apache2_log_dir }}/{{ item.servername }}_access.log combined[m
[32m+[m[32m</VirtualHost>[m
[32m+[m[32m{% endfor %}[m
[32m+[m[32m{% endif %}[m
[1mdiff --git a/roles/ansible-apache2/vars/main.yml b/roles/ansible-apache2/vars/main.yml[m
[1mnew file mode 100644[m
[1mindex 0000000..baf9e6c[m
[1m--- /dev/null[m
[1m+++ b/roles/ansible-apache2/vars/main.yml[m
[36m@@ -0,0 +1,13 @@[m
[32m+[m[32m---[m
[32m+[m[32m# Vars apachr2 role[m
[32m+[m
[32m+[m[32mdebian_package:[m
[32m+[m[32m  - apache2[m
[32m+[m[32m  - mc[m
[32m+[m[32m  - lynx[m
[32m+[m
[32m+[m
[32m+[m[32mredhat_package:[m
[32m+[m[32m  - httpd[m
[32m+[m[32m  - mc[m
[32m+[m[32m  - lynx[m
