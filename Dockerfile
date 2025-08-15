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

# Create the start script
RUN echo '#!/bin/bash\n\
# Wait for database to be ready\n\
echo "Waiting for database connection..."\n\
until php artisan migrate:status > /dev/null 2>&1; do\n\
    echo "Database not ready, waiting..."\n\
    sleep 2\n\
done\n\
\n\
# Run migrations\n\
php artisan migrate --force\n\
\n\
# Clear and cache config for production\n\
php artisan config:cache\n\
php artisan route:cache\n\
php artisan view:cache\n\
\n\
# Start Apache in foreground\n\
apache2-foreground' > /usr/local/bin/start.sh

RUN chmod +x /usr/local/bin/start.sh

# Expose port 80
EXPOSE 80

# Use the start script as the default command
CMD ["/usr/local/bin/start.sh"]
