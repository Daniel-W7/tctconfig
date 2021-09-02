# tctconfig

tomcat自动重启配置脚本，之后会试着加上一些系统配置相关的内容

# v1.9

更新的时候添加判断语句，若是./package/update文件夹下面无更新文件，则直接退出更新

执行-i安装选项时，若目标目录有相同的安装文件，则可选择是否部署安装

删除clean.sh脚本，tctconfig.sh添加-c选项，可选择清理日志文件和backup文件，顺带清理脚本进程

# v1.8

更新日志文件输出方式，日志名称修改

修改系统显示名称，改为具体的系统tomcat地址，方便定位问题

输出字符添加颜色，方便确认比照

修复部分bug

# v1.7

完善.bat脚本，和新版本tctconfig对应

添加-sh和-st命令，用于单独启动或者关闭tomcat

更新conf文件

调整程序逻辑，精简程序

修复部分bug

# v1.6

修改项目名称和脚本名称为tctconfig

添加配置信息文件tct.conf，放置于conf文件夹中，用于保存tomcat信息

添加logs文件夹，用于放置相关日志

添加clean.sh来清理遗留进程

package目录下添加install目录，用来放置部署文件，tomcat8.zip，redis.zip和jdk1.8.0_131.zip

修改upload目录为update，修改备份文件目录为backup

添加-i选项用于tomcat初始化部署

添加-tb选项用于测试前全包备份

添加-tu选项用于调试的时候仅更新调试文件不做多余的备份

添加-l选项用于查看catalina.out日志

# v1.5

将目录获取指令提到最前面，解决了进行更新时找不到目录的问题

将Linux端更新后的删除更新内容命令修改为了移动命令，在package下面添加了一个old文件夹用于放置更新文件

修复部分bug


# v1.4

将update.sh,backup.sh,restart.sh合并为tctconf.sh,

并且可以通过tctconf.sh -u,-b,-r TOMCATVERSION命令，进行对应版本的系统的更新，备份，重启操作

也可以直接通过tctconf.sh命令进行交互操作

仍然可以通过update.bat进行更新文件从Windows传输到Linux主机，需配置免密码登录

修复更新会误删除Windows端upload文件夹的错误

优化部分bug，

# v1.3

update.sh里面添加目录切换命令，直接切换到此程序根目录，可直接调用根目录shell脚本

update.sh输出内容调整，以适应Windows1界面的显示

update.bat添加清理本地upload文件夹下内容的功能，避免重复更新，并添加登录linux系统之后直接执行update.
sh的功能，可实现自动更新

# v1.2

添加backup.sh,用于备份之前的系统文件，可重复备份

添加update.sh,用于更新，更新之前进行对应安装目录的备份

添加update.bat,用于Windows向linux自动上传更新补丁，补丁位置./package/upload/

添加clean.sh,用于清理可能遗留的shell进程

restart.sh里面添加set -m命令，用于分线程进行脚本执行，避免出现shell脚本关闭，tomcat也被一并关闭的情况

修改tomcat-restart为tomcat-install

调整了一下版本发布方式

# v1.1

加上选项功能，可以进行多个tomcat的管理

# v1.0

重启脚本基础版，仅添加重启单个tomcat功能
