#!/bin/bash
yum update -y
yum install httpd -y
yum install ansible -y
yum -y install epel-release
echo "localhost ansible_connection=local" >> /etc/ansible/hosts

cat > /etc/ansible/aws-nginx.yml <<EOL
---
- hosts: all
  tasks:
   - name: Install Nginx
     yum: name=nginx state=installed
   - name: Start Nginx
     service: name=nginx enabled=yes state=started
   - name: creating V-host file for myfirstpage.com
     file: path=/etc/nginx/sites-available/myfirstpage.com state=touch
   - name: Configuring V-host for myfirstpage.com
     blockinfile:
      dest: /etc/nginx/sites-available/myfirstpage.com
      block: |
        server {
        listen 80;
        listen [::]:80;
        server_name myfirstpage.com;
        root /var/www/myfirstpage.com;
        index index.html;
        autoindex on;
        location / {
        try_files  / =404;
        }
        }
      backup: yes
   - name: creating V-host file for mysecondpage.com
     file: path=/etc/nginx/sites-available/mysecondpage.com state=touch
   - name: Configuring V-host for mysecondpage.com
     blockinfile:
      dest: /etc/nginx/sites-available/mysecondpage.com
      block: |
        server {
        listen 80;
        listen [::]:80;
        server_name mysecondpage.com;
        root /var/www/mysecondpage.com;
        index index.html;
        autoindex on;
        location / {
        try_files  / =404;
        }
        }
      backup: yes
   - name: creating V-host file for mythirdpage.com
     file: path=/etc/nginx/sites-available/mythirdpage.com state=touch
   - name: Configuring V-host for mythirdpage.com
     blockinfile:
      dest: /etc/nginx/sites-available/mythirdpage.com
      block: |
        server {
        listen 80;
        listen [::]:80;
        server_name mythirdpage.com;
        root /var/www/mythirdpage.com;
        index index.html;
        autoindex on;
        location / {
        try_files  / =404;
        }
        }
      backup: yes
   - name: Creating content directory for myfirstpage.com
     file: path=/var/www/html/myfirstpage.com state=directory
   - file: path=/var/www/html/myfirstpage.com/index.html state=touch
   - name: inserting contents into index file
     blockinfile:
      dest: /var/www/html/myfirstpage.com/index.html
      block: |
        <h1>Welcome to myfirstpage.com!!</h1>
   - name: Creating content directory for mysecondpage.com
     file: path=/var/www/html/mysecondpage.com state=directory
   - file: path=/var/www/html/mysecondpage.com/index.html state=touch
   - name: inserting contents into index file
     blockinfile:
      dest: /var/www/html/mysecondpage.com/index.html
      block: |
        <h1>Welcome to mysecondpage.com!!</h1>
   - name: Creating content directory for mythirdpage.com
     file: path=/var/www/html/mythirdpage.com state=directory
   - file: path=/var/www/html/mythirdpage.com/index.html state=touch
   - name: inserting contents into index file
     blockinfile:
      dest: /var/www/html/mythirdpage.com/index.html
      block: |
        <h1>Welcome to mythirdpage.com!!</h1>
##Creating entries in host file
cat >> /etc/hosts << EOL
127.0.0.1 myfirstpage.com
127.0.0.1 mysecondpage.com
127.0.0.1 mythirdpage.com
EOL

#Running playbook
ansible-playbook /etc/ansible/aws-nginx.yml 
