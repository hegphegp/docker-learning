### 无论是ansible脚本客户端还是被操控的服务器，都要配置Python环境，因此要制作一个alpine带ssh和Python环境的镜像

```
docker pull williamyeh/ansible:alpine3
docker tag williamyeh/ansible:alpine3 ansible-2.5

docker stop web1
docker rm web1
docker stop web2
docker rm web2
docker stop ansible
docker rm ansible
docker network rm ansible-network
docker network create --subnet=10.10.58.0/24 ansible-network
docker run -itd --net ansible-network --ip 10.10.58.101 --name ansible -v /opt/soft/ansible:/ansible --restart always ansible-2.5 sh

docker run -itd --net ansible-network --ip 10.10.58.102 --name web1 --restart always sshd
docker run -itd --net ansible-network --ip 10.10.58.103 --name web2 --restart always sshd

docker exec -it ansible sh
cd /ansible
cat > host <<EOF
[web1]
10.10.58.102 ansible_ssh_user=root ansible_ssh_pass=root ansible_ssh_port=22
[web2]
10.10.58.103 ansible_ssh_user=root ansible_ssh_pass=root ansible_ssh_port=22
EOF
cat > ansible.cfg <<EOF
[defaults]
host_key_checking = False
inventory = ./host
EOF

# 在执行命令的时候指定host文件
# ansible -i /ansible/host web1 -u root -m command -a 'ls /etc' -k (-k表示手动输入密码)
ansible -i host all -u root -m command -a 'ls /etc'
ansible -i host all -u root -m command -a 'ls /etc'
# 使用ansible.cfg的设置的host文件
ansible web -u root -m command -a 'ls /etc'
```

#### 该例子的目录结构
```
/ansible
├── ansible.cfg
   |-----------ansible.cfg的内容-------------------------
   | [defaults]
   | host_key_checking = False
   | inventory = ./host
   |----------------------------------------------------
├── host
   |-----------host的内容--------------------------------
   | [web]
   | 10.10.58.102 ansible_ssh_user=root ansible_ssh_pass=root ansible_ssh_port=22
   | 10.10.58.103 ansible_ssh_user=root ansible_ssh_pass=root ansible_ssh_port=22
   |----------------------------------------------------
└── host1
```