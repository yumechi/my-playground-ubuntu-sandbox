# Ubuntu Sandbox

> Note: これは個人の実験・学習用リポジトリです。コードの品質や動作は保証しません。

Podman を使って Ubuntu のいろいろな機能を試すためのサンドボックス環境です。

## 開発環境

2026/02/03 現在、個人で Cursor と Claude Code を使って開発しています。

コンテナランタイムとして Podman を使用しています。

## プロジェクトの目的

Podman コンテナ上で Ubuntu 24.04 LTS の機能を安全に試すことができる環境を提供します。

## 環境構築/操作用のコマンド

### イメージのビルド

```bash
podman build -t ubuntu-sandbox .
```

### コンテナの起動（対話モード）

```bash
podman run -it --rm ubuntu-sandbox
```

### コンテナの起動（バックグラウンド）

```bash
podman run -d --name ubuntu-sandbox ubuntu-sandbox sleep infinity
podman exec -it ubuntu-sandbox /bin/bash
```

### コンテナの停止・削除

```bash
podman stop ubuntu-sandbox
podman rm ubuntu-sandbox
```

## systemd timer 検証用コンテナ

### イメージのビルド

```bash
podman build -f Containerfile.timer -t ubuntu-timer .
```

### コンテナの起動（systemd 有効）

```bash
podman run -d --name ubuntu-timer --privileged ubuntu-timer
```

### コンテナへのアクセス

```bash
podman exec -it ubuntu-timer /bin/bash
```

### timer の基本操作（コンテナ内で実行）

```bash
# timer 一覧を確認
systemctl list-timers

# timer の状態確認
systemctl status <timer-name>.timer

# timer の有効化
systemctl enable --now <timer-name>.timer
```

### コンテナの停止・削除

```bash
podman stop ubuntu-timer
podman rm ubuntu-timer
```

## 参照しているツール/フレームワークのライセンス

- Ubuntu: Various (GPL, LGPL, etc.)
- Podman: Apache License 2.0

## ライセンス
