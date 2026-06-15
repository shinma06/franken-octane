FROM dunglas/frankenphp:1.12.0-php8.5

WORKDIR /app

# PHP拡張
RUN install-php-extensions \
    pdo_pgsql \
    pgsql \
    pcntl \
    zip \
    opcache

# Composerのイメージからコピー
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 依存インストール: --no-scripts でartisan実行を抑制
COPY composer.json composer.lock ./
RUN composer install --no-interaction --prefer-dist --no-scripts

# アプリ全体コピー（.envは.dockerignoreで除外すること）
COPY . .

# post-autoload-dump を手動実行（artisanが存在する状態で）
RUN composer run-script post-autoload-dump

# ストレージ・キャッシュのパーミッション
RUN chmod -R 775 storage bootstrap/cache

# 起動スクリプト経由で起動
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
