# Hadoop Ecosystem

-    The project setup basic `Hadoop Ecosystem` includes: `Apache Hive`, `Apache Spark`, `JDBC MySQL`, `Apache Sqoop`.
-    Use `Docker` to install the project

## Installation

-    Step 1: CD to `/sqoop_server_hdfs`

```bash
    cd ./sqoop_server_hdfs
    ./download.sh
```

-    `./download.sh` will download packages from internet and saved in `/sqoop_server_hdfs/packages` (this is a folder contain all component).

-    Step 2: Execute command will run all container:

```bash
    docker-compose up --build -d
```

-    Step 3: Create and grant permission for user _MySQL_:

```bash
    GRANT ALL PRIVILEGES ON sakila.*  TO 'hdfs_part_1'@'%';
    CREATE DATABASE sakila;
```

-    Step 4: Import Sample data from `sakila-db.zip`:

```bash
    curl -Lo ./sakila-db.zip http://downloads.mysql.com/docs/sakila-db.zip
    unzip ./sakila-db.zip
    cat sakila-db/sakila-schema.sql | docker exec -i mysql_hdfs_part_1 mysql -u hdfs_part_1 --password=hdfs_part_1 sakila
    cat sakila-db/sakila-data.sql | docker exec -i mysql_hdfs_part_1 mysql -u hdfs_part_1 --password=hdfs_part_1 sakila

    rm -rf unzip sakila-db

    # Check sample data
    docker exec -i mysql_hdfs_part_1 mysql -u hdfs_part_1 --password=hdfs_part_1 -e "select film_id, title from sakila.film limit 1"
```

-    Finally, this is easy!

-    **NOTE:** you can edit project config from files in path `/sqoop_server_hdfs/` like: `hdfs-site.xml` (_namenode.dir_, _datanode.dir_), `hive-site.xml` (_ConnectionURL_, _ConnectionUserName_, _ConnectionPassword_, _JDBC Driver_)

-    `import.sh` contains sqoop script import data from MySQL.

## Authors

-    [@vinhphan812](https://www.github.com/vinhphan812)
