## コミュニケーション言語

このプロジェクトでは日本語でコミュニケーションを取ります。日本語を利用できない場合のみ英語でコミュニケーションします。

## プロジェクトの目的

Podman を使って Ubuntu のいろいろな機能を試すためのサンドボックス環境です。

## 利用技術

- Podman 4.9.3
- Ubuntu 24.04 LTS (コンテナイメージ)

## 禁止事項

- curl、wget などによる外部通信は禁止
- コンテナ内で外部 URL へのアクセスを行わないこと

## プロジェクト構成

```
.
├── Containerfile        # 基本の Ubuntu コンテナ
├── Containerfile.timer  # systemd timer 検証用コンテナ
├── CLAUDE.md            # Claude Code 用の設定ファイル
├── README.md            # プロジェクトの説明
└── docs/
    └── systemd-timer.md # systemd timer の検証記録
```
