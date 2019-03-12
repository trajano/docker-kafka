# Kafka in Docker

This is based on the idea from spotify/kafka which provides a single image containing both kafka and zookeeper.  The intent of this image is primarily to support development while production systems may use a managed solution like Amazon MSK.

This follows the instruction of the [Kafka quickstart](https://kafka.apache.org/quickstart)

## Advertised host port

The default advertised host port is `localhost:9092`.  If this needs to change set the environment `KAFKA_ADVERTISED_HOST_PORT`.
