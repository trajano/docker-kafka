FROM alpine AS download-and-extract
ARG KAFKA_PROTOCOL=2.1.2
ARG KAFKA_VERSION=2.2.0
WORKDIR /tmp
RUN wget -q http://apache.mirror.globo.tech/kafka/${KAFKA_VERSION}/kafka_${KAFKA_PROTOCOL}-${KAFKA_VERSION}.tgz && \
  tar -xzf ${KAFKA_VERSION}.tgz && \
  rm -rf ${KAFKA_VERSION}/site-docs ${KAFKA_VERSION}/bin/windows

FROM openjdk:8u191-jre-alpine3.9
ARG KAFKA_VERSION=kafka_2.11-2.1.0
COPY --chown=bin:bin --from=download-and-extract /tmp/${KAFKA_VERSION} /opt/kafka
COPY --chown=bin:bin docker-entrypoint.sh /
RUN chmod 550 /docker-entrypoint.sh && apk -U add bash tini
WORKDIR /opt/kafka
ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]
ENV ZOOKEEPER_HEAP_OPTS="-Xms64m -Xmx64m" \
  KAFKA_HEAP_OPTS="-Xms256m -Xmx256m"
USER bin
CMD [ "kafka" ]
EXPOSE 9092 2181
