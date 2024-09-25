#!/bin/sh

# Download and extract WordRress
wget -O /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz
tar -xzf /tmp/wordpress.tar.gz -C /var/www/html

# Set owership and permissions
mkdir -p /run/php
chown -R www-data:www-data /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress

# Configure PHP-FPM
sed -i 's#listen = /run/php/php7.4-fpm.sock#listen = 0.0.0.0:9000#g' /etc/php/7.4/fpm/pool.d/www.conf

# Set up Wordpress configuration
cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

sed -i "s/database_name_here/${DB_NAME}/" /var/www/html/wordpress/wp-config.php
sed -i "s/username_here/${DB_USER}/" /var/www/html/wordpress/wp-config.php
sed -i "s/password_here/${DB_USER_PASS}/" /var/www/html/wordpress/wp-config.php
sed -i "s/localhost/mariadb:3306/" /var/www/html/wordpress/wp-config.php

# Download and install wp-cli
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Configure WordPress
wp core install --allow-root --url=${DOMAIN_NAME} --title="Inception" \
   --admin_user=${WP_ADMIN} --admin_password=${WP_ADMIN_PASS} \
   --admin_email="admin@example.com" --skip-email --path=/var/www/html/wordpress

wp user create --allow-root ${WP_USER} --skip-email --user_pass=${WP_USER_PASS} \
   --path=/var/www/html/wordpress --url=${DOMAIN_NAME}

wp theme install twentytwenty --activate --allow-root --path=/var/www/html/wordpress

# ************ BONUS REDIS *****************

# Install and activate the Redis Object Cache plugin
#descomentar para bonus
#wp plugin install redis-cache --activate --allow-root --path=/var/www/html/wordpress
#wp plugin update --all --allow-root --path=/var/www/html/wordpress

# Update wp-config.php with environment variables
# Insert Redis configuration before the line "That's all, stop editing! Happy publishing."
#sed -i "/\/\* That's all, stop editing! Happy publishing. \*\//i \
#define('WP_REDIS_HOST', 'redis');\n\
#define('WP_REDIS_PORT', 6379);" /var/www/html/wordpress/wp-config.php

#sleep 5
#wp redis enable --allow-root --path=/var/www/html/wordpress

# ************** FIN BONUS *******************

# Start PHP-FPM
exec php-fpm7.4 -F