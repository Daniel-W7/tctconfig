#!/bin/bash
#
#Name:tctconfig
#Version:1.8
#Auther：Daniel
#Date&Time：2021年9月1日
#Discription：实现通过脚本自动备份，重启，更新tomcat系统
#定义Tomcat的安装目录，需要根据自己的部署位置调整
#配置多线程处理，避免因为脚本的退出导致tomcat自动退出的情况
set -m
#获取运行的程序名
PRONAME=`basename $0`
#获取文件运行的当前目录
TCTPATH=$(cd "$(dirname "$0")"; pwd)
MODE=COMMON
#配置选项，如果没有输入选项直接进入提示页面
case $1 in
	-b|--backup)
		CONFIGURATION=b
		MODE=PRO;;
	-tb|--testbackup)
		CONFIGURATION=tb
		MODE=PRO;;
	-r|--restart)
		CONFIGURATION=r
		MODE=PRO;;
	-u|--update)
		CONFIGURATION=u
		MODE=PRO;;
	-tu|--testupdate)
                CONFIGURATION=tu
		MODE=PRO;;
	-sh|--shutdown)
		CONFIGURATION=sh
		MODE=PRO;;
	-st|--startup)
		CONFIGURATION=st
		MODE=PRO;;
	-l|--log)
		CONFIGURATION=l
		MODE=PRO;;
	-i|--install)
		CONFIGURATION=i
		echo "Hello,please choose your path to install:"
                read -p "The PATH to install:(default:/opt):" INSTALLPATH
		if [ $INSTALLPATH -n ];then
			INSTALLPATH=/opt;
		fi
		read -p "The option to install:(full|redis|tomcat|jdk,default:full):" INSTALLOPTION
		if [ $INSTALLOPTION -n ];then
			INSTALLOPTION=full;
		fi;;
	-c|--clean)
		CONFIGURATION=c;;
	-h|--help)
		echo "Usage:tctconf.sh | tctconf.sh -b|--backup|-tb|--testbackup|-r|--restart|-u|--update|-tu|--testupdate|-sh|--shutdown|-st|--startup|-l|--log|-i|--install|-c|--clean|-h|--help TOMCATVERSION"
		exit 0;;
	*)
		#MODE=COMMON
 		echo "Hello,please choose your tomcat to configure(ht|gfzq|waibao|tuoguan|zx|hx|xcgf|dsq|zs|zyjj|df|xcgf|dsq|qhyxh|Tomcat|q for quit):"
		echo "Your choice(ht|gfzq|waibao|tuoguan|zx|hx|zs|zyjj|xcgf|dsq|Tomcat):"
		read -p "Your choice:" TOMCATVERSION
		echo "Please chose your configuration:(b|backup|r|restart|u|update|q for quit):"
		read -p "Your configuration:" CONFIGURATION
		#read -p "Your choice(ht|gfzq|waibao|tuoguan|zx|hx|zs|zyjj|xcgf|dsq|Tomcat):" TOMCATVERSION
		TOMCATPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $2 }'`
		ROOTPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $3 }'`
		echo "Usage:tctconfig.sh | tctconfig.sh -b|--backup|-tb|--testbackup|-r|--restart|-u|--update|-tu|--testupdate|-sh|--shutdown|-st|--startup|-l|--log|-i|--install|-c|--clean|-h|--help TOMCATVERSION";;
esac
#读取tct.conf文件获取对应tomcat路径和系统名称的信息
#TOMCATPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $2 }'`
#ROOTPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $3 }'`
#单个tomcat的情况，此处直接填写即可
#TOMCATVERSION=
#TOMCATPATH=
#ROOTPARH=
#备份对应系统
backup() {
        #echo "Start to backup $TOMCATVERSION..."
        cd $TOMCATPATH/webapps/
	echo -e "\033[33mStart to backup $TOMCATPATH/webapps/$ROOTPATH\033[0m" 2>&1| tee -a  $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
        zip -r $ROOTPATH`date +%Y-%m-%d-%H:%M:%S`.zip $ROOTPATH >>$TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	echo -e "\033[32m$TOMCATPATH/webapps/$ROOTPATH backup successfully.\033[0mThe back file is $TOMCATPATH/webapps/$ROOTPATH`date +%Y-%m-%d-%H:%M:%S`.zip" 2>&1|tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	#echo "$TOMCATVERSION backup successfully!!!"

}

