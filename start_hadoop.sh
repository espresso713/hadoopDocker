docker rm -f master
docker rm -f slave1
docker rm -f slave2

docker run -it --name master -p 8081:50070 -d ubuntu:hadoop
docker run -it --name slave1 --link master:master -d ubuntu:hadoop
docker run -it --name slave2 --link master:master -d ubuntu:hadoop

#IP
mkdir tmpIP
touch tmpIP/slave1IP
touch tmpIP/slave2IP

echo slave1 $(docker inspect --format="{{.NetworkSettings.Networks.bridge.IPAddress}}" slave1) >> tmpIP/slave1IP
echo slave2 $(docker inspect --format="{{.NetworkSettings.Networks.bridge.IPAddress}}" slave2) >> tmpIP/slave2IP

docker exec -i master sh -c 'cat >> /etc/hosts' < tmpIP/slave1IP
docker exec -i master sh -c 'cat >> /etc/hosts' < tmpIP/slave2IP

rm -r tmpIP

#slaves
mkdir tmpSlaves
touch tmpSlaves/slaves

echo master >> tmpSlaves/slaves
echo slave1 >> tmpSlaves/slaves
echo slave2 >> tmpSlaves/slaves

docker exec -i master sh -c 'cat >> $HADOOP_CONFIG_HOME/slaves' < tmpSlaves/slaves

rm -r tmpSlaves



