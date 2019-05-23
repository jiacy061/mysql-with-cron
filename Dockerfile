FROM mysql:5.5.62
  
MAINTAINER Jiacy

#将任务脚本复制进容器,需要注意不能放到/var/lib/mysql目录下,该目录随mysql初始化会被清空造成原文件丢失
COPY j-entrypoint/cron-shell/ /j-entrypoint/cron-shell/
#将任务脚本复制进容器,需要注意不能放到/var/lib/mysql目录下,该目录随mysql初始化会被清空造成原文件丢失
COPY j-entrypoint/cron-shell/ /j-entrypoint/cron-shell/
#将任务脚本复制进容器,需要注意不能放到/var/lib/mysql目录下,该目录随mysql初始化会被清空造成原文件丢失
COPY j-entrypoint/cron-shell/ /j-entrypoint/cron-shell/
#将int-shell中的脚本都复制到初始化文件夹中
COPY j-entrypoint/init-shell/ /j-entrypoint/init-shell/
#将修改后的docker-entrypoint.sh脚本复制到/usr/local/bin/目录
COPY docker-entrypoint.sh /usr/local/bin/

#修正时区
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
      && echo 'Asia/Shanghai' >/etc/timezone \
#更新源
      && apt-get update \
#安装cron
      && apt-get install -y  --no-install-recommends cron \
#安装dos2unix工具
      && apt-get install -y  dos2unix \
#安装sudo
      && apt-get install sudo \
#授予mysql组用户sudo免密码
      && echo '%mysql ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
#减小镜像的体积
      && rm -rf /var/lib/apt/lists/*  \
      && apt-get clean \
#赋予脚本可执行权限
      && chmod a+x -R /j-entrypoint
#更新docker-entrypoint.sh脚本
RUN dos2unix /usr/local/bin/docker-entrypoint.sh \
      && chmod 777 /usr/local/bin/docker-entrypoint.sh  \
      && rm /entrypoint.sh \
      && ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat
