FROM debian:bullseye

RUN set -eux; \
        apt-get update; \
        DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        mariadb-server \
        mariadb-client && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

COPY ./conf/mariadb.cnf /etc/mysql/mariadb.conf.d/mariadb.conf
COPY ./tools/init.sh /init.sh

RUN chmod +x init.sh

EXPOSE 3306

CMD ["sh", "init.sh"]
