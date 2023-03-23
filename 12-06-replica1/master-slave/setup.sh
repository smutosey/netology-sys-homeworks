#!/bin/bash
sql_slave_user='CREATE USER "replica_user"@"%" IDENTIFIED BY "123replica"; GRANT REPLICATION SLAVE ON *.* TO "replica_user"@"%"; FLUSH PRIVILEGES;'
docker exec master-one sh -c "mysql -u root -p123456 -e '$sql_slave_user'"
MS_STATUS=`docker exec master-one sh -c 'mysql -u root -p123456 -e "SHOW MASTER STATUS"'`
CURRENT_LOG=`echo $MS_STATUS | awk '{print $6}'`
CURRENT_POS=`echo $MS_STATUS | awk '{print $7}'`
sql_set_master="CHANGE MASTER TO MASTER_HOST='master-one',MASTER_USER='replica_user',MASTER_PASSWORD='123replica',MASTER_LOG_FILE='$CURRENT_LOG',MASTER_LOG_POS=$CURRENT_POS; START SLAVE;"
start_slave_cmd='mysql -u root -p123456 -e "'
start_slave_cmd+="$sql_set_master"
start_slave_cmd+='"'
docker exec slave-one sh -c "$start_slave_cmd"
docker exec slave-one sh -c "mysql -u root -p123456 -e 'SHOW SLAVE STATUS \G'"