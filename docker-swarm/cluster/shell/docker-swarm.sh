#!/bin/bash

# >>>>>>>>>>>>定义开始变量
manager1=manager1
manager=(manager2 manager3)
worker=(worker1 worker2 worker3)
iso_relative_path=iso/boot2docker-17.11.0-ce-rc2.iso
mirror_addr=https://0i912uv5.mirror.aliyuncs.com
# <<<<<<<<<<<<<定义开始变量



all=(manager1 ${manager[*]} ${worker[*]})
file_path=$(cd "$(dirname "$0")"; pwd)
iso_path=file:${file_path}/${iso_relative_path}



# >>>>>>>>>>>>找出所有存在的docker虚拟机以及运行状态
echo -e "\033[31m\n 步骤一:开始:找出所有存在的docker虚拟机以及运行状态 \n\033[0m"
echo -e "\033[31m\n docker-machine ls | awk -F ' ' '{if(NR>1){print \$1}}' \n\033[0m"
data=$(docker-machine ls | awk -F ' ' '{if(NR>1){print $1}}')
vms=($data)
echo -e "\033[31m\n docker-machine ls | awk -F ' ' '{if(NR>1){print \$4}}' \n\033[0m"
data=$(docker-machine ls | awk -F ' ' '{if(NR>1){print $4}}')
status=($data)
echo -e "\033[31m\n 步骤一:结束:找出所有存在的docker虚拟机以及运行状态 \n\033[0m"
# <<<<<<<<<<<<<找出所有存在的docker虚拟机以及运行状态



# >>>>>>>>>>>>停止并删除运行的docker虚拟机
echo -e "\033[31m\n 步骤二:开始:停止并删除名称相同的docker虚拟机 \n\033[0m"
for idx in ${!vms[@]} ;
do
  for item in ${all[@]}
  do
    if [ ${vms[$idx]} == $item ]; then
      if [ ${status[$idx]} == "running" ]; then
        echo -e "\033[31m\n docker-machine stop $item \n\033[0m"
        docker-machine stop $item
        echo -e "\033[31m\n docker-machine rm -y $item \n\033[0m"
        docker-machine rm -y $item
      else
        echo -e "\033[31m\n docker-machine rm -y $item \n\033[0m"
        docker-machine rm -y $item
      fi
    fi
  done
done
echo -e "\033[31m\n 步骤二:结束:停止并删除名称相同的docker虚拟机 \n\033[0m"
# <<<<<<<<<<<<<停止并删除运行的docker虚拟机



# >>>>>>>>>>>>创建所有的docker虚拟机
echo -e "\033[31m\n 步骤三:开始:创建所有的docker虚拟机 \n\033[0m"
for item in ${all[@]};
do
  echo -e "\033[31m\n docker-machine create --driver virtualbox --virtualbox-boot2docker-url $iso_path --virtualbox-cpu-count 2 --virtualbox-memory 1024 --engine-registry-mirror $mirror_addr $item \n\033[0m"
  docker-machine create --driver virtualbox --virtualbox-boot2docker-url $iso_path --virtualbox-cpu-count 2 --virtualbox-memory 1024 --engine-registry-mirror $mirror_addr $item
done
echo -e "\033[31m\n 步骤三:结束:创建所有的docker虚拟机 \n\033[0m"
# <<<<<<<<<<<<<创建所有的docker虚拟机



# >>>>>>>>>>>>获取manager1虚拟机的IP，然后用manager1初始化swarm集群
echo -e "\033[31m\n 步骤四:开始:从manager节点获取第一台docker虚拟机作为管理节点,然后用manager1初始化swarm集群 \n\033[0m"
echo -e "\033[31m\n docker-machine ip $manager1 \n\033[0m"
manager1_ip=$(docker-machine ip $manager1)
# manager1_ip=$(docker-machine ls | grep $manager1 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
echo -e "\033[31m\n docker-machine ssh $manager1 docker swarm init --advertise-addr $manager1_ip \n\033[0m"
docker-machine ssh $manager1 docker swarm init --advertise-addr $manager1_ip
echo -e "\033[31m\n 步骤四:结束:从manager节点获取第一台docker虚拟机作为管理节点,然后用manager1初始化swarm集群 \n\033[0m"
# <<<<<<<<<<<<<获取manager1虚拟机的IP，然后用manager1初始化swarm集群



