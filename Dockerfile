FROM alpine AS download-and-extract
ARG SCALA_VERSION=2.12
ARG KAFKA_VERSION=2.4.0
WORKDIR /tmp
RUN wget -q \
  http://apache.mirror.globo.tech/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
  tar -xzf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
  rm -rf kafka_${SCALA_VERSION}-${KAFKA_VERSION}/site-docs kafka_${SCALA_VERSION}-${KAFKA_VERSION}/bin/windows

FROM openjdk:12-alpine
ARG SCALA_VERSION=2.12
ARG KAFKA_VERSION=2.4.0
COPY --chown=bin:bin --from=download-and-extract /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka
COPY --chown=bin:bin docker-entrypoint.sh /
RUN chmod 550 /docker-entrypoint.sh && apk -U add bash tini
WORKDIR /opt/kafka
ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]
ENV ZOOKEEPER_HEAP_OPTS="-Xms64m -Xmx64m" \
  KAFKA_HEAP_OPTS="-Xms256m -Xmx256m"
USER bin
CMD [ "kafka" ]
EXPOSE 9092 2181
