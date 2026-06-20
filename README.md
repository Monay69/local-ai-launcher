# 本地 AI 一键启动脚本

双击 `start.bat` 即可启动本地大模型 + Open WebUI 界面。

## 使用前提

- Windows 系统
- 已安装 [llama.cpp](https://github.com/ggml-org/llama.cpp/releases)
- 已安装 Open WebUI：`pip install open-webui`
- 已下载至少一个 `.gguf` 格式的模型文件

## 目录结构

```
AI\
├── llamacpp\
│   └── llama-server.exe
├── models\
│   └── 你的模型.gguf
└── start.bat
```

## 使用方法

1. 按上面的目录结构放好文件
2. 双击 `start.bat`
3. 选择要加载的模型编号
4. 等待启动完成后，浏览器打开 `http://localhost:8080`

## 推荐模型（国内 ModelScope 下载）

```bash
# 中文通用（需要 8GB+ 显存）
modelscope download Qwen/Qwen3-14B-GGUF --include "*Q4_K_M*" --local_dir ./models

# 轻量版（4GB 显存即可）
modelscope download Qwen/Qwen3.5-4B-GGUF --include "*Q4_K_M*" --local_dir ./models
```

## 注意事项

- 每次使用需要保持两个窗口运行（llama-server + Open WebUI）
- 关闭任意一个窗口会导致服务停止
- 默认参数适合 8-16GB 显存，显存较小可调低 `--ctx-size`
