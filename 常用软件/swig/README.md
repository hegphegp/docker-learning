
#
```
cd /home/hgp/v6.3.15_20190220_api_tradeapi_se_linux64
docker run -it --rm -v /home/hgp/v6.3.15_20190220_api_tradeapi_se_linux64:/test ubuntu:18.04 sh
cd /test
apt-get update && apt-get install -y lsb-release
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs) main restricted universe multiverse" > /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-proposed main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse" >> /etc/apt/sources.list
apt-get update && apt-get install -y openjdk-8-jdk build-essential swig && apt-get clean && apt-get autoclean && apt-get clean && apt-get autoremove
mkdir -p src/thosttraderapi wrap ctp

# 网上写博客的那些人，都不知道他们自己有没有完整跑起来的，乱写博客，又不给出完整的代码，给的代码都是垃圾

```
