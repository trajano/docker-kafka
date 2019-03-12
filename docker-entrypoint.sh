#!/bin/bash
set -e

if [ "$1" = 'kafka' ]; then
    /opt/kafka/bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
    exec /opt/kafka/bin/kafka-server-start.sh config/server.properties \
      --override listeners=INTERNAL://$HOSTNAME:9091,CLIENT://0.0.0.0:9092 \
      --override listener.security.protocol.map=CLIENT:PLAINTEXT,INTERNAL:PLAINTEXT \
      --override inter.broker.listener.name=INTERNAL \
      --override advertised.listeners=CLIENT://${KAFKA_ADVERTISED_HOST_PORT:-localhost:9092},INTERNAL://$HOSTNAME:9091
fi

exec "$@"
