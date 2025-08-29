# 監視ガイド

## 毎日チェック

### 1. サイトの稼働状況確認
**URL**: https://tunebox.jp/health
**確認内容**: システム全体の健全性
**期待される結果**: `{"status":"ok","timestamp":"..."}`

### 2. エラーログの確認
**Railway Dashboard**: https://railway.app/dashboard
**確認項目**: アプリケーションエラー、データベースエラー
**ログレベル**: INFO, ERROR, WARN

### 3. Google Analyticsの確認
**URL**: https://analytics.google.com/
**測定ID**: G-Y9B2RHTCH7
**確認項目**: PV数、ユーザー数、ページビュー

### 4. パフォーマンスメトリクスの確認
**URL**: https://tunebox.jp/health/detailed
**確認項目**: レスポンスタイム、メモリ使用量、ディスク使用量

## 毎週チェック

### 1. セキュリティログの確認
**Railway Dashboard**: セキュリティ関連のログ
**CSP違反**: ブラウザの開発者ツール > Console
**確認項目**: 不正アクセス、CSP違反

### 2. バックアップの実行確認
**コマンド**: `rails backup:database`（本番環境）
**確認項目**: バックアップファイルの作成
**保存場所**: `backups/`ディレクトリ

### 3. ユーザー登録数の確認
**データベース**: `SELECT COUNT(*) FROM users;`
**Google Analytics**: ユーザー登録イベント
**確認項目**: 新規ユーザー数、アクティブユーザー数

### 4. CSP違反ログの確認
**ブラウザ**: 開発者ツール > Console
**確認項目**: Content Security Policy違反

## 毎月チェック

### 1. セキュリティアップデートの確認
**Rails**: `bundle outdated`
**Ruby**: `ruby -v`（最新版との比較）
**確認項目**: セキュリティパッチの適用状況

### 2. パフォーマンスメトリクスの分析
**Google Analytics**: ページ読み込み速度
**Railway**: リソース使用量
**確認項目**: レスポンスタイムの推移

### 3. バックアップの整合性チェック
**コマンド**: `rails backup:verify`
**確認項目**: バックアップファイルの整合性

### 4. 運用改善の検討
**ユーザーフィードバック**: アンケート、問い合わせ
**パフォーマンス**: ボトルネックの特定
**セキュリティ**: 脆弱性の確認

## 監視ツール

### Railway Dashboard
**URL**: https://railway.app/dashboard
**確認項目**: デプロイ状況、ログ、リソース使用量

### Google Analytics
**URL**: https://analytics.google.com/
**設定**: 既に実装済み（G-Y9B2RHTCH7）

### ヘルスチェックエンドポイント
**基本**: https://tunebox.jp/health
**詳細**: https://tunebox.jp/health/detailed

### エラーログ
**Railway**: リアルタイムログ
**アプリケーション**: カスタムログ（実装済み）

## 自動監視スクリプト例

### ヘルスチェック
```bash
#!/bin/bash
# 毎日実行するスクリプト
curl -f https://tunebox.jp/health || echo "サイトがダウンしています"
```

### バックアップ
```bash
#!/bin/bash
# 毎週実行するスクリプト
rails backup:database
rails backup:cleanup
```

## 緊急時対応

### サイトダウン時
1. Railway Dashboardでデプロイ状況を確認
2. ログでエラー原因を特定
3. 必要に応じてロールバック

### セキュリティインシデント
1. ログで不正アクセスを確認
2. 必要に応じてセッション無効化
3. セキュリティパッチの適用

### データベースエラー
1. バックアップから復旧
2. データベース接続を確認
3. 必要に応じてマイグレーション実行
