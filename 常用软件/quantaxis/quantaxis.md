```
mkdir -p quantaxis
cd quantaxis

tee docker-compose.yml <<-'EOF'
version: '2'
services:

  qacron:
    image: barretthugh/qa-cron
    environment:
      - MONGODB=mgdb
    restart: always

  mgdb:
    image: mongo:4.1.3
    ports:
      - "27017:27017"
    environment:
      - TZ=Asia/Shanghai
      - MONGO_INITDB_DATABASE=quantaxis
    volumes:
      - qamg:/data/db
    restart: always

volumes:
  qamg:
    external:
      name: qamg
  qacode:
    external:
      name: qacode

EOF

docker volume create qamg
docker volume create qacode
docker-compose up -d mgdb
docker-compose up -d qacron
```

```
docker exec -it quantaxis_qacron_1 sh

mkdir -p ~/.pip
echo "[global]" > ~/.pip/pip.conf
echo "index-url=http://mirrors.aliyun.com/pypi/simple/" >> ~/.pip/pip.conf

echo "[install]" >> ~/.pip/pip.conf
echo "trusted-host=mirrors.aliyun.com" >> ~/.pip/pip.conf
pip install pyecharts_snapshot
pip install --upgrade pip

cd /QUANTAXIS/config

tee update_future_day_all.py <<-'EOF'
#!/usr/local/bin/python
#coding :utf-8

from QUANTAXIS.QASU.main import (QA_SU_save_future_list,
                                 QA_SU_save_future_day_all)
QA_SU_save_future_list('tdx')
QA_SU_save_future_day_all('tdx')
EOF


tee update_future_min_all.py <<-'EOF'
#!/usr/local/bin/python
#coding :utf-8

from QUANTAXIS.QASU.main import (QA_SU_save_future_list,
                                 QA_SU_save_future_min_all)
QA_SU_save_future_list('tdx')
QA_SU_save_future_min_all('tdx')
EOF


chmod a+x update_future_min_all.py
chmod a+x update_future_day_all.py

nohup python update_future_day_all.py > update_future_day_all.log &
nohup python update_future_min_all.py > update_future_min_all.log &

top 查看进程杀掉
tail -n 100 -f update_future_day_all.log
tail -n 100 -f update_future_min_all.log
```