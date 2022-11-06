#!/bin/bash
# 变量
mysqlRealCommand="MYSQL_REAL_COMMAND"
mysqlUsername="MYSQL_USERNAME"
mysqlPassword="MYSQL_PASSWORD"
databaseOldName="DATABASE_OLD_NAME"
databaseNewName="DATABASE_NEW_NAME"
sqlFileName="SQL_FILE_NAME"
mysqldumpRealCommand="MYSQLDUMP_REAL_COMMAND"
packageSource="PACKAGE_SOURCE"

if $mysqlRealCommand -u"$mysqlUsername" -p"$mysqlPassword" <<< "CREATE DATABASE IF NOT EXISTS $databaseNewName;" >/dev/null 2>&1; then
    echo "新数据库创建完成"
else
    echo "新数据库创建失败，请手动检查环境"
fi

if $mysqldumpRealCommand -u"$mysqlUsername" -p"$mysqlPassword" $databaseOldName | $mysqlRealCommand -u"$mysqlUsername" -p"$mysqlPassword" $databaseNewName >/dev/null 2>&1; then
    echo "上一版本数据库迁移完成"
else
    echo "上一版本数据库迁移失败，请手动检查环境"
fi
$mysqlRealCommand -u"$mysqlUsername" -p"$mysqlPassword" <<EOF
USE $databaseNewName;
source /tmp/$packageSource/$sqlFileName
EOF
if [ "$?" -eq 0 ]; then
    echo "项目数据导入成功"
else
	echo "项目数据导入出现问题，请手动检查环境"
fi
echo ""

