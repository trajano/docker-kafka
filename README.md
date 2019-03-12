# Kafka in Docker

This is based on the idea from spotify/kafka which provides a single image containing both kafka and zookeeper.  The intent of this image is primarily to support development while production systems may use a managed solution like Amazon MSK.

This follows the instruction of the [Kafka quickstart](https://kafka.apache.org/quickstart)

## Memory

`ZOOKEEPER_HEAP_OPTS` and `KAFKA_HEAP_OPTS` specify the heap sizes.  It is not recommended to use the cgroup limits (i.e. `-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap`) unless you plan to give it ample size which is around 1GB.  The sizes set allow the container to run with a memory limit of 256MB (with swap).

## Advertised host port

The default advertised host port is `localhost:9092`.  If this needs to change set the environment `KAFKA_ADVERTISED_HOST_PORT`.