# >>>>>>>>>>>>>获取添加manager的token，然后把所有manager加入到swarm集群
echo -e "\033[31m\n 步骤五:开始:获取添加manager的token，然后把所有manager加入到swarm集群 \n\033[0m"
echo -e "\033[31m\n docker-machine ssh $manager1 docker swarm join-token manager | grep 'token' \n\033[0m"
add_manager_token=$(docker-machine ssh $manager1 docker swarm join-token manager | grep 'token')
for item in ${manager[@]};
do
  echo -e "\033[31m\n docker-machine ssh $item $add_manager_token \n\033[0m"
  docker-machine ssh $item $add_manager_token
done
echo -e "\033[31m\n 步骤五:结束:获取添加manager的token，然后把所有manager加入到swarm集群 \n\033[0m"
# <<<<<<<<<<<<<获取添加manager的token，然后把所有manager加入到swarm集群



# >>>>>>>>>>>>>获取添加worker的token，然后把所有manager加入到swarm集群
echo -e "\033[31m\n 步骤六:开始:获取添加worker的token，然后把所有manager加入到swarm集群 \n\033[0m"
echo -e "\033[31m\n docker-machine ssh $manager1 docker swarm join-token worker | grep 'token' \n\033[0m"
add_worker_token=$(docker-machine ssh $manager1 docker swarm join-token worker | grep 'token')
for item in ${worker[@]};
do
  echo -e "\033[31m\n docker-machine ssh $item $add_worker_token \n\033[0m"
  docker-machine ssh $item $add_worker_token
done
echo -e "\033[31m\n 步骤六:结束:获取添加worker的token，然后把所有manager加入到swarm集群 \n\033[0m"
# <<<<<<<<<<<<<获取添加worker的token，然后把所有manager加入到swarm集群






# >>>>>>>>>>>>在manager1虚拟机初始化swarm集群
# manager1_ip=`docker-machine ls | grep $manager1 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`
# manager1_ip=$(docker-machine ls | grep $manager1 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
# echo $manager1_ip
# docker-machine ssh $manager1 docker swarm init --advertise-addr $manager1_ip
# <<<<<<<<<<<<<在manager1虚拟机初始化swarm集群


# >>>>>>>>>>>>>添加manager
# add_manager=$(docker-machine ssh $manager1 docker swarm join-token manager | grep 'token')
# docker-machine ssh $manager2 $add_manager
# <<<<<<<<<<<<<添加manager

# >>>>>>>>>>>>>添加worker
# add_worker=$(docker-machine ssh $manager1 docker swarm join-token worker | grep 'token')
# docker-machine ssh $worker1 $add_worker
# <<<<<<<<<<<<<添加worker

# 用生命换来的代价：awk结果转成数组, 然后用for遍历与直接用for遍历自定义的数组的写法不一样
# >>>>>>>>>>>>>awk结果转成数组, 然后用for遍历与直接用for遍历自定义的数组的写法不一样
# data=$(docker-machine ls | awk -F " " '{if(NR>1){print $1,$4}}')
# echo $data
# arr=$(echo $data | tr " " " ")
# for item in $arr
# do
#   echo $item
# <<<<<<<<<<<<<awk结果转成数组


# >>>>>>>>>>>>>数组合并
# worker=(worker1 worker2) #数组不用逗号分割，即正确写法是worker=(worker1 worker2)，而不是worker=(worker1, worker2)
# manager=(manager2 manager3 worker1)
# all=(manager1 ${worker[*]} ${manager[*]})
# echo ${#all[*]}
# echo ${all[*]}
# <<<<<<<<<<<<<数组合并


# 用生命换来的代价：awk结果转成数组, 然后用for遍历与直接用for遍历自定义的数组的写法不一样
# worker=(worker1 worker2)
# manager=(manager2 manager3 worker1)
# all=(${worker[*]} ${manager[*]})
# for item in  ${all[@]} ;
# do
#   echo $item
# done

# for worker_idx in ${!worker[@]} ;
# do
#   for manager_idx in ${!manager[@]} ;
#   do
# #   生命换来的代价 1) if 与[ 之间必须有空格 2) [ ]与判断条件之间也必须有空格 3) ]与; 之间不能有空格, ';'分号不可以少
#     if [ ${worker[$worker_idx]} == ${manager[$manager_idx]} ]; then
#       echo ${manager[$manager_idx]} ;
#     fi
#   done
# done



############################
# 以某些字符串分割，并打印第1,3列
# docker-machine ls | awk -F " " '{print $1,$3}'
# 去掉第一行，再以某些字符串分割，然后打印第1,3列
# docker-machine ls | awk -F " " '{if(NR>1){print $1,$4}}'
############################
