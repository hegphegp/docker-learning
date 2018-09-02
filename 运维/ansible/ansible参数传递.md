# ansible-playbook向yml文件传递参数的方式

#### 同一个yml问价里面配置参数
```yml
# 执行命令  ansible-playbook main.yml -i host -v
---
## 在同一个yml文件定义变量
- name: test vars
  hosts: web
  remote_user: root
  gather_facts: false
  vars:
    - filename: "filename.txt"
  tasks:
    - name: test_playbook
      shell: mkdir -p /tmo && touch /tmp/"{{ filename }}"

    - name: see_folder
      command: ls /etc
```

#### 用命令行传递参数
```yml
# 执行命令  ansible-playbook main.yml -i host -v --extra-vars "hosts=web user=root"
---
- name: test vars
  hosts: '{{ hosts }}' 
  remote_user: '{{ user }}'
  gather_facts: false
  vars:
    - filename: "filename.txt"
  tasks:
    - name: test_playbook
      shell: mkdir -p /tmo && touch /tmp/"{{ filename }}"
```

#### 用json格式传递参数：
```yml
# 执行命令  ansible-playbook main.yml -i host -v --extra-vars "{'hosts':'web', 'user':'root'}"
---
- name: test vars
  hosts: '{{ hosts }}' 
  remote_user: '{{ user }}'
  gather_facts: false
  vars:
    - filename: "filename.txt"
  tasks:
    - name: test_playbook
      shell: mkdir -p /tmo && touch /tmp/"{{ filename }}"
```

#### 参数放在文件里面
```yml
# 执行命令  ansible-playbook main.yml -i host -v --extra-vars "@vars.json"
---
- name: test vars
  hosts: '{{ hosts }}' 
  remote_user: '{{ user }}'
  gather_facts: false
  vars:
    - filename: "filename.txt"
  tasks:
    - name: test_playbook
      shell: mkdir -p /tmo && touch /tmp/"{{ filename }}"
```