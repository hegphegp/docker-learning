## watchman源码编译安装

* 把官方的仓库同步到国内的gitee, 拉取代码的速度飞起来
```
sudo apt-get install -y libtool libssl-dev
git clone https://gitee.com/hegp/watchman.git
cd watchman
git checkout v4.9.0
./autogen.sh
./configure
make
sudo make install
watchman -v
```
