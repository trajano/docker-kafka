#!/bin/bash
set -e

if [ "$1" = 'kafka' ]
then
  KAFKA_HEAP_OPTS="${ZOOKEEPER_HEAP_OPTS}" /opt/kafka/bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
  if [ -e /tmp/kafka-logs/meta.properties ]
  then
    mv /tmp/kafka-logs/meta.properties /tmp/kafka-logs/meta.properties.$(date '+%Y-%m-%dT%H:%M')
  fi
  exec /opt/kafka/bin/kafka-server-start.sh config/server.properties \
    --override listeners=INTERNAL://$HOSTNAME:9091,CLIENT://0.0.0.0:9092 \
    --override listener.security.protocol.map=CLIENT:PLAINTEXT,INTERNAL:PLAINTEXT \
    --override inter.broker.listener.name=INTERNAL \
    --override advertised.listeners=CLIENT://${KAFKA_ADVERTISED_HOST_PORT:-localhost:9092},INTERNAL://$HOSTNAME:9091
elif [ "$1" = 'messages' ]
then
  exec /opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server $HOSTNAME:9091 --topic "$2" --from-beginning
elif [ "$1" = 'topics' ]
then
  exec /opt/kafka/bin/kafka-topics.sh --list --zookeeper $HOSTNAME
fi

exec "$@"
