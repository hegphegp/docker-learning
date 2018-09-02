# ansible讲解

#### 以下的参数只适用于ansible-2.5.0版本，不知道在其他版本中参数是否适用
#### williamyeh/ansible:alpine3镜像说明
```
1) python版本是2.7.14
2) ansible版本是2.5.0
3) williamyeh/ansible:alpine3重命名为ansible-2.5  docker tag williamyeh/ansible:alpine3 ansible-2.5
```

#### playbook项目规范
```
1) ansible.cfg必须创建并且放到项目根路径，运行时必须指定ansible.cfg的路径
```

#### playbook项目说明
```
1) ansible.cfg配置文件必须放到项目根路径
2) host虚拟机账号密码配置文件必须放到项目根路径
```

### ansible配置文件ansible.cfg详解
```
## ansible.cfg文件读取先后顺序
1) ANSIBLE_CONFIG (一个环境变量)  # 去ANSIBLE_CONFIG该变量指定的环境路径找ansible.cfg
2) ./ansible.cfg (位于当前目录中)  # 在当前目录找ansible.cfg
3) ~/ansible.cfg (位于家目录中)    # 在家目录找ansible.cfg
4) /etc/ansible/ansible.cfg      # 在/etc/ansible/ansible.cfg
## 看了一个大型项目，发现ansible.cfg只配了4个参数
```

#### 无论是ansible脚本客户端还是被操控的服务器，都要配置Python环境


### 几个异常的解决方案

##### Using a SSH password instead of a key is not possible because Host Key checking is enabled and sshpass does not support this.  Please add this host's fingerprint to your known_hosts file to manage this host.
##### 解决方法，在ansible.cfg添加 host_key_checking = False 参数
```
Using a SSH password instead of a key is not possible because Host Key checking is enabled and sshpass does not support this.  Please add this host's fingerprint to your known_hosts file to manage this host.
```
