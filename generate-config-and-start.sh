#!/bin/sh

CONF="/var/run/zookeeper/zoo.cfg"
MYID="/var/run/zookeeper/myid"

cat >"${CONF}" <<EOF
tickTime=2000
dataDir=/var/run/zookeeper/
initLimit=20
syncLimit=2
EOF

for i in $(seq "${SERVER_COUNT}"); do
    ip=$(eval echo '$'"SERVER_${i}_VOTE_PORT_2888_TCP_ADDR")
    vote_port=$(eval echo '$'"SERVER_${i}_VOTE_PORT_2888_TCP_PORT")
    elect_port=$(eval echo '$'"SERVER_${i}_ELECT_PORT_3888_TCP_PORT")
    echo "server.${i}=${ip}:${vote_port}:${elect_port}" >> "${CONF}"
done

echo "${SERVER_ID}" > "${MYID}"

echo "CONFIG:"
cat "${CONF}"
echo "MYID:"
cat "${MYID}"
echo "Starting ZooKeeper"

/srv/zookeeper/bin/zkServer.sh start-foreground /var/run/zookeeper/zoo.cfg
