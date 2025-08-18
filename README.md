# 🎵 TuneBox

**音楽好きのための、音楽好きによるアルバムコレクションアプリ**

TuneBoxは、Spotify Web APIを活用してアルバムを検索し、お気に入りのジャケット写真を自由に配置できるインタラクティブなコレクション機能を提供する音楽アプリです。

[![Ruby on Rails](https://img.shields.io/badge/Ruby%20on%20Rails-7.2.2-red)](https://rubyonrails.org/)
[![Ruby](https://img.shields.io/badge/Ruby-3.1.0-red)](https://www.ruby-lang.org/)
[![Spotify API](https://img.shields.io/badge/Spotify%20API-Web%20API-green)](https://developer.spotify.com/documentation/web-api/)

## 🌟 主な機能

### 🔍 **アルバム検索**
- Spotify Web APIを使用したリアルタイム検索
- アーティスト名・アルバム名での高速検索
- ページネーション対応（20件ずつ表示）
- 全1000件以上のアルバムから検索可能

### ❤️ **お気に入り機能**
- ワンクリックでアルバムをコレクションに追加
- 最大20枚までのキュレーション
- Ajax通信によるスムーズな操作感
- リアルタイムでの追加・削除

### 🎨 **インタラクティブコレクション**
- **ドラッグ&ドロップ**: ジャケット写真を自由に移動
- **個別サイズ調整**: 各ジャケットのサイズを変更可能
- **クイックレイアウト**: グリッド・サークル・ランダム配置
- **キーボード操作**: 矢印キーで微調整、Deleteで削除
- **レイアウト保存**: 配置情報をデータベースに永続化

### 📱 **レスポンシブデザイン**
- Bootstrap 5を使用したモダンなUI
- スマートフォン・タブレット・デスクトップ対応
- ホバーエフェクト・スムーズアニメーション
- 直感的な操作インターフェース

## 🛠️ 技術スタック

### **バックエンド**
- **Ruby on Rails 7.2.2** - メインフレームワーク
- **Ruby 3.1.0** - プログラミング言語
- **SQLite3** - 開発環境用データベース
- **PostgreSQL** - 本番環境用データベース

### **フロントエンド**
- **Bootstrap 5** - UIフレームワーク
- **JavaScript (ES6+)** - インタラクティブ機能
- **Font Awesome** - アイコンライブラリ
- **Google Fonts** - Webフォント

### **外部API**
- **Spotify Web API** - 音楽データ取得
- **HTTParty** - HTTP通信ライブラリ

### **インフラ・デプロイ**
- **Heroku** - 本番環境
- **Git/GitHub** - バージョン管理

## 📋 セットアップ

### 前提条件
- Ruby 3.1.0
- Rails 7.2.2
- Node.js (アセット管理用)
- Git

### インストール手順

1. **リポジトリのクローン**
```bash
git clone https://github.com/yourusername/tune-box.git
cd tune-box
```

2. **依存関係のインストール**
```bash
bundle install
```

3. **データベースのセットアップ**
```bash
rails db:migrate
```

4. **環境変数の設定**
`.env`ファイルを作成し、Spotify APIの認証情報を設定：
```bash
SPOTIFY_CLIENT_ID=your_spotify_client_id
SPOTIFY_CLIENT_SECRET=your_spotify_client_secret
```

5. **サーバーの起動**
```bash
rails server
```

6. **ブラウザでアクセス**
```
http://localhost:3000
```

## 🎯 Spotify API設定

1. [Spotify Developer Dashboard](https://developer.spotify.com/dashboard)にアクセス
2. 新しいアプリを作成
3. Client IDとClient Secretを取得
4. `.env`ファイルに認証情報を設定

## 🚀 デプロイ

### Herokuへのデプロイ

1. **Herokuアプリの作成**
```bash
heroku create your-app-name
```

2. **環境変数の設定**
```bash
heroku config:set SPOTIFY_CLIENT_ID=your_client_id
heroku config:set SPOTIFY_CLIENT_SECRET=your_client_secret
```

3. **デプロイ**
```bash
git push heroku main
heroku run rails db:migrate
```

## 💡 使用方法

### 1. アルバム検索
- トップページの検索バーにアーティスト名またはアルバム名を入力
- 検索結果を20件ずつページングで閲覧
- 各アルバムの詳細情報（リリース日、収録曲数など）を確認

### 2. コレクション作成
- 検索結果のハートボタンをクリックしてお気に入りに追加
- コレクションページで自由にジャケットを配置
- ドラッグ&ドロップで位置調整
- サイズスライダーで大きさ調整

### 3. レイアウト保存
- クイックレイアウトで整列
- 保存ボタンで配置を永続化
- 次回アクセス時に同じレイアウトで表示

## 📊 アーキテクチャ

### データベース設計
```
FavoriteAlbums
├── id (Primary Key)
├── spotify_id (Spotify Album ID)
├── name (アルバム名)
├── artist (アーティスト名)
├── image_url (ジャケット画像URL)
├── position_x (X座標)
├── position_y (Y座標)
└── timestamps
```

### API設計
```
GET  /albums/index         # アルバム検索
POST /favorite_albums/toggle  # お気に入り追加/削除
GET  /favorite_albums      # コレクション一覧
POST /favorite_albums/update_layout  # レイアウト保存
```

## 🎪 技術的ハイライト

### **Spotify API連携**
- Client Credentials Flowによる認証
- アクセストークンの自動取得・管理
- レート制限対応
- エラーハンドリングの実装

### **インタラクティブUI**
- JavaScript による ドラッグ&ドロップ機能
- CSS3アニメーション・トランジション
- レスポンシブレイアウト
- UXを重視した操作感

### **パフォーマンス最適化**
- ページネーションによる効率的なデータロード
- Ajax通信によるページリロード不要の操作
- 画像の遅延読み込み対応

## 🧪 今後の拡張予定

- [ ] 楽曲検索機能
- [ ] 音響特徴分析（BPM、キー、ムード等）
- [ ] AIによる楽曲レコメンデーション
- [ ] ソーシャル機能（コレクション共有）
- [ ] Spotify再生連携
- [ ] ユーザー認証・マルチユーザー対応

## 🤝 コントリビューション

1. このリポジトリをフォーク
2. フィーチャーブランチを作成 (`git checkout -b feature/AmazingFeature`)
3. 変更をコミット (`git commit -m 'Add some AmazingFeature'`)
4. ブランチにプッシュ (`git push origin feature/AmazingFeature`)
5. プルリクエストを作成

## 📄 ライセンス

このプロジェクトはMITライセンスの下で公開されています。詳細は`LICENSE`ファイルを参照してください。

## 👨‍💻 開発者

**[あなたの名前]**
- GitHub: [@yourusername](https://github.com/yourusername)
- Email: your.email@example.com
- LinkedIn: [Your LinkedIn](https://linkedin.com/in/yourprofile)

## 🙏 謝辞

- [Spotify Web API](https://developer.spotify.com/documentation/web-api/) - 音楽データの提供
- [Ruby on Rails](https://rubyonrails.org/) - 開発フレームワーク
- [Bootstrap](https://getbootstrap.com/) - UIコンポーネント

---

**Made with ❤️ for Music Lovers**
