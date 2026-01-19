# 1. 使用 Astral 官方提供的 Python + uv 基础镜像
# 这是一个基于 Debian Bookworm Slim 的镜像，预装了 Python 3.12 和 uv
# 它可以帮你省去手动安装 uv 的麻烦
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

# 2. 设置工作目录
WORKDIR /app

# 3. 环境变量设置
# ENV UV_COMPILE_BYTECODE=1  # 可选：编译字节码，启动更快

# 关键：告诉 uv 直接安装到系统 Python，不要创建 venv (在容器里没必要用 venv)
ENV UV_SYSTEM_PYTHON=1

# 4. 先只拷贝依赖文件（利用 Docker 缓存层）
# 只要这两个文件没变，下次构建就不会重新下载依赖，速度飞快
COPY pyproject.toml uv.lock ./

# 5. 安装依赖
# --frozen: 严格按照 uv.lock 安装，不更新版本
RUN uv sync --frozen --no-install-project

# 6. 拷贝剩下的源代码
COPY . .

# 7. (可选) 如果你的项目作为包安装，可以运行这一步，否则直接运行脚本
# RUN uv sync --frozen

# 8. 启动命令
# 这里假设你的入口文件是 main.py
CMD ["python", "main.py"]
