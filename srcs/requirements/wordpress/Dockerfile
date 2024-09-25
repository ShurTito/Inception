FROM debian:bullseye

RUN set -eux; \
    apt-get update; \
    mkdir -p /var/www/html && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    php \
    php-fpm \
    php-mysql \
    wget \
    tar

COPY /tools/wordpress.sh .

EXPOSE 9000

RUN chmod +x wordpress.sh

CMD ["sh", "wordpress.sh"]