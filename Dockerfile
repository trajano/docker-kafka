FROM alpine AS download-and-extract
ARG KAFKA_VERSION=kafka_2.11-2.1.0
WORKDIR /tmp
RUN wget -q http://apache.mirror.globo.tech/kafka/2.1.0/${KAFKA_VERSION}.tgz && \
    tar -xzf ${KAFKA_VERSION}.tgz && \
    rm -rf ${KAFKA_VERSION}/site-docs ${KAFKA_VERSION}/bin/windows

FROM openjdk:8u191-jre-alpine3.9
ARG KAFKA_VERSION=kafka_2.11-2.1.0
COPY --chown=bin:bin --from=download-and-extract /tmp/${KAFKA_VERSION} /opt/kafka
RUN apk -U add bash tini
WORKDIR /opt/kafka
ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]
ENV KAFKA_HEAP_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:+UseG1GC"
USER bin
CMD [ "kafka" ]
#-Xmx6g -Xms6g -XX:MetaspaceSize=96m -XX:+UseG1GC
#-XX:MaxGCPauseMillis=20 -XX:InitiatingHeapOccupancyPercent=35 -XX:G1HeapRegionSize=16M
#-XX:MinMetaspaceFreeRatio=50 -XX:MaxMetaspaceFreeRatio=80
EXPOSE 9092 2181
COPY --chown=bin:bin docker-entrypoint.sh /
RUN chmod 550 /docker-entrypoint.sh
