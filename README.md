# wordpress-docker-migration

WordPress の Xserver 環境を Docker に移行する手順

## 1. 現在の WordPress 環境のバックアップ

まず、現在の Xserver にある WordPress サイトのデータとデータベースのバックアップを取得します。

### ファイルバックアップ

- FTP/SFTP を使用して、`wp-content`ディレクトリ（テーマ、プラグイン、アップロードファイルが含まれる）を含むすべての WordPress ファイルをローカルにダウンロードします。

### データベースバックアップ

- phpMyAdmin や Xserver の管理画面を使用して、WordPress のデータベースをエクスポートします。通常、SQL ファイルとしてエクスポートされます。

## 2. Docker 環境のセットアップ

Docker Compose を使用して、WordPress 環境をセットアップします。以下の手順で進めてください。  
※詳細な設定については、Docker の公式ドキュメントやリファレンスを参照してください。

1. （初回のみ）Doccker Desktop をダウンロード

- ref: <https://www.docker.com/ja-jp/products/docker-desktop/>

2. Docker Desktop を起動

3. Docker Compose を使用して環境を起動

   ```bash
   docker-compose up -d
   ```

## 3. 新しい Docker コンテナにファイルを移行

### wp-content ディレクトリの移行

バックアップした `wp-content` ディレクトリを、Docker コンテナ内の適切なディレクトリにコピーします。`docker cp`コマンドを使用して移行を行います。

```bash
docker cp ./wp-content wordpress:/var/www/html/wp-content
```

## 4. データベースの復元

1. **新しいデータベースに接続**:
   Docker コンテナ内の MySQL にアクセスし、データベースの復元を行います。

   ```bash
    docker exec -it wordpress_db bash
   ```

2. **データベースにインポート**:
   バックアップした SQL ファイルをコンテナにコピーし、MySQL にログインしてデータをインポートします。

   ```bash
    mysql -u wordpress -p wordpress < /backup.sql
   ```

   ここで、/backup.sql は、バックアップした SQL ファイルのパスです。ファイルを docker cp コマンドでコンテナ内にコピーしておく必要があります。

   ```bash
    docker cp ./backup.sql wordpress_db:/backup.sql
   ```

## 5. WordPress 設定の更新

Xserver で使用していた`wp-config.php`ファイル内のデータベース設定を、Docker 用に修正します。

```php

define('DB_NAME', 'wordpress');
define('DB_USER', 'wordpress');
define('DB_PASSWORD', 'wordpress');
define('DB_HOST', 'db');

```

## 6. ドメインとパーマリンクの更新

- WordPress の管理画面にアクセスし、設定 > 一般からドメインが正しく設定されていることを確認します。
- 設定 > パーマリンクから、パーマリンク設定を再保存して、適切にリンクが機能するようにします。

## 7. 動作確認

ブラウザから新しい環境の WordPress サイトにアクセスし、全てが正常に動作しているか確認します。特に、ページの表示、プラグイン、テーマ、メディアファイルが正しく動作しているかを確認してください。
