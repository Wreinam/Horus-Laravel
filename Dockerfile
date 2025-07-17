# --- Estágio 1: Build do frontend com Yarn ---
    FROM node:18-alpine AS node-builder
    WORKDIR /app
    
    # Copia os arquivos de manifesto para aproveitar o cache
    COPY package.json yarn.lock ./
    
    # Instala as dependências do frontend com Yarn
    RUN yarn install
    
    # Copia o restante dos arquivos
    COPY . .
    
    # Compila os assets para produção
    RUN yarn build
    
    # --- Estágio 2: Aplicação Laravel ---
    FROM php:8.2-fpm
    WORKDIR /var/www
    
    # Instala dependências do sistema e do PHP (sem duplicatas)
    RUN apt-get update && apt-get install -y \
        git zip unzip curl \
        libpq-dev libpng-dev libjpeg-dev libonig-dev libxml2-dev libzip-dev \
        && docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd zip
    
    # Instala o Composer
    COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
    
    # Copia o código completo da aplicação ANTES de instalar as dependências
    COPY . .
    
    # Instala as dependências do Composer, permitindo rodar como root
    RUN COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --no-interaction --optimize-autoloader
    
    # Copia os assets compilados do estágio anterior
    COPY --from=node-builder /app/public/build ./public/build
    
    # Expõe a porta que o 'artisan serve' vai usar
    EXPOSE 8000
    
    # Define o comando para iniciar o servidor
    # ATENÇÃO: Rodar 'migrate' aqui não é ideal para produção.
    CMD ["sh", "-c", "php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000"]