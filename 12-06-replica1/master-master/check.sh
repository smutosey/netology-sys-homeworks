#!/bin/bash
echo "********* check replication **************"
sql_create_table='CREATE TABLE netology1206mm.nedorezov_test (id integer auto_increment NOT NULL,	description varchar(200), CONSTRAINT first_PK PRIMARY KEY (id));'
docker exec master-one sh -c "mysql -u root -p123456 -e '$sql_create_table'"
sql_insert='INSERT INTO netology1206mm.nedorezov_test (description) VALUES ("hi netology!");'
docker exec master-two sh -c "mysql -u root -p123456 -e '$sql_insert'"
sql_select="SELECT * from netology1206mm.nedorezov_test;"
QUERY_RESULT=`docker exec master-one sh -c "mysql -u root -p123456 -e '$sql_select'"`
echo $QUERY_RESULT