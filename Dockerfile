FROM php:8.2-fpm

WORKDIR /var/www

# library linux
RUN apt-get update -y && apt-get install -y \
  libicu-dev \
  libmariadb-dev \
  unzip zip \
  zlib1g-dev \
  libpng-dev \
  libjpeg-dev \
  libfreetype6-dev \
  libjpeg62-turbo-dev

#composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

#php extention
RUN docker-php-ext-install gettext intl pdo_mysql gd

RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg \
  && docker-php-ext-install -j$(nproc) gd

#add user untuk projek laravel-docker
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

COPY . /var/www

COPY --chown=www:www . /var/www

USER www

EXPOSE 9000
CMD ["php-fpm"]