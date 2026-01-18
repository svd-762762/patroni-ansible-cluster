FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    postgresql-14 \
    postgresql-server-dev-14 \
    postgresql-contrib-14 \
    python3-pip \
    supervisor \
    openssh-server \
    openssh-client \
    curl \
    net-tools \
    tzdata \
    lsof \
    sudo \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN pip3 install --no-cache-dir patroni[etcd3]==3.0.4 psycopg2-binary pyyaml

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

USER root
RUN mkdir -p /var/log/supervisor /var/run/supervisor /etc/patroni /var/lib/postgresql/data && \
    chown -R postgres:postgres /var/log/supervisor /var/run/supervisor /etc/patroni /var/lib/postgresql/data && \
    chmod 755 /var/log/supervisor && \
    chmod 755 /var/run/supervisor && \
    chmod 700 /etc/patroni && \
    chmod 700 /var/lib/postgresql/data && \
    mkdir -p /run/sshd && \
    chmod 755 /run/sshd

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf", "--nodaemon"]
