# Whiteboard

WhiteboardはバンドサークルのためのプライベートSNSです。
主な機能は以下です。

 * アカウント登録機能
 * 学校の時間割に合わせたタイムスケジュールでのスタジオの予約
 * メール一斉送信機能

## セットアップ

```
bundle insatll
bundle exec rake db:create
bundle exec rake db:migrate
```

## 使い方

```
bundle exec rails s -b 0.0.0.0 RAILS_ENV={ENVIRONMENT}
```

ENVIRONMENTは下記のいずれかが入ります
 * test
 * develop
 * production

## テスト

```
bundle exec rake test
```
