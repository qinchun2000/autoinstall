#!/usr/bin/python3 
# --*-- coding: utf-8 --*--
import os 
import time
#import pexpect 
import subprocess 
import re
import configparser

def excuteCmdAndReturn(cmd):      
    result = subprocess.getstatusoutput(cmd)
    if result[0] != 0:
        return False, result[1]
    return True, result[1]

def set_mysql():
    cmd = "grep 'temporary password' /var/log/mysqld.log" 
    result = subprocess.getstatusoutput(cmd)
    if result[0] != 0:
        return False, result[1]
    line=result[1]
    ret = re.findall(r"root@localhost: (.*)",line)
    if len(ret) >0 :
        print (ret[0].strip())
    
    cmd = "mysql --connect-expired-password -uroot -p\'"+ret[0].strip() + "\' < /root/autoinstall/modify_pass.sql"
    print (cmd) 
    result = subprocess.getstatusoutput(cmd)
    if result[0] != 0:
        return False, result[1]

    config = configparser.ConfigParser()
    config.read("/etc/my.cnf", encoding="utf-8")
    config.set("mysqld", "character-set-server", "utf8")
    config.set("mysqld", "init_connect", "'SET NAMES utf8'")
    config.set("mysqld", "ssl", "0")
    config.write(open("/etc/my.cnf", "w"))



    return True, result[1]

if __name__ == "__main__" :
    set_mysql()
