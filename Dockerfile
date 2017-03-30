FROM ubuntu:16.04

#ssh
RUN apt-get update && apt-get install -y openssh-server

RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

#java
RUN apt-get -y install software-properties-common
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -y oracle-java8-installer && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer

#hadoop
RUN mkdir -p /root/soft/apache/hadoop
WORKDIR /root/soft/apache/hadoop
RUN wget https://dist.apache.org/repos/dist/release/hadoop/common/hadoop-2.6.1/hadoop-2.6.1.tar.gz
RUN tar xvzf hadoop-2.6.1.tar.gz

#env
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle 
ENV	HADOOP_HOME=/root/soft/apache/hadoop/hadoop-2.6.1 
ENV	HADOOP_CONFIG_HOME=$HADOOP_HOME/etc/hadoop 
ENV	PATH=$PATH:$HADOOP_HOME/bin 
ENV	PATH=$PATH:$HADOOP_HOME/sbin 

ADD core-site-org.xml $HADOOP_CONFIG_HOME
ADD hdfs-site-org.xml $HADOOP_CONFIG_HOME
ADD mapred-site-org.xml $HADOOP_CONFIG_HOME

WORKDIR $HADOOP_CONFIG_HOME
RUN cp mapred-site.xml.template mapred-site.xml
RUN mv core-site.xml core-site-backup.xml
RUN mv hdfs-site.xml hdfs-site-backup.xml
RUN mv mapred-site.xml mapred-site-backup.xml
RUN mv core-site-org.xml core-site.xml
RUN mv hdfs-site-org.xml hdfs-site.xml
RUN mv mapred-site-org.xml mapred-site.xml
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> hadoop-env.sh









	


