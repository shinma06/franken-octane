
FROM dunglas/frankenphp:1.12.0-php8.5

WORKDIR /app

# PHP拡張インストール
RUN install-php-extensions \
    pdo_pgsql pgsql pcntl zip opcache

# Composerのイメージからコピー
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 依存インストール: --no-scripts でスクリプト(post-autoload-dump)の自動実行を抑制
COPY composer.json composer.lock ./
RUN composer install --no-interaction --prefer-dist --no-scripts

COPY . .

# post-autoload-dump を手動実行（artisanが存在する状態で）
# インストールされたパッケージをlaravelに認識させる
RUN composer run-script post-autoload-dump

# laravelプロセスがファイルを書き込むディレクトリに権限を付与
RUN chmod -R 775 storage bootstrap/cache

# 起動スクリプト経由で起動
COPY --chmod=775 docker/entrypoint.sh /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
