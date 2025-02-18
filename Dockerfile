FROM ubuntu:noble-20241011

ARG PJT_NAME=SchedulingBase
ARG GIT_REPO=
ARG SCRIPT=main.py

# Set telegram token
ARG SYSTEM_TELEGRAM_BOT_TOKEN "SKIP"
ARG SYSTEM_TELEGRAM_BOT_CHAT_ID "SKIP"

ENV HOSTNAME=$PJT_NAME
ENV TZ=Asia/Seoul

# Set Proxy
ENV PROXY_HTTP ""
ENV PROXY_HTTPS ""

# Set dir
ENV APP_DIR="/app" OUTPUT_DIR="/output" LOG_DIR="/log"
VOLUME [ $OUTPUT_DIR, $LOG_DIR ]

RUN apt-get clean
RUN apt-get update -y
RUN apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata
RUN apt-get install -y bash curl python3 procps python3-pip python3-lxml cron libpq-dev wget git

RUN mkdir $APP_DIR
WORKDIR $APP_DIR
# git clone to /app (It MUST be the next line of 'WORKDIR /app')
RUN git clone $GIT_REPO . 

COPY app $APP_DIR
RUN python3 -m pip install -r requirements.txt --break-system-packages

# set crontab
RUN sed -i "s|\${SCRIPT}|${SCRIPT}|g" jobs
RUN sed -i "s|\${HOSTNAME}|${HOSTNAME}|g" jobs
RUN sed -i "s|\${LOG_DIR}|${LOG_DIR}|g" jobs
RUN crontab jobs
RUN env >> /etc/environment

RUN chmod +x status_report_script.sh
RUN chmod +x bootstrap.sh

ENTRYPOINT ${APP_DIR}/bootstrap.sh