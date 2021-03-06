# tctconfig

实现通过脚本自动部署备份，重启，更新tomcat系统

详细文档及配置内容，请查看https://www.danielw7.com/tctconfig/

1、安装步骤

a)root账户或有权限访问/etc,/usr/bin的账户可用software模式

		bash tctcofig-xx.run -sw|--software(可直接下载tctconfig-xx.run,或者在源码包中可找到tctconfig-xx.run)

	卸载

 		removtct

		若是无法找到removtct,说明程序未安装

b)所有用户都可用script模式部署(默认部署路径为$HOME)

		bash tctcofig-xx.run -sc|--script(可直接下载tctconfig-xx.run,或者在源码包中可找到tctconfig-xx.run)

	卸载

 		removtct

		若是无法找到removtct,说明程序未安装

2、命令格式

	tctconf [OPTION] [TOMCATVERSION] [COUNT] [CLEAN_OPTION] [filename]

Option:

	-b|--backup
        
		备份对应的tomcat根路径的所有文件，生成ROOTPATHYYYY-MM-DD-HH:MM:SS.zip格式的备份文件，直接放置于根路径所在的父目录中

		例：tctconfig -b waibao(备份外包对应的程序文件)

	-tb|--testbackup
    
		测试前的备份，备份对应的tomcat根路径的所有文件，生成ROOTPATHYYYY-MM-DD-HH:MM:SSTB.zip格式的备份文件，直接放置于根路径所在的父目录中

		例：tctconfig -tb waibao(备份外包对应的程序文件)
    
	-r|--restart
    
		重启对应的tomcat，并查看catliana.out日志

		例：tctconfig -r waibao(重启外包对应的tomcat，并查看日志)

	-u|--update

		更新对应的tomcat，有4个步骤；
		 1、备份对应的tomcat，类似-b命令
		 2、关闭对应的tomcat，类似-sh命令
		 3、更新文件，将$PACKAGE_PATH/packages/update文件夹下面的所有更新文件拷贝到$TOMCATPATH/webapps/$ROOTPATH中，并覆盖重复的文件
		 4、清理更新文件，将$PACKAGE_PATH/packages/update文件夹下面的所有更新文件移动到./tctconfig/packages/backup/$TOMCATVERSION/YYYY-MM-DD-HH:MM:SS文件夹中
		 5、开启对应tomcat，类似-st命令
		
		例：tctconfig -u waibao(更新外包对应的程序文件，并重启)

	-tu|--testupdate
    
		更新测试文件，不进行备份操作，只更新文件，重启tomcat，相当于-u的2，3，4功能
		建议进行测试更新之前执行以下tctconfig -tb TOMCATVERSION，进行一下备份，避免出现不必要的损失

		例：tctconfig -tb waibao(更新外包对应的程序文件，并重启)
	
	-tg|--tgupdate

		同时进行两个或者多个系统的更新，可通过配置tgupdate函数进行调整

		例：tctconfig -tg(同时更新tgupdate里面配置的两个tomcat)

	-sh|--shutdown

		关闭对应的tomcat

		例：tctconfig -sh waibao(关闭外包)
    
	-st|--startup
    
		开启对应的tomcat

		例：tctconfig -st waibao(开启外包)

	-l|--log
    
		查看对应的tomcat的catalina.out的日志，使用格式:
			multi模式：tctconfig -l TOMCATVERSION [COUNT]
				例：tctconfig -l vm(查看vm对应的系统的日志,并持续输出)
		    	tctconfig -l vm 1000(查看vm对应的系统的最近1000行的日志，并持续输出)	
			
			single模式：tctconfig -l [COUNT]
				例: tctconfig -l(查看single tomcat对应的系统的日志,并持续输出)
                tctconfig -l 1000(查看vm对应的系统的最近1000行的日志，并持续输出)

 	-i|--install

		安装部署tomcat，jdk，redis，可以选择需要的组件进行安装，安装文件位置为tctconfig/package/install

		例：tctconfig -i tomcat(全新部署tomcat)
    
	-c|--clean
    
		清理日志，更新备份文件和残留进程，清理缓存，可用y/n选择清理对应的文件

		例：
			tctconfig -c (清理所有，可以输入y/n来选择)

			tctconfig -c log (清理tctconfig/logs下面的日志)

			tctconfig -c bak (清理tctconfig/package/backup下面的备份文件)

			tctconfig -c cache (清理缓存)



	-h|--help 
    
		查看帮助

		例：
			tctconfig -h

tct.conf:
	
	tctconfig的配置文件,用于配置tctconfig的运行模式以及应用信息。
	
	TOMCATVERSION:
        	为tomcat的版本名称，版本信息位于/etc/tct.conf或者$HOME/tctconfig/conf/tct.conf中，以分号隔开
        例：
        	vm:/opt/webserver/tomcat8:ROOT
        	tomcat版本:tomcat部署路径:根路径

	PROGRAM_MODE:
		程序的运行模式，分为单系统模式（single）和多系统模式（multi），
	SINGLE_PATH:
		后面跟的是单用户模式的应用信息。
		模式为TOMCATVERSION:TOMCATPATH:ROOTPATH
	MULTI_name:
		通过此配置文件可配置多个tomcat，后面的tomcat名称用空格隔开，name为关键字
		例：MULTI_name:tomcat tomcat2 tomcat3

