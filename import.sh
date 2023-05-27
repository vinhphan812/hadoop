cat ./hive-schema-3.1.0.mysql.sql | docker exec -i mysql_hdfs_part_1 mysql -uroot --password=hdfs_part_1 metastore_db

#!/bin/bash

sqoop import --connect jdbc:mysql://mysql/sakila --username hdfs_part_1 --password hdfs_part_1 --table film --m 1

sqoop import --connect jdbc:mysql://mysql/sakila --username hdfs_part_1 --password hdfs_part_1 --table rental --m 4 --target-dir /user/root/rental_2018/

sqoop import --connect jdbc:mysql://mysql/sakila --username hdfs_part_1 --password hdfs_part_1 --table film --m 1 --where "rating='PG-13'" --target-dir /user/root/film_pg_13

sqoop import --connect jdbc:mysql://mysql/sakila --username hdfs_part_1 --password hdfs_part_1 --query "SELECT language_id, name FROM language WHERE language_id<=3 AND \$CONDITIONS" --target-dir /root/user/language_1 --split-by language_id --m 3 --verbose

sqoop import --connect jdbc:mysql://mysql/sakila --username hdfs_part_1 --password hdfs_part_1 --query "SELECT language_id, name FROM language WHERE language_id<=3 AND \$CONDITIONS" --split-by language_id --m 3 --target-dir /user/root/language_parquet --verbose --as-parquetfile

sqoop job --create import_film -- import --connect jdbc:mysql://mysql/sakila --username hdfs_part_1 --password hdfs_part_1 --table film --target-dir /user/root/film --m 1 --verbose 

sqoop job --create import_film_hive -- import --connect jdbc:mysql://mysql/sakila --username hdfs_part_1 --password-file file://$SQOOP_HOME/conf/sqoop.password --table film --target-dir /user/root/film --m 5 --verbose --hive-import --create-hive-table --hive-table film

sqoop list-databases --connect jdbc:mysql://mysql --username hdfs_part_1 --password hdfs_part_1
sqoop list-tables --connect jdbc:mysql://mysql/sakila --username hdfs_part_1 --password hdfs_part_1
