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

