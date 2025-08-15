FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite
RUN a2enmod headers

# Install PHP extensions
RUN docker-php-ext-install \
    pdo_mysql \
    zip \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd

# Set Apache document root to Laravel's public directory
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Copy application code
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html
RUN chmod -R 775 /var/www/html/storage
RUN chmod -R 775 /var/www/html/bootstrap/cache

# Configure Apache ServerName to suppress warnings
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Create .env file with basic configuration if it doesn't exist
RUN if [ ! -f .env ]; then cp .env.example .env; fi

# Generate application key if needed
RUN php artisan key:generate --no-interaction || true

# Create the start script
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
# Generate app key if not set\n\
if [ -z "$APP_KEY" ]; then\n\
    php artisan key:generate --force --no-interaction\n\
fi\n\
\n\
# Wait for database to be ready (with timeout)\n\
echo "Waiting for database connection..."\n\
COUNTER=0\n\
until php artisan migrate:status > /dev/null 2>&1 || [ $COUNTER -gt 30 ]; do\n\
    echo "Database not ready, waiting... ($COUNTER/30)"\n\
    sleep 2\n\
    COUNTER=$((COUNTER + 1))\n\
done\n\
\n\
if [ $COUNTER -gt 30 ]; then\n\
    echo "Database connection timeout, but continuing..."\n\
else\n\
    echo "Database ready! Running migrations..."\n\
    php artisan migrate --force\n\
fi\n\
\n\
# Clear and cache config for production\n\
php artisan config:cache\n\
php artisan route:cache\n\
php artisan view:cache\n\
\n\
echo "Starting Apache..."\n\
# Start Apache in foreground\n\
exec apache2-foreground' > /usr/local/bin/start.sh

RUN chmod +x /usr/local/bin/start.sh

# Expose port 80
EXPOSE 80

# Use the start script as the default command
CMD ["/usr/local/bin/start.sh"]
