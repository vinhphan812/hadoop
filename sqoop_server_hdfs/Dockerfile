FROM dvoros/hadoop:3.1.0

USER root

# env
ENV SQOOP_HOME /usr/local/sqoop
ENV SPARK_HOME /usr/local/spark
ENV HIVE_HOME /hive
ENV MYSQL_JAR_VERSION 5.1.46
ENV SPARK_VERSION 3.3.0
ENV HIVE_VERSION 3.1.2

ENV HDFS_NAMENODE_USER root
ENV HDFS_DATANODE_USER root
ENV HDFS_SECONDARYNAMENODE_USER root
ENV YARN_RESOURCEMANAGER_USER root
ENV YARN_NODEMANAGER_USER root


# install zip & unzip
RUN yum install zip unzip -y

RUN yum install cronie


# install sqoop for Hadoop
# RUN curl -s https://archive.apache.org/dist/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz | tar -xz -C /usr/local
# RUN ln -s /usr/local/sqoop-1.4.7.bin__hadoop-2.6.0 $SQOOP_HOME

COPY /packages /tmp/packages
RUN ls /tmp/packages
RUN tar -xzf /tmp/packages/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz -C /tmp/packages \
     && mv /tmp/packages/sqoop-1.4.7.bin__hadoop-2.6.0 $SQOOP_HOME

RUN cp /tmp/packages/java-json.jar.zip $SQOOP_HOME/lib && unzip $SQOOP_HOME/lib/java-json.jar.zip -d $SQOOP_HOME/lib

# install JDBC MySQL
RUN tar -xvf /tmp/packages/mysql-connector-java-$MYSQL_JAR_VERSION.tar.gz -C /tmp/packages \
     && mv /tmp/packages/mysql-connector-java-$MYSQL_JAR_VERSION/mysql-connector-java-$MYSQL_JAR_VERSION-bin.jar $SQOOP_HOME/lib/

# RUN mkdir -p /tmp/jdbc \
#    && curl -Lo /tmp/mysql-connector-java-$MYSQL_JAR_VERSION.tar.gz https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-$MYSQL_JAR_VERSION.tar.gz \
#    && tar -xvf /tmp/mysql-connector-java-$MYSQL_JAR_VERSION.tar.gz -C /tmp/jdbc \
#    && rm /tmp/mysql-connector-java-$MYSQL_JAR_VERSION.tar.gz \
#    && mv /tmp/jdbc/mysql-connector-java-$MYSQL_JAR_VERSION/mysql-connector-java-$MYSQL_JAR_VERSION-bin.jar $SQOOP_HOME/lib/ \
#    && rm -rf /tmp/mysql-connector-java-$MYSQL_JAR_VERSION/

# install HIVE for Hadoop
RUN tar -xvf /tmp/packages/apache-hive-$HIVE_VERSION-bin.tar.gz -C /tmp \
     && mv /tmp/apache-hive-$HIVE_VERSION-bin /hive
     
# RUN curl -O https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
#    tar xzf apache-hive-$HIVE_VERSION-bin.tar.gz && \
#    mv apache-hive-$HIVE_VERSION-bin /hive && \
#    rm apache-hive-$HIVE_VERSION-bin.tar.gz

# copy JDBC MySQL from SQOOP lib to HIVE lib
RUN cp $SQOOP_HOME/lib/mysql-connector-java-$MYSQL_JAR_VERSION-bin.jar $HIVE_HOME/lib/mysql-connector-java-$MYSQL_JAR_VERSION-bin.jar

# install SPARK for Hadoop
RUN tar -xzf /tmp/packages/spark-3.3.0-bin-hadoop3.tgz -C /tmp/packages/ && \
     mv /tmp/packages/spark-3.3.0-bin-hadoop3 $SPARK_HOME

# RUN curl -L https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz \
#    | tar -xz -C /usr/local/ && \
#    mv /usr/local/spark-${SPARK_VERSION}-bin-hadoop3 /usr/local/spark

# Export Hadoop, HIVE, SPARK, SQOOP
ENV PATH $PATH:$HIVE_HOME/bin:$SPARK_HOME/bin:$SPARK_HOME/sbin:$HADOOP_HOME/bin:$SQOOP_HOME/bin

# Export JDBC MySQL
ENV CLASSPATH $CLASSPATH:$SQOOP_HOME/lib/mysql-connector-java-$MYSQL_JAR_VERSION-bin.jar:$HIVE_HOME/lib/mysql-connector-java-$MYSQL_JAR_VERSION-bin.jar

# Copy config for Hadoop, HIVE
COPY hive-site.xml $HIVE_HOME/conf/hive-site.xml
RUN rm -rf $HADOOP_HOME/etc/hadoop/hdfs-site.xml
COPY hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
RUN rm -rf $HADOOP_HOME/etc/hadoop/yarn-site.xml
COPY yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml

# Copy start
COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root.root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

CMD ["/bin/bash -c \"bin/hive --service metastore & bin/hive --service hiveserver2\""]
# Start Hadoop
CMD ["/etc/bootstrap.sh"]

# Expose port for SPARK
EXPOSE 4040 7077 8080
