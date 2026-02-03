FROM ubuntu:24.04

# 非対話モードを設定
ENV DEBIAN_FRONTEND=noninteractive

# パッケージリストを更新し、基本ツールをインストール
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    git \
    sudo \
    locales \
    && rm -rf /var/lib/apt/lists/*

# 日本語ロケールを設定
RUN locale-gen ja_JP.UTF-8
ENV LANG=ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8

# 作業ディレクトリを設定
WORKDIR /workspace

# デフォルトコマンド
CMD ["/bin/bash"]
