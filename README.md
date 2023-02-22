# HaHa

HaHa是一个用于功能测试的hadoop环境。

HaHa是个hadoop伪分布式环境，在一个节点上启动了namenode，datanode，resourcemanager，nodemanager。主要用于mapreduce job的功能测试。除java和hadoop外，HaHa还安装了maven，git，svn，方便编译job。HaHa的base image是ubuntu 14.04。容器启动之后，hadoop的相关进程就启动了，ssh进去后可以直接跑job。

软件版本：
* java:jdk-8u45-linux-x64
* hadoop:hadoop-2.6.0
* maven:apache-maven-3.3.3

Usage：
<pre>
git clone https://github.com/himcc/HaHa.git
cd HaHa && docker build -t haha .
docker run -d -p 2222:22 8088:8088 haha
ssh -p 2222 root@localhost (password:root)
</pre>
参考：[Hadoop Pseudo-Distributed operation](http://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html#Pseudo-Distributed_Operation)

启动是靠supervisord 的.conf配置。这么多年居然忘了
