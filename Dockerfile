# syntax=docker/dockerfile:1.7

# ----- Composer deps stage -----
FROM composer:2 AS vendor
WORKDIR /app
COPY composer.json composer.lock ./
# (copy source of the build from home to the /app in the docker file system  to allow optimized autoload)
COPY . /app 
RUN rm -f bootstrap/cache/*.php || true
RUN composer install --no-dev --no-interaction --prefer-dist --no-progress --no-ansi --no-scripts
RUN composer dump-autoload -o
# ----- Frontend assets stage (Vite) -----
FROM node:20 AS assets
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY resources/ resources/
COPY vite.config.* postcss.config.* tailwind.config.* ./ 
RUN sh -c 'cp vite.config.* postcss.config.* ./ 2>/dev/null || true'
RUN npm run build || echo "No Vite build configured; skipping."

# ----- PHP 8.3 + Apache runtime -----
FROM php:8.3-apache AS runtime
# System & PHP extensions
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libicu-dev libpng-dev libjpeg-dev libfreetype6-dev \
  && pecl install redis \
  && docker-php-ext-enable redis \
  && docker-php-ext-configure gd --with-freetype --with-jpeg \
  && docker-php-ext-install -j$(nproc) intl pdo_mysql bcmath gd zip opcache \
  && a2enmod rewrite headers expires \
  && rm -rf /var/lib/apt/lists/*



# DocumentRoot → /var/www/public
ENV APACHE_DOCUMENT_ROOT=/var/www/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
 && sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf
COPY docker/000-laravel.conf /etc/apache2/sites-available/000-laravel.conf
RUN a2dissite 000-default && a2ensite 000-laravel

# PHP config
COPY docker/php.ini /usr/local/etc/php/conf.d/php-prod.ini
# App code + vendor + built assets
COPY --chown=www-data:www-data . /var/www
COPY --from=vendor --chown=www-data:www-data /app/vendor /var/www/vendor
COPY --from=assets --chown=www-data:www-data /app/public/build /var/www/public/build

# Writable dirs
RUN mkdir -p storage bootstrap/cache \
 && chown -R www-data:www-data storage bootstrap/cache

USER www-data
EXPOSE 80