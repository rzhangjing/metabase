#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

# 用 DeepSeek 官方 API 启动 Metabase
# 用法:
#   export MB_LLM_DEEPSEEK_API_KEY=sk-xxxx
#   ./metabase-start-deepseek.sh
# 或者一行:
#   MB_LLM_DEEPSEEK_API_KEY=sk-xxxx ./metabase-start-deepseek.sh

export MB_LLM_ALLOWED_NETWORKS="allow-all"
export MB_LLM_DEEPSEEK_API_KEY=""
export MB_LLM_DEEPSEEK_API_BASE_URL="${MB_LLM_DEEPSEEK_API_BASE_URL:-https://api.deepseek.com}"
export MB_LLM_METABOT_PROVIDER="${MB_LLM_METABOT_PROVIDER:-deepseek/deepseek-v4-pro}"
export MB_LLM_MINI_MODEL="${MB_LLM_MINI_MODEL:-deepseek/deepseek-v4-flash}"

java --add-opens java.base/java.nio=ALL-UNNAMED -jar /home/ubuntu/metabase/target/uberjar/metabase.jar
