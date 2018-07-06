# ubuntu软件源仓库源

#### Ubuntu-16.04
```
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo echo "deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse" > /etc/apt/sources.list
sudo echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse" >> /etc/apt/sources.list
sudo echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list
sudo echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list
sudo apt-get update
sudo apt-get clean
sudo apt-get autoclean   # 清理旧版本的软件缓存
sudo apt-get clean       # 清理所有软件缓存
sudo apt-get autoremove  # 删除系统不再使用的孤立软件

### 不用sudo执行的命令
cp /etc/apt/sources.list /etc/apt/sources.list.bak
echo "deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse" > /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list
apt-get update
apt-get clean
apt-get autoclean   # 清理旧版本的软件缓存
apt-get clean       # 清理所有软件缓存
apt-get autoremove  # 删除系统不再使用的孤立软件
```

#### ubuntu最近版本
版本 | 别名（codename）| 发布日期
:---:|:---:|:---:
14.04 | Trusty Tahr (可靠的塔尔羊) | 2014年4月18日 (LTS)
14.10 | Utopic Unicorn(乌托邦独角兽) | 2014年10月23日
15.04 | Vivid Vervet (活泼的小猴) | 2015年4月
15.10 | Wily Werewolf (狡猾的狼人) | 2015年10月
16.04 | Xenial Xerus (好客的非洲地松鼠) | 2016年4月 （LTS）
16.10 | Yakkety Yak（牦牛） | 2016年10月
17.04 | Zesty Zapus(开心的跳鼠) | 2017年4月
17.10 | Artful Aardvark(机灵的土豚) | 2017年10月
18.04 | Bionic Beaver（仿生海狸） | 即将发布2018年4月(LTS)

```
#deb包
deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
##测试版源
deb http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse
# 源码
deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
##测试版源
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse
# Canonical 合作伙伴和附加
deb http://archive.canonical.com/ubuntu/ xenial partner
deb http://extras.ubuntu.com/ubuntu/ xenial main
```

### ubuntu所有版本
版本 | 别名（codename）| 发布日期
:---:|:---:|:---:
4.10 | Warty Warthog(长疣的疣猪) | 2004年10月20日
5.04 | Hoary Hedgehog(灰白的刺猬) | 2005年4月8日
5.10 | Breezy Badger(活泼的獾) | 2005年10月13日
6.06 | Dapper Drake(整洁的公鸭) | 2006年6月1日(LTS)
6.10 | Edgy Eft(急躁的水蜥) | 2006年10月6日
7.04 | Feisty Fawn(坏脾气的小鹿) | 2007年4月19日
7.10 | Gutsy Gibbon(勇敢的长臂猿) | 2007年10月18日
8.04 | Hardy Heron(耐寒的苍鹭) | 2008年4月24日(LTS)
8.10 | Intrepid Ibex (勇敢的野山羊) | 2008年10月30日
9.04 | Jaunty Jackalope(得意洋洋的怀俄明野兔) | 2009年4月23日
9.10 | Karmic Koala(幸运的考拉) | 2009年10月29日
10.04 | Lucid Lynx(清醒的猞猁) | 2010年4月29日
11.10 | Oneiric Ocelot(梦幻的豹猫) | 2010年10月13日
11.04 | Natty Narwhal(敏捷的独角鲸) | 2011年4月28日
12.04 | Precise Pangolin(精准的穿山甲) | 2012年的4月26日(LTS)
12.10 | Quantal Quetzal(量子的绿咬鹃) | 2012年的10月20日
13.04 | Raring Ringtail(铆足了劲的猫熊) | 2013年4月25日
13.10 | Saucy Salamander(活泼的蝾螈) | 2013年10月17日
14.04 | Trusty Tahr (可靠的塔尔羊) | 2014年4月18日 (LTS)
14.10 | Utopic Unicorn(乌托邦独角兽) | 2014年10月23日
15.04 | Vivid Vervet (活泼的小猴) | 2015年4月
15.10 | Wily Werewolf (狡猾的狼人) | 2015年10月
16.04 | Xenial Xerus (好客的非洲地松鼠) | 2016年4月 （LTS）
16.10 | Yakkety Yak（牦牛） | 2016年10月
17.04 | Zesty Zapus(开心的跳鼠) | 2017年4月
17.10 | Artful Aardvark(机灵的土豚) | 2017年10月
18.04 | Bionic Beaver（仿生海狸） | 即将发布2018年4月(LTS)