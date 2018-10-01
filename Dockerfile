FROM node:9

MAINTAINER Rion Dooley <deardooley@gmail.com>

RUN apt-get update && \
    apt-get install -y git && \
    npm install --global slack-history-export@1.1.0

COPY export_slack.sh /usr/local/bin/export_slack.sh

ENV SLACK_KEY ''
ENV SSH_PRIVATE_KEY $$HOME/.ssh/id_rsa

VOLUME /data

CMD ["export_slack.sh"]