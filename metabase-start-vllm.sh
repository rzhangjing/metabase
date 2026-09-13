#!/bin/bash
# ============================================================
# Metabase 启动脚本 (JAR 方式)
# 用途: 连接局域网中部署的 vLLM 服务
# ============================================================

# -------------------- 1. 基础配置 --------------------
# Metabase JAR 文件路径 (请修改为实际路径)
METABASE_JAR="/opt/metabase/metabase.jar"

# Metabase 监听端口 (默认 3000)
export MB_JETTY_PORT=3000

# vLLM 服务地址 (请修改为局域网中 vLLM 的实际 IP 和端口)
VLLM_HOST="127.0.0.1"
VLLM_PORT="8000"
VLLM_MODEL_NAME="your-model-name"  # 与 vLLM --served-model-name 保持一致
VLLM_API_KEY="token-abc123"        # 与 vLLM --api-key 保持一致

# -------------------- 2. 网络权限配置 (关键) --------------------
# 允许 Metabase 访问私有网络地址 (RFC1918: 10.x, 192.168.x, 172.16-31.x)
# 这是连接局域网 vLLM 服务的必要配置
export MB_ALLOW_PRIVATE_NETWORK_FETCH=true
export MB_LLM_ALLOWED_NETWORKS="allow-all"

# -------------------- 3. AI 提供商配置 --------------------
# 指定 Metabot 使用的 AI 提供商和模型
# 格式: provider/model-name，使用 custom 表示 OpenAI 兼容的自定义端点
export MB_LLM_METABOT_PROVIDER="custom/${VLLM_MODEL_NAME}"
#export MB_LLM_METABOT_PROVIDER="vllm/${VLLM_MODEL_NAME}}"

# 设置 vLLM 服务的 Base URL
export MB_LLM_CUSTOM_API_BASE_URL="http://${VLLM_HOST}:${VLLM_PORT}/v1"

# 设置 vLLM 服务的 API Key
export MB_LLM_CUSTOM_API_KEY="${VLLM_API_KEY}"

# 设置 vLLM 超时时间
export MB_LLM_VLLM_REQUEST_TIMEOUT_MS="300000"

# 启用 Metabot AI 功能
export MB_METABOT_ENABLED=true

# -------------------- 4. 应用数据库配置 (可选，生产环境推荐) --------------------
# 如果使用 PostgreSQL 作为 Metabase 的应用数据库，取消以下注释并修改配置
# export MB_DB_TYPE=postgres
# export MB_DB_DBNAME=metabase
# export MB_DB_PORT=5432
# export MB_DB_USER=metabase
# export MB_DB_PASS=your_password
# export MB_DB_HOST=localhost

# -------------------- 5. 启动 Metabase --------------------
echo "正在启动 Metabase..."
echo "vLLM 地址: http://${VLLM_HOST}:${VLLM_PORT}/v1"
echo "模型名称: ${VLLM_MODEL_NAME}"

java --add-opens java.base/java.nio=ALL-UNNAMED -jar /home/ubuntu/metabase/target/uberjar/metabase.jar
