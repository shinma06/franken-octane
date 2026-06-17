#!/bin/sh
set -e

# wayfinder の型生成（PHP側で実行）
php artisan wayfinder:generate --with-form

php artisan config:clear
php artisan route:clear
php artisan view:clear

php artisan migrate --force

# FrankenPHP + Octane で起動
exec php artisan octane:start \
    --server=frankenphp \
    --host=0.0.0.0 \
    --port=8080 \
    --workers=1 \
    --max-requests=1
