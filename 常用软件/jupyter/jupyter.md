##
#### docker运行命令
```
mkdir -p /opt/soft/jupyter
# 不指定token
docker run -itd --restart always --name jupyter -v /opt/soft/jupyter:/home/jovyan/work -p 8888:8888 jupyter/datascience-notebook:4d7dd95017ed
# 指定token(该命令设置的token好像不成功)
# docker run -itd --restart always --name jupyter -p 8888:8888 jupyter/datascience-notebook:4d7dd95017ed start-notebook.sh --NotebookApp.password='sha1:6587feaef3b1:6b243404e4cfaafe611fdf494ee71fdaa8c4a563'
```

#### 在jupyter的web页的命令行配置pip的阿里源
```
mkdir -p ~/.pip
echo "[global]" > ~/.pip/pip.conf
echo "index-url=http://mirrors.aliyun.com/pypi/simple/" >> ~/.pip/pip.conf

echo "[install]" >> ~/.pip/pip.conf
echo "trusted-host=mirrors.aliyun.com" >> ~/.pip/pip.conf
```