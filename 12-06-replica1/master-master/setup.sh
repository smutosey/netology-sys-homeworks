#!/bin/bash
sql_replica_user='CREATE USER "replica_user"@"%" IDENTIFIED BY "123replica"; GRANT REPLICATION SLAVE ON *.* TO "replica_user"@"%"; FLUSH PRIVILEGES;'
docker exec master-one sh -c "mysql -u root -p123456 -e '$sql_replica_user'"
docker exec master-two sh -c "mysql -u root -p123456 -e '$sql_replica_user'"
MS_STATUS=`docker exec master-one sh -c 'mysql -u root -p123456 -e "SHOW MASTER STATUS"'`
CURRENT_LOG=`echo $MS_STATUS | awk '{print $6}'`
CURRENT_POS=`echo $MS_STATUS | awk '{print $7}'`
sql_set_master_one="STOP SLAVE; CHANGE MASTER TO MASTER_HOST='master-two',MASTER_USER='replica_user',MASTER_PASSWORD='123replica',MASTER_LOG_FILE='$CURRENT_LOG',MASTER_LOG_POS=$CURRENT_POS; START SLAVE;"
sql_set_master_two="STOP SLAVE; CHANGE MASTER TO MASTER_HOST='master-one',MASTER_USER='replica_user',MASTER_PASSWORD='123replica',MASTER_LOG_FILE='$CURRENT_LOG',MASTER_LOG_POS=$CURRENT_POS; START SLAVE;"
start_master_one_cmd='mysql -u root -p123456 -e "'
start_master_one_cmd+="$sql_set_master_one"
start_master_one_cmd+='"'
start_master_two_cmd='mysql -u root -p123456 -e "'
start_master_two_cmd+="$sql_set_master_two"
start_master_two_cmd+='"'
docker exec master-one sh -c "$start_master_one_cmd"
docker exec master-one sh -c "mysql -u root -p123456 -e 'SHOW SLAVE STATUS \G'"
docker exec master-two sh -c "$start_master_two_cmd"
docker exec master-two sh -c "mysql -u root -p123456 -e 'SHOW SLAVE STATUS \G'"
