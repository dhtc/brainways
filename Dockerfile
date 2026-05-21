FROM python:3.12 AS base

# 1. 安装系统依赖：替换为适用于新版 Debian 的库名
RUN apt-get update && apt-get install -y \
    libgl1 \
    libegl1 \
    libglx0 \
    libglib2.0-0 \
    libqt5gui5 \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

FROM base AS build

RUN pip install --no-cache-dir uv
RUN uv pip install --system --no-cache brainways PyQt5

# 2. 关键步骤：在虚拟显示中预下载依赖
# 设置环境变量以确保 Qt 在无头模式下能通过 Xvfb 运行
ENV QT_QPA_PLATFORM=xcb
RUN xvfb-run --auto-servernum --server-args="-screen 0 1024x768x24" \
    bash -c "timeout 300s brainways ui || echo 'Initialization finished'"

CMD ["brainways", "ui"]
