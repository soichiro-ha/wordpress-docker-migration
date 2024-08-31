FROM wordpress:latest

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# 必要なプラグインやテーマを追加
# COPY my-custom-plugin /var/www/html/wp-content/plugins/
# COPY my-custom-theme /var/www/html/wp-content/themes/

# PHP設定ファイルを上書きする場合
# COPY custom-php.ini /usr/local/etc/php/conf.d/