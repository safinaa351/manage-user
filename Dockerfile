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

# Create a simple health check route for Railway
RUN echo '<?php\n\
use Illuminate\Support\Facades\Route;\n\
\n\
Route::get("/", function () {\n\
    return view("welcome");\n\
});\n\
\n\
Route::get("/health", function () {\n\
    return response()->json(["status" => "ok", "timestamp" => now()], 200);\n\
});' > /tmp/health_routes.php

# Append health route to existing web routes if it doesn't exist
RUN if ! grep -q "/health" routes/web.php; then \
    echo '' >> routes/web.php && \
    echo '// Health check route for Railway' >> routes/web.php && \
    echo 'Route::get("/health", function () {' >> routes/web.php && \
    echo '    return response()->json(["status" => "ok", "timestamp" => now()], 200);' >> routes/web.php && \
    echo '});' >> routes/web.php; \
fi

# Create the start script
RUN echo '#!/bin/bash\n\
set -e\n\
\n\
echo "Starting Laravel application..."\n\
\n\
# Generate app key if not set\n\
if [ -z "$APP_KEY" ]; then\n\
    echo "Generating application key..."\n\
    php artisan key:generate --force --no-interaction\n\
fi\n\
\n\
# Set proper permissions again\n\
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache\n\
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache\n\
\n\
# Wait for database to be ready (with shorter timeout for faster startup)\n\
echo "Checking database connection..."\n\
COUNTER=0\n\
until php artisan migrate:status > /dev/null 2>&1 || [ $COUNTER -gt 15 ]; do\n\
    echo "Database not ready, waiting... ($COUNTER/15)"\n\
    sleep 1\n\
    COUNTER=$((COUNTER + 1))\n\
done\n\
\n\
if [ $COUNTER -gt 15 ]; then\n\
    echo "Database connection timeout, skipping migrations..."\n\
else\n\
    echo "Database ready! Running migrations..."\n\
    php artisan migrate --force --no-interaction\n\
fi\n\
\n\
# Clear and optimize for production\n\
echo "Optimizing Laravel..."\n\
php artisan config:clear\n\
php artisan route:clear\n\
php artisan view:clear\n\
php artisan config:cache\n\
php artisan route:cache\n\
php artisan view:cache\n\
\n\
echo "Starting Apache server..."\n\
# Start Apache in foreground\n\
exec apache2-foreground' > /usr/local/bin/start.sh

RUN chmod +x /usr/local/bin/start.sh

# Expose port 80
EXPOSE 80

# Use the start script as the default command
CMD ["/usr/local/bin/start.sh"]
