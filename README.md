<b><h2>中文使用手册</h2></b>

预安装cron服务的MySQL镜像(基于官方5.5)，提供任务表和所要运行的脚本即可使用，可使用原有数据库切换到本镜像(可快速实现数据库定时备份)

<b>使用说明</b>

1.将cron任务表(crontab)和执行脚本(如backup.sh)放到容器目录/j-entrypoint/cron-shell下

1.1 crontab
- 默认内容: * 4 * * * /j-entrypoint/cron-shell/backup.sh
- 默认功能: 每天4点运行一次/j-entrypoint/cron-shell/backup.sh
- 注意事项:
（1）任务表文件只能有一个，且文件名必须为crontab
（2）该任务列表属mysql用户，root用户下可通过gosu mysql crontab -l查看

1.2 backup.sh
- 默认功能：将所有数据库导出并按日期命名、压缩，同时删除7天前的备份数据,备份数据在/var/lib/mysql/backup目录下
- 注意事项:
（1）任务脚本可以有多个，没有命名限制。
（2）定时任务是以mysql用户执行的,所以注意用sudo指令提权(不需要密码)
（3）/var/lib/mysql属于mysql用户，不需要额外授予文件操作权限，故建议将新生成文件放到该目录下

2.数据库初始化脚本(.sql或.sql.gz)和容器启动后运行脚本(.sh)放到/docker-entrypoint-initdb.d目录下

<b>使用规范</b>

- docker build 形式

```
docker build -t your-image-name:latest --no-cache=true .
```

- docker run 形式

```
docker run --name mysql -p 3306:3306  --restart=always -v /my/own/cron-shell:/j-entrypoint/cron-shell -v /my/own/init-sql/data.sql:/docker-entrypoint-initdb.d/init.sql  -v /my/own/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 -d jiacy061/mysql-with-cron
```
- 注意事项：仅/my/own/datadir为空时，sql文件会执行。cron-shell文件夹下shell会在每次容器运行后，自动加载；其中，crontab文件必须存在。

<br>
<b><h2>English description</h2></b>

Pre-install the MySQL image of the cron service (based on the official 5.5), provide the task table and the script to be run to use, you can use the original database to switch to this image (can quickly achieve database scheduled backup)

<b>Instructions for use</b>

1.Put the cron task table (crontab) and execution script (such as backup.sh) in the container directory /j-entrypoint/cron-shell

1.1 crontab
- Default content: * 4 * * * /j-entrypoint/cron-shell/backup.sh
- Default function: Run once every 4 points /j-entrypoint/cron-shell/backup.sh
- Precautions:
(1) There can only be one task table file, and the file name must be crontab
(2) The task list belongs to the mysql user, and the root user can view it through gosu mysql crontab -l

1.2 backup.sh
- Default function: Export all databases and name them by date, compress them, and delete backup data 7 days ago. The backup data is in /var/lib/mysql/backup directory.
- Precautions:
(1) There can be multiple task scripts, no naming restrictions.
(2) The scheduled task is executed by the mysql user, so pay attention to the sudo command to raise the weight (no password required)
(3) /var/lib/mysql belongs to mysql user, no additional file operation permission is required, so it is recommended to put the newly generated file in this directory.

2.The database initialization script (.sql or .sql.gz) and the running script (.sh) after the container is started are placed in the /docker-entrypoint-initdb.d directory.

<b>Usage Specifications</b>

- docker build

```
docker build -t your-image-name:latest --no-cache=true .
```

- docker run

```
docker run --name mysql -p 3306:3306  --restart=always -v /my/own/cron-shell:/j-entrypoint/cron-shell -v /my/own/init-sql/data.sql:/docker-entrypoint-initdb.d/init.sql  -v /my/own/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 -d jiacy061/mysql-with-cron
```

- Note: The sql file will be executed only if /my/own/datadir is empty. The shell in the cron-shell folder will be loaded automatically after each container run; the crontab file must exist.
