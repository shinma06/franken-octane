#!/bin/sh
set -e

# キャッシュクリア＆再生成（起動時に環境変数が揃った状態で実行）
php artisan config:cache
php artisan route:cache
php artisan view:cache

# マイグレーション（チーム環境では削除してCIで実行することを推奨）
php artisan migrate --force

# FrankenPHP + Octane で起動
exec php artisan octane:start \
    --server=frankenphp \
    --host=0.0.0.0 \
    --port=8080
