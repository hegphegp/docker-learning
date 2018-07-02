# ansible讲解

### ansible配置文件ansible.cfg详解
```
## ansible.cfg文件读取先后顺序
1) ANSIBLE_CONFIG (一个环境变量)  # 去ANSIBLE_CONFIG该变量指定的环境路径找ansible.cfg
2) ./ansible.cfg (位于当前目录中)  # 在当前目录找ansible.cfg
3) ~/ansible.cfg (位于家目录中)    # 在家目录找ansible.cfg
4) /etc/ansible/ansible.cfg      # 在/etc/ansible/ansible.cfg
## 看了一个大型项目，发现ansible.cfg只配了4个参数
```

### 无论是ansible脚本客户端还是被操控的服务器，都要配置Python环境