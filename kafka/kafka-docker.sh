#!/bin/bash

: ${KAFKA_BROKER_ID:=0}
: ${KAFKA_PORT:=9092}
: ${KAFKA_NUM_NETWORK_THREADS:=3}
: ${KAFKA_NUM_IO_THREADS:=8}
: ${KAFKA_SOCKET_SEND_BUFFER_BYTES:=102400}
: ${KAFKA_SOCKET_RECEIVE_BUFFER_BYTES:=102400}
: ${KAFKA_SOCKET_REQUEST_MAX_BYTES:=104857600}
: ${KAFKA_LOG_DIRS:=/var/lib/kafka}
: ${KAFKA_NUM_PARTITIONS:=1}
: ${KAFKA_NUM_RECOVERY_THREADS_PER_DATA_DIR:=1}
: ${KAFKA_LOG_RETENTION_HOURS:=168}
: ${KAFKA_LOG_SEGMENT_BYTES:=1073741824}
: ${KAFKA_LOG_RETENTION_CHECK_INTERVAL_MS:=300000}
: ${KAFKA_LOG_CLEANER_ENABLE:=true}
: ${KAFKA_ZOOKEEPER_CONNECT:=$ZOOKEEPER_PORT_2181_TCP_ADDR:$ZOOKEEPER_PORT_2181_TCP_PORT}
: ${KAFKA_ZOOKEEPER_CONNECTION_TIMEOUT_MS:=6000}

export KAFKA_BROKER_ID
export KAFKA_PORT
export KAFKA_NUM_NETWORK_THREADS
export KAFKA_NUM_IO_THREADS
export KAFKA_SOCKET_SEND_BUFFER_BYTES
export KAFKA_SOCKET_RECEIVE_BUFFER_BYTES
export KAFKA_SOCKET_REQUEST_MAX_BYTES
export KAFKA_LOG_DIRS
export KAFKA_NUM_PARTITIONS
export KAFKA_NUM_RECOVERY_THREADS_PER_DATA_DIR
export KAFKA_LOG_RETENTION_HOURS
export KAFKA_LOG_SEGMENT_BYTES
export KAFKA_LOG_RETENTION_CHECK_INTERVAL_MS
export KAFKA_LOG_CLEANER_ENABLE
export KAFKA_ZOOKEEPER_CONNECT
export KAFKA_ZOOKEEPER_CONNECTION_TIMEOUT_MS

echo '# Generated by kafka-docker.sh' > /etc/kafka/server.properties

for var in $(env | grep -v '^KAFKA_LOGS' | grep '^KAFKA_' | sort); do
    key=$(echo $var | sed -r 's/KAFKA_(.*)=.*/\1/g' | tr A-Z a-z | tr _ .)
    value=$(echo $var | sed -r 's/.*=(.*)/\1/g')
    echo "${key}=${value}" >> /etc/kafka/server.properties
done

export KAFKA_LOG4J_OPTS="-Dlog4j.configuration=file:/etc/kafka/log4j.properties"

exec /usr/bin/kafka-server-start /etc/kafka/server.properties
