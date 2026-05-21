FROM python:3.12 AS base

# 1. 安装系统依赖：包含运行库和虚拟显示工具 xvfb
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libqt5gui5 \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

FROM base AS build

RUN pip install --no-cache-dir uv
RUN uv pip install --system --no-cache brainways PyQt5

# 2. 关键步骤：在虚拟显示环境中运行一次，触发资源下载
# 我们使用 timeout 确保它在完成初始化（或运行一段时间）后自动退出，防止构建挂起
RUN xvfb-run --auto-servernum --server-args="-screen 0 1024x768x24" \
    bash -c "timeout 300s brainways ui || echo 'Initialization finished or timed out'"

# 设置容器启动时的默认命令
CMD ["brainways", "ui"]