#测试之前的完整备份
testbackup() {
        #echo "Start to backup $TOMCATVERSION before test..."
        cd $TOMCATPATH/webapps/
	echo -e "\033[33mStart to backup $TOMCATPATH/webapps/$ROOTPATH before test...\033[0m" 2>&1 | tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
        zip -r $ROOTPATH`date +%Y-%m-%d-%H:%M:%S`TB.zip $ROOTPATH >>$TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	echo -e "\033[32m$TOMCATPATH/webapps/$ROOTPATH backup before test successfully.\033[0mThe back file is $TOMCATPATH/webapps/$ROOTPATH`date +%Y-%m-%d-%H:%M:%S`TB.zip" 2>&1 | tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	#echo "$TOMCATVERSION backup before test successfully!!!"
}
#关闭对应tomcat
tctshut(){
	#echo "Start to shutdown $TOMCATVERSION..."
        #关闭对应的tomcat
        #echo "$TOMCATVERSION is shuting..."
	echo -e "\033[36mStart to shut $TOMCATPATH/webapps/$ROOTPATH\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	$TOMCATPATH/bin/shutdown.sh &>$TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
        ps -ef | grep $TOMCATPATH | grep -v grep | awk '{print $2}' | sed -e "s/^/kill -9 /g" | sh -
	echo -e "\033[33m$TOMCATPATH/webapps/$ROOTPATH is shutted successfully\033[0m" 2>&1|tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	#echo "$TOMCATVERSION is shutted successfully..."
	sleep 1
}
#开启对应tomcat
tctstart(){
 	#启动tomcat,并查看对应日志
        #echo "$TOMCATVERSION is starting..." 
        #sleep 1
	echo -e "\033[32mStarting $TOMCATPATH/webapps/$ROOTPATH ...\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	$TOMCATPATH/bin/startup.sh >>$TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	#echo -e "\033[31m$TOMCATPATH/webapps/$ROOTPATH start successfully\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
        tail -f $TOMCATPATH/logs/catalina.out
        #ps -ef | grep tctconfig.sh | grep -v grep | awk '{print $2}' | sed -e "s/^/kill -9 /g" | sh -
}
tctrestart(){
	tctshut
	tctstart
}
#进行日常更新
update() {
	#切换到当前应用程序的目录
	#cd $TCTPATH
        #进行文件更新
        #echo "Start to update $TOMCATVERSION..."
	echo -e "\033[34mStart to update $TOMCATPATH/webapps/$ROOTPATH\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
        #sleep 2
        \cp -a $TCTPATH/package/update/* $TOMCATPATH/webapps/$ROOTPATH 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
        #删除本次更新文件
	mkdir -p $TCTPATH/package/backup/$TOMCATVERSION/`date +%Y-%m-%d-%H:%M:%S`/
        mv $TCTPATH/package/update/* $TCTPATH/package/backup/$TOMCATVERSION/`date +%Y-%m-%d-%H:%M:%S`/ 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	sleep 3
	#echo "$TOMCATVERSION is updated successfully!"
	echo -e "\033[34m$TOMCATPATH/webapps/$ROOTPATH update successfully\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
        #重启tomcat
        echo "Start to restart $TOMCATPATH/webapps/$ROOTPATH..." 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	sleep 2
tctrestart
}
#清理参与进程,日志及备份文件
clean(){
	#ps -ef | grep tctconfig.sh | grep -v grep | awk '{print $2}' | sed -e "s/^/kill -9 /g" | sh - &>/dev.null
	read -p "Do you want to clean the logs?(y/n)" CLOG
	case $CLOG in
        	y)
                	rm -rf $TCTPATH/logs/*
                	echo "Clean logs successfully";;
        	n)
                	echo "Done nothing";;
	esac
	read -p "Do you want to clean the backups?(y/n)" CBAK
	case $CBAK in
        	y)
                	rm -rf $TCTPATH/package/backup/*
                	echo "Clean backup successfully";;
        	n)
                	echo "Done nothing";;
	esac
	echo "Clean complete,exiting..."
	sleep 1
	ps -ef | grep tctconfig.sh | grep -v grep | awk '{print $2}' | sed -e "s/^/kill -15 /g" | sh - &>/dev.null
}
#安装部署解压
#部署tomcat,redis,jdk
tctinstall(){
	echo -e "\033[33mStart to install tomcat,the INSTALLPATH is $INSTALLPATH,please waiting\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	#判断目的地址是否存在相同的应用
       	if [ -e $INSTALLPATH/tomcat8 ];then
		read -p "There is a tomcat8 in $INSTALLPATH,dou you want to remove it?(y/n)" TCTOPTION 
		case $TCTOPTION in
			y)
				#cd $INSTALLPATH
				mkdir -p $TCTPATH/package/backup/$INSTALLOPTION/`date +%Y-%m-%d-%H:%M:%S`/
				mv $INSTALLPATH/tomcat8 $TCTPATH/package/backup/$INSTALLOPTION-`date +%Y-%m-%d-%H:%M:%S`/
				echo "The old $INSTALLOPTION have been moved to $TCTPATH/package/backup/$INSTALLOPTION-`date +%Y-%m-%d-%H:%M:%S`/" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
				echo "start to install a new $INSTALLOPTION,please waiting..." 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log;;
			n)
				echo "You choosed no,we have done noting,exiting" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log

				exit 1;;
		esac
	fi
	cd $TCTPATH/package/install/
	unzip -d $INSTALLPATH `ls $TCTPATH/package/install/ | grep -i tomcat` >> $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	echo -e "\033[34mTomcat installed successfully!!!\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
}
redisinstall(){
	#判断目的地址是否存在相同的应用
        if [ -e $INSTALLPATH/redis ];then
                read -p "There is a redis in $INSTALLPATH,dou you want to remove it?(y/n)" TCTOPTION
                case $TCTOPTION in
                        y)
                                #cd $INSTALLPATH
                                mkdir -p $TCTPATH/package/backup/$INSTALLOPTION/`date +%Y-%m-%d-%H:%M:%S`/
                                mv $INSTALLPATH/redis $TCTPATH/package/backup/$INSTALLOPTION-`date +%Y-%m-%d-%H:%M:%S`/
                                echo "The old $INSTALLOPTION have been moved to $TCTPATH/package/backup/$INSTALLOPTION-`date +%Y-%m-%d-%H:%M:%S`/" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
                                echo "start to install a new $INSTALLOPTION,please waiting..." 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log;;
                        n)
                                echo "You choosed no,we have done noting,exiting" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log

                                exit 2;;
                esac
        fi
	cd $TCTPATH/package/install/
	echo -e "\033[33mStart to install redis,the INSTALLPATH is $INSTALLPATH,please waiting\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
 	#\cp -a ./package/install/redis.zip $INSTALLPATH
       	unzip -d $INSTALLPATH `ls $TCTPATH/package/install/ | grep -i redis` >> $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
       	#$INSTALLPATH/redis/bin/redis-server  $INSTALLPATH/redis/conf/6379.conf
	echo -e "\033[34mRedis installed successfully!!!\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
}
jdkinstall(){
	#判断目的地址是否存在相同的应用
        if [ -e $INSTALLPATH/jdk1.8.0_131 ];then
                read -p "There is a jdk1.8.0_131 in $INSTALLPATH,dou you want to remove it?(y/n)" TCTOPTION
                case $TCTOPTION in
                        y)
                                #cd $INSTALLPATH
                                mkdir -p $TCTPATH/package/backup/$INSTALLOPTION-`date +%Y-%m-%d-%H:%M:%S`/
                                mv $INSTALLPATH/jdk1.8.0_131 $TCTPATH/package/backup/$INSTALLOPTION-`date +%Y-%m-%d-%H:%M:%S`/
                                echo "The old $INSTALLOPTION have been moved to $TCTPATH/package/backup/$INSTALLOPTION-`date +%Y-%m-%d-%H:%M:%S`/" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
                                echo "start to install a new $INSTALLOPTION,please waiting..." 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log;;
                        n)
                                echo "You choosed no,we have done noting,exiting" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
                                exit 3;;
                esac
        fi
	cd $TCTPATH/package/install/
	echo -e "\033[33mStart to install jdk,the INSTALLPATH is $INSTALLPATH,please waiting\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	#\cp -a ./package/install/jdk1.8.0_131.zip $INSTALLPATH
       	unzip -d $INSTALLPATH `ls $TCTPATH/package/install/ | grep -i jdk` >> $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
	echo -e "\033[34mJDK installed successfully!!!\033[0m" 2>&1| tee -a $TCTPATH/logs/tctconfig-`date +%Y-%m-%d`.log
}
		#cat "export JAVA_HOME=$INSTALLPATH/jdk1.8.0_131" >> $INSTALLPATH/tomcat8/bin/catalina.out
        	#cat "export JRE_HOME=$INSTALLPATH/jdk1.8.0_131/jre" >> $INSTALLPATH/tomcat8/bin/catalina.out
        	#cat ""JAVA_OPTS="-Xms2048m -Xmx2048m -XX:PermSize=512M -XX:MaxNewSize=1024m -XX:MaxPermSize=512m  -Djava.awt.headless=true  -noverify -Dfastjson.parser.safeMode=true" >> $INSTALLPATH/tomcat8/bin/catalina.out
install(){
case $INSTALLOPTION in
	tomcat)
		tctinstall;;
	redis)
		redisinstall;;
	jdk)
		jdkinstall;;
	full)
		INSTALLOPTION=tomcat
		tctinstall
		INSTALLOPTION=redis
		redisinstall
		INSTALLOPTION=jdk
		jdkinstall;;
esac
}
CONFIGURE(){

	case $CONFIGURATION in
	
		b)
			backup;;
        	tb)
                	testbackup;;
        	r)
                	tctrestart;;
        	u)
                	backup
			if [ -Z `ls -A $TCTPATH/package/update` ];then
				echo -e "\033[31merror\033[0m,Update files don't exist,Please put it in $TCTPATH/package/update/";
				exit 4
			else 
				update;
			fi;;
        	tu)
                	if [ -Z `ls -A $TCTPATH/package/update` ];then
                                echo -e "\033[31merror\033[0m,Update files don't exist,Please put it in $TCTPATH/package/update/";
                        	exit 5;
			else
                                update;
                        fi;;
        	sh)
			tctshut;;
		st)
			tctstart;;
		l)
                	tail -1000f $TOMCATPATH/logs/catalina.out;;
		i)
			install;;
		c)
			clean;;
	esac
}

if [ $MODE = PRO ];then
	TOMCATVERSION=$2;
    	TOMCATPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $2 }'`;
	ROOTPATH=`cat $TCTPATH/conf/tct.conf | grep $TOMCATVERSION | awk -F':' '{ print $3 }'`;
	CONFIGURE;
else
	CONFIGURE;		
fi
