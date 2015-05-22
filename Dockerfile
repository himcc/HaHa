FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y openssh-server vim supervisor git subversion
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config
RUN mkdir -p ~/.ssh && ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys

RUN mkdir -p /home/workspace && cd /home/workspace && wget -nv  --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.tar.gz && tar zxf jdk-8u45-linux-x64.tar.gz  && rm -f jdk-8u45-linux-x64.tar.gz && ln -s  jdk1.8.0_45/ java
RUN cd /home/workspace && wget -nv  http://mirror.bit.edu.cn/apache/hadoop/common/stable/hadoop-2.6.0.tar.gz && tar zxf hadoop-2.6.0.tar.gz  && rm -f hadoop-2.6.0.tar.gz && ln -s hadoop-2.6.0 hadoop
RUN cd /home/workspace && wget -nv  http://mirror.bit.edu.cn/apache/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz && tar zxf apache-maven-3.3.3-bin.tar.gz  && rm -f apache-maven-3.3.3-bin.tar.gz && ln -s apache-maven-3.3.3 maven


RUN sed -ir 's/${JAVA_HOME}/\/home\/workspace\/java/g' /home/workspace/hadoop/etc/hadoop/hadoop-env.sh
COPY core-site.xml /home/workspace/hadoop/etc/hadoop/core-site.xml
COPY hdfs-site.xml /home/workspace/hadoop/etc/hadoop/hdfs-site.xml
COPY mapred-site.xml /home/workspace/hadoop/etc/hadoop/mapred-site.xml
COPY yarn-site.xml /home/workspace/hadoop/etc/hadoop/yarn-site.xml
COPY start-dfs.conf /etc/supervisor/conf.d/start-dfs.conf
COPY start-yarn.conf /etc/supervisor/conf.d/start-yarn.conf
COPY sshd.conf /etc/supervisor/conf.d/sshd.conf
COPY bashrc /tmp/bashrc
RUN cat /tmp/bashrc >> ~/.bashrc

ENV WORKSPACE /home/workspace
ENV JAVA_HOME $WORKSPACE/java
ENV PATH $JAVA_HOME/bin:$PATH
ENV CLASSPATH $JAVA_HOME/lib/*.jar:$JAVA_HOME/jre/lib/*.jar
ENV HADOOP_HOME $WORKSPACE/hadoop
ENV HADOOP_PREFIX $WORKSPACE/hadoop
ENV HADOOP_COMMON_HOME ${HADOOP_HOME}
ENV HADOOP_HDFS_HOME ${HADOOP_HOME}
ENV HADOOP_MAPRED_HOME ${HADOOP_HOME}
ENV YARN_HOME ${HADOOP_HOME}
ENV HADOOP_LOG_DIR ${HADOOP_HOME}/logs
ENV YARN_LOG_DIR ${HADOOP_LOG_DIR}
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/etc/hadoop
ENV YARN_CONF_DIR ${HADOOP_CONF_DIR}
ENV HADOOP_COMMON_LIB_NATIVE_DIR $HADOOP_HOME/lib/native
ENV HADOOP_OPTS "-Djava.library.path=${HADOOP_HOME}/lib/native"
ENV PATH ${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:$PATH

RUN hdfs namenode -format



EXPOSE 22 50070 8088
CMD /usr/bin/supervisord -n
