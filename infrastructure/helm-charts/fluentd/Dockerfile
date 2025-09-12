FROM fluent/fluentd:v1.19-debian-2

USER root

# Install required packages and the Kafka plugin

RUN apt-get update && \
    apt-get install -y build-essential libsnappy-dev && \
    gem install fluent-plugin-kafka && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


USER fluent
