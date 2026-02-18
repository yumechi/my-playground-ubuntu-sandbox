# systemd timer

Ubuntu 24.04 LTS における systemd timer の検証記録です。

## 環境

- Ubuntu 24.04.2 LTS (Noble Numbat)
- Podman 4.9.3 上で systemd コンテナとして起動

## timer とは

systemd timer は cron の代替として使用できるタスクスケジューラです。`.timer` ユニットファイルで定義され、対応する `.service` ユニットを指定した時刻やイベントに基づいて起動します。

### cron との違い

| 項目 | cron | systemd timer |
|------|------|---------------|
| ログ | 独自のログ | journalctl で統合管理 |
| 依存関係 | なし | 他のユニットとの依存関係を定義可能 |
| 実行漏れ | 電源 OFF 中は実行されない | `Persistent=true` で起動後に実行可能 |
| 精度 | 分単位 | マイクロ秒単位 |

## デフォルトで有効な timer

Ubuntu 24.04 では以下の timer がデフォルトで有効になっています。

```
UNIT                         ACTIVATES                       説明
systemd-tmpfiles-clean.timer systemd-tmpfiles-clean.service  一時ファイルの定期削除
motd-news.timer              motd-news.service               MOTD ニュースの更新
dpkg-db-backup.timer         dpkg-db-backup.service          dpkg データベースのバックアップ
apt-daily.timer              apt-daily.service               APT パッケージリストの更新
apt-daily-upgrade.timer      apt-daily-upgrade.service       APT パッケージの自動アップグレード
e2scrub_all.timer            e2scrub_all.service             ext4 ファイルシステムのスクラブ
fstrim.timer                 fstrim.service                  SSD の TRIM 実行
```

## 基本コマンド

### timer 一覧の確認

```bash
systemctl list-timers --all
```

### 特定の timer の状態確認

```bash
systemctl status apt-daily.timer
```

### timer の設定内容を確認

```bash
systemctl cat apt-daily.timer
```

### timer の有効化・無効化

```bash
# 有効化（即時起動）
systemctl enable --now <timer-name>.timer

# 無効化
systemctl disable --now <timer-name>.timer
```

## timer ユニットファイルの構造

### 例: apt-daily.timer

```ini
[Unit]
Description=Daily apt download activities

[Timer]
OnCalendar=*-*-* 6,18:00
RandomizedDelaySec=12h
Persistent=true

[Install]
WantedBy=timers.target
```

### 主要なオプション

| オプション | 説明 |
|-----------|------|
| `OnCalendar` | カレンダー形式で実行時刻を指定 |
| `OnBootSec` | システム起動後の経過時間で実行 |
| `OnUnitActiveSec` | 対応サービスの最終実行からの経過時間で実行 |
| `RandomizedDelaySec` | 実行時刻にランダムな遅延を追加 |
| `Persistent` | `true` の場合、実行漏れを起動後に実行 |

### OnCalendar の書式例

| 書式 | 説明 |
|------|------|
| `*-*-* 00:00:00` | 毎日 0 時 |
| `*-*-* 6,18:00` | 毎日 6 時と 18 時 |
| `Mon *-*-* 00:00:00` | 毎週月曜 0 時 |
| `*-*-01 00:00:00` | 毎月 1 日 0 時 |
| `hourly` | 毎時 |
| `daily` | 毎日 |
| `weekly` | 毎週 |

## カスタム timer の作成例

### 1. service ファイルの作成

`/etc/systemd/system/my-task.service`:

```ini
[Unit]
Description=My custom task

[Service]
Type=oneshot
ExecStart=/usr/local/bin/my-script.sh
```

### 2. timer ファイルの作成

`/etc/systemd/system/my-task.timer`:

```ini
[Unit]
Description=Run my task every hour

[Timer]
OnCalendar=hourly
Persistent=true

[Install]
WantedBy=timers.target
```

### 3. timer の有効化

```bash
systemctl daemon-reload
systemctl enable --now my-task.timer
```

## 参考資料

- [systemd.timer(5) - freedesktop.org](https://www.freedesktop.org/software/systemd/man/systemd.timer.html)
- [systemd/Timers - ArchWiki](https://wiki.archlinux.org/title/Systemd/Timers)
