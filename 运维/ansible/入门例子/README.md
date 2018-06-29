### 无论是ansible脚本客户端还是被操控的服务器，都要配置Python环境，因此要制作一个alpine带ssh和Python环境的镜像

```
docker pull ansible/centos7-ansible
docker tag ansible/centos7-ansible ansible
docker pull komukomo/centos-sshd:6.7
docker tag komukomo/centos-sshd:6.7 centos-6.7

docker stop centos1
docker rm centos1
docker stop centos2
docker rm centos2
docker stop centos3
docker rm centos3
docker stop ansible
docker rm ansible
docker network rm ansible-network
docker network create --subnet=10.10.58.0/24 ansible-network
docker run -itd --net ansible-network --ip 10.10.58.101 --name ansible -v /opt/soft/ansible:/ansible --restart always ansible sh


docker run -itd --net ansible-network --ip 10.10.58.102 --name centos1 --restart always centos-6.7
docker run -itd --net ansible-network --ip 10.10.58.103 --name centos2 --restart always centos-6.7
docker run -itd --net ansible-network --ip 10.10.58.104 --name centos3 --restart always centos-6.7

docker exec -it ansible sh
ansible -i /ansible/host1 test -u root -m command -a 'ls /etc' -k
```