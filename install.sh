#!/bin/bash

DIR="$( cd "$( dirname "$0"  )" && pwd  )"
SRC="/root/package"
if [ ! -d $SRC ];then
  tar zxvf /root/package*.tar.gz -C /root 
  else
  echo "文件夹已经存在"
fi

timedatectl set-timezone Asia/Shanghai
yum install ntpdate -y
ntpdate -u 1.cn.pool.ntp.org
hwclock -w

yum install -y unzip zip
yum install vim -y
yum install git -y
yum install wget -y

yum install boost -y
yum install boost-devel -y
yum install libcurl-devel -y

yum install gcc gcc-c++ -y
systemctl stop firewalld.service
systemctl disable firewalld.service

sed -i 's/^SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
echo "/usr/local/lib" >> /etc/ld.so.conf

firewall-cmd --state

#install mysql 5.7
rpm -e mariadb-libs-5.5.68-1.el7.x86_64 --nodeps
yum -y install libaio
yum -y install perl-CPAN
yum -y install perl-JSON
yum -y install ncurses-compat-libs
yum -y install net-tools 

cd $SRC/mysql
rpm -ivh *.rpm 
systemctl start mysqld.service  
systemctl status mysqld.service
systemctl enable mysqld.service

#### install jq data collecter ,get history data 
yum install python-pip -y
yum install python3-devel -y
#pip3 install pexpect
pip3 install pickle5
pip3 install python_struct
pip3 install jqdatasdk
pip3 install mysqlclient
pip3 install pyaml 

### config mysql root password 111111
$DIR/config.py
systemctl restart mysqld.service  


cd $SRC
tar zxvf  scons-2.2.0.tar.gz
cd scons-2.2.0
sudo python setup.py install


cd $SRC 
tar zxvf jsoncpp-src-0.5.0.tar.gz
cd ./jsoncpp-src-0.5.0
scons platform=linux-gcc

mv libs/linux-gcc-4.8.5/libjson_linux-gcc-4.8.5_libmt.so /lib
ln /lib/libjson_linux-gcc-4.8.5_libmt.so /lib/libjson.so
mv include/json/ /usr/include/
ldconfig
./bin/linux-gcc-4.8.5/test_lib_json

cd $SRC 
tar -zxvf log4cplus-2.0.5.tar.gz
cd log4cplus-2.0.5/
./configure
make && make install


# install  mysql connector c++
cd $SRC 
tar zxvf mysql-connector-c++-1.1.12-linux-glibc2.12-x86-64bit.tar.gz
cd mysql-connector-c++-1.1.12-linux-glibc2.12-x86-64bit
cd include 
cp -rn * /usr/local/include
cd $SRC/mysql-connector-c++-1.1.12-linux-glibc2.12-x86-64bit/lib
cp * /usr/local/lib
cd  /usr/local/lib/
rm -rf libmysqlcppconn.so
rm -rf libmysqlcppconn.so.7
ln -s libmysqlcppconn.so.7.1.1.12 libmysqlcppconn.so.7
ln -s libmysqlcppconn.so.7 libmysqlcppconn.so
ldconfig 

#install redis 
cd $SRC 
tar zxvf redis-5.0.3.tar.gz
cd redis-5.0.3
make && make install  PREFIX=/usr/local/redis
ln -s /usr/local/redis/bin/redis-cli /usr/bin/redis-cli
mkdir -p /usr/local/redis/conf
cp redis.conf /usr/local/redis/conf
sed -i 's/^daemonize no/daemonize yes/g' /usr/local/redis/conf/redis.conf

#set redis autorun 
cd $DIR
cp redis /etc/init.d/redis
chmod 755 /etc/init.d/redis #设置文件redis的权限，让Linux可以执行
chkconfig redis on    #开启服务自启动
chkconfig --list      #查看所有注册的脚本文件
service redis start  #启动

#install redis c++ lib 
cd $SRC 
rpm -ivh epel-release-latest-7.noarch.rpm
yum install hiredis-devel -y 
ldconfig 
 
echo "export LD_LIBRARY_PATH=/root/autotrader/lib:\$LD_LIBRARY_PATH" >> /root/.bash_profile
source /root/.bash_profile

