#!/bin/bash

: ${HADOOP_HOME:=/usr/local/hadoop}

$HADOOP_HOME/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

sudo rm -r /app/hadoop/tmp
sudo mkdir -p /app/hadoop/tmp
sudo chown root:root /app/hadoop/tmp
sudo chmod 750 /app/hadoop/tmp

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_HOME/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

# /usr/local/hadoop/etc/hadoop/core-site.xml store hadoop configuration
sed s/HOSTNAME/$HOSTNAME/ $HADOOP_HOME/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml

/usr/sbin/sshd
$HADOOP_HOME/bin/hdfs namenode -format

$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
$HADOOP_HOME/bin/mapred --daemon start historyserver

$HADOOP_HOME/bin/hdfs dfsadmin -safemode leave

$HADOOP_HOME/bin/hdfs dfs -mkdir /user
$HADOOP_HOME/bin/hdfs dfs -mkdir /user/root

/bin/bash
