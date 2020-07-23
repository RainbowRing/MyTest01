#!/usr/bin/env bash
#git同步最新代码 > maven 打包 > 停止tomcat > 部署应用 > 启动tomcat
#编译+部署order站点

# 需要配置如下参数
# 项目路径, 在Execute Shell中配置项目路径, pwd 就可以获得该项目路径
# export PROJECT_PATH=这个jenkins任务在部署机器上的路径

# 输入你的环境上tomcat的全路径
# export TOMCAT_PATH=tomcat在部署机器上的路径

### 函数:关闭tomcat
killTomcat()
{
    pid=`ps -ef|grep tomcat|grep java|awk '{print $2}'`
    echo "tomcat Id list :$pid"
    if [ "$pid" = "" ]
    then
      echo "no tomcat pid alive"
    else
      kill -9 $pid
    fi
}

# 删除本地旧代码
rm -rf $PROJECT_PATH/MyTest01
# 拉取新代码
cd $PROJECT_PATH
git clone git@github.com:RainbowRing/MyTest01.git

# 构建项目
#cd $PROJECT_PATH/MyTest01
#mvn clean install

# 停止tomcat
killTomcat

# 删除原有工程
rm -rf $TOMCAT_PATH/webapps/MyTest01
# rm -f $TOMCAT_PATH/webapps/ROOT.war
# rm -f $TOMCAT_PATH/webapps/MyTest01.war

# 复制工程(文件夹)到tomcat
# cp $PROJECT_PATH/order/target/order.war $TOMCAT_PATH/webapps/
cp -r $PROJECT_PATH/MyTest01 $TOMCAT_PATH/webapps/

# 重命名工程
cd $TOMCAT_PATH/webapps/
mv MyTest01 myTest01

# 启动Tomcat
cd $TOMCAT_PATH/
sh bin/startup.sh
