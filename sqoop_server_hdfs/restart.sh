#!/bin/bash

sudo rm -R /tmp/*

sudo rm -r /app/hadoop/tmp
sudo mkdir -p /app/hadoop/tmp
sudo chown root:root /app/hadoop/tmp
sudo chmod 750 /app/hadoop/tmp

hdfs namenode -format

$HADOOP_HOME/sbin/stop-all.sh

$HADOOP_HOME/sbin/start-dfs.sh

$HADOOP_HOME/sbin/start-yarn.sh

jps