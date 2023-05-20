#!/bin/bash

sqoop import --connect jdbc:mysql://mysql/sakila --username hdfs_part_1 --password hdfs_part_1 --table film --m 1

sqoop import --connect jdbc:mysql://mysql/sakila --username hdfs_part_1 --password hdfs_part_1 --table rental --m 4 --target-dir /user/root/rental_2018/

sqoop import --connect jdbc:mysql://mysql/sakila --username hdfs_part_1 --password hdfs_part_1 --table film --m 1 --where "rating='PG-13'" --target-dir /user/root/film_pg_13

sqoop import --connect jdbc:mysql://mysql/sakila --username hdfs_part_1 --password hdfs_part_1 --query "SELECT language_id, name FROM language WHERE language_id<=3 AND \$CONDITIONS" --target-dir /data/language_1 --m 1 --verbose 

sqoop job --create import_film -- import --connect jdbc:mysql://mysql/sakila --username hdfs_part_1 --password hdfs_part_1 --table film --target-dir /data/film_job --m 1 --verbose 

sqoop list-databases --connect jdbc:mysql://mysql --username hdfs_part_1 --password hdfs_part_1
sqoop list-tables --connect jdbc:mysql://mysql/sakila --username hdfs_part_1 --password hdfs_part_1
