#!/bin/sh
set -e
echo "$0 $*"
user="$1"
password="$2"
host="$3"
port="$4"
zstack_ui_db_password="$5"

base=`dirname $0`
flyway="$base/tools/flyway-3.2.1/flyway"
flyway_sql="$base/tools/flyway-3.2.1/sql/"

mysql --user=$user --password=$password --host=$host --port=$port << EOF
DROP DATABASE IF EXISTS zstack_ui;
CREATE DATABASE zstack_ui;
grant all privileges on zstack_ui.* to root@'%' identified by "$password";
grant all privileges on zstack_ui.* to root@'localhost' identified by "$password";
EOF

rm -rf $flyway_sql
mkdir -p $flyway_sql

ui_schema_path="/usr/local/zstack/zstack-ui/tmp/WEB-INF/classes/db/migration/"
if [ -d $ui_schema_path ]; then
    cp $ui_schema_path/* $flyway_sql
    url="jdbc:mysql://$host:$port/zstack_ui"
    bash $flyway -user=$user -password=$password -url=$url clean
    bash $flyway -user=$user -password=$password -url=$url migrate
    eval "rm -f $flyway_sql/*"
fi

hostname=`hostname`
mysql --user=$user --password=$password --host=$host --port=$port << EOF
drop user zstack_ui;
create user 'zstack_ui' identified by "$zstack_ui_db_password";
grant usage on *.* to 'zstack_ui'@'localhost';
grant usage on *.* to 'zstack_ui'@'%';
grant all privileges on zstack_ui.* to zstack_ui@'localhost' identified by "$zstack_ui_db_password";
grant all privileges on zstack_ui.* to zstack_ui@'%' identified by "$zstack_ui_db_password";
grant all privileges on zstack_ui.* to zstack_ui@"$hostname" identified by "$zstack_ui_db_password";
flush privileges;
EOF