### Etapa 1: Build do frontend com Vite
FROM node:18 AS node-builder

WORKDIR /app
COPY . .

RUN npm install && npm run build


### Etapa 2: Backend Laravel com PHP
FROM php:8.2-fpm

WORKDIR /var/www

# Instala dependências necessárias (sem sqlite)
RUN apt-get update && apt-get install -y \
    zip unzip curl git libxml2-dev libzip-dev libpng-dev libjpeg-dev libonig-dev \
    libpq-dev libjpeg-dev libpng-dev libzip-dev

# Extensões do PHP
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring exif pcntl bcmath gd zip

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copia os arquivos da aplicação
COPY . /var/www
COPY --chown=www-data:www-data . /var/www

# Copia os assets compilados do frontend
COPY --from=node-builder /app/public/build /var/www/public/build

# Instala dependências PHP
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Gera a APP_KEY (somente se ainda não for fornecida pelo ambiente)
RUN php artisan key:generate || true

EXPOSE 8000

CMD sh -c "php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000"
